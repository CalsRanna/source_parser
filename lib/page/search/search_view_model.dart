import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:charset/charset.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/information_entity.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/model/cover_entity.dart';
import 'package:source_parser/model/search_result_entity.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/semaphore.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class SearchViewModel {
  final controller = TextEditingController();
  final isSearching = signal(false);
  final searchedResults = signal(<SearchResultEntity>[]);
  final trendingBooks = signal(<BookEntity>[]);
  final view = signal('trending');

  void clearController(BuildContext context) {
    _dismissMaterialBanner(context);
    controller.clear();
    view.value = 'trending';
  }

  void dispose() {
    controller.dispose();
  }

  Future<void> initSignals() async {
    var storedCacheDuration = await SharedPreferenceUtil.getCacheDuration();
    var cacheDuration = Duration(hours: storedCacheDuration.floor());
    var storedTimeout = await SharedPreferenceUtil.getTimeout();
    var timeout = Duration(milliseconds: storedTimeout);
    var books = await Parser.topSearch(cacheDuration, timeout);
    trendingBooks.value =
        books.map((book) => BookEntity.fromJson(book.toJson())).toList();
  }

  void navigateInformationPage(
      BuildContext context, SearchResultEntity result) {
    removeCurrentMaterialBanner(context);
    var information = InformationEntity(
      book: result.book,
      chapters: [],
      availableSources: result.availableSources,
      covers: result.covers,
    );
    InformationRoute(information: information).push(context);
  }

  void removeCurrentMaterialBanner(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
  }

  Future<void> search(BuildContext context) async {
    searchedResults.value.clear();
    isSearching.value = true;
    view.value = 'result';
    _openMaterialBanner(context);
    var credential = controller.text;
    var storedCacheDuration = await SharedPreferenceUtil.getCacheDuration();
    var cacheDuration = Duration(hours: storedCacheDuration.floor());
    var storedTimeout = await SharedPreferenceUtil.getTimeout();
    var timeout = Duration(milliseconds: storedTimeout);
    var storedMaxConcurrent = await SharedPreferenceUtil.getMaxConcurrent();
    var maxConcurrent = storedMaxConcurrent.floor();
    var stream =
        _searchBooks(credential, maxConcurrent, cacheDuration, timeout);
    stream.listen(_listenStream, onDone: () {
      isSearching.value = false;
      if (!context.mounted) return;
      _dismissMaterialBanner(context);
    }, onError: (error) {
      logger.e(error);
    });
  }

  void _dismissMaterialBanner(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  SearchResultEntity? _getExistingBook(SearchResultEntity result) {
    return searchedResults.value.where((item) {
      return item.book.name == result.book.name &&
          item.book.author == result.book.author;
    }).firstOrNull;
  }

  Future<SearchResultEntity?> _getFilteredResult(
      SearchResultEntity result) async {
    // var entity = BookEntity.fromJson(result.toJson());
    var searchFilter = await SharedPreferenceUtil.getSearchFilter();
    if (!searchFilter) return result;
    final conditionA = result.book.name.contains(controller.text);
    final conditionB = result.book.author.contains(controller.text);
    final filtered = conditionA || conditionB;
    return filtered ? result : null;
  }

  void _listenStream(SearchResultEntity result) async {
    final filteredResult = await _getFilteredResult(result);
    if (filteredResult == null) return;
    var existingBook = _getExistingBook(filteredResult);
    if (existingBook == null) {
      searchedResults.value = [...searchedResults.value, filteredResult];
      return;
    }
    // existingBook.sources.addAll(filteredBook.sources);
    if (filteredResult.book.introduction.length >
        existingBook.book.introduction.length) {
      existingBook.book.introduction = filteredResult.book.introduction;
    }
    if (filteredResult.book.cover.length > existingBook.book.cover.length) {
      existingBook.book.cover = filteredResult.book.cover;
    }
    existingBook.covers.addAll(filteredResult.covers);
    existingBook.availableSources.addAll(filteredResult.availableSources);
    searchedResults.value = [...searchedResults.value];
  }

  void _openMaterialBanner(BuildContext context) {
    var messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentMaterialBanner();
    var indicator = CircularProgressIndicator(strokeWidth: 1);
    var children = [
      SizedBox(height: 16, width: 16, child: indicator),
      const SizedBox(width: 8),
      Expanded(child: Text('正在搜索 “${controller.text}”')),
    ];
    var materialBanner = MaterialBanner(
      actions: [const SizedBox()],
      content: Row(children: children),
      dividerColor: Colors.transparent,
    );
    messenger.showMaterialBanner(materialBanner);
  }

  Stream<SearchResultEntity> _searchBooks(
    String credential,
    int maxConcurrent,
    Duration duration,
    Duration timeout,
  ) async* {
    final sources = await SourceService().getEnabledBookSources();
    final directory = await getTemporaryDirectory();
    final network = CachedNetwork(
      temporaryDirectory: directory,
      timeout: timeout,
    );
    final controller = StreamController<SearchResultEntity>();
    var count = 0;
    final semaphore = Semaphore(maxConcurrent);
    for (var source in sources) {
      await semaphore.acquire();
      final sender = ReceivePort();
      final receiver = ReceivePort();
      final isolate = await Isolate.spawn(_searchInIsolate, sender.sendPort);
      var message = [network, duration, source, credential, receiver.sendPort];
      (await sender.first as SendPort).send(message);
      receiver.listen((item) {
        if (item is SearchResultEntity) {
          controller.add(item);
        } else {
          isolate.kill();
          count++;
          semaphore.release();
          if (count == sources.length) {
            controller.close();
          }
        }
      });
    }
    yield* controller.stream;
  }

  static void _searchInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      final duration = message[1] as Duration;
      final source = message[2] as SourceEntity;
      var credential = message[3] as String;
      final sender = message[4] as SendPort;
      try {
        try {
          final header = jsonDecode(source.header);
          if (header['Content-Type'] == 'application/x-www-form-urlencoded') {
            if (source.charset == 'gbk') {
              final codeUnits = gbk.encode(credential);
              credential = codeUnits.map((codeUnit) {
                return '%${codeUnit.toRadixString(16).padLeft(2, '0').toUpperCase()}';
              }).join();
            } else {
              credential = Uri.encodeComponent(credential);
            }
          }
        } catch (error) {
          // Do nothing
        }
        final searchUrl = source.searchUrl
            .replaceAll('{{credential}}', credential)
            .replaceAll('{{page}}', '1');
        final method = source.searchMethod.toUpperCase();
        var html = await network.request(
          searchUrl,
          charset: source.charset,
          duration: duration,
          method: method,
        );
        final parser = HtmlParser();
        var document = parser.parse(html);
        var items = parser.queryNodes(document, source.searchBooks);
        for (var i = 0; i < items.length; i++) {
          final author = parser.query(items[i], source.searchAuthor);
          final category = parser.query(items[i], source.searchCategory);
          var cover = parser.query(items[i], source.searchCover);
          if (!cover.startsWith('http')) {
            cover = '${source.url}$cover';
          }
          var introduction = parser.query(items[i], source.searchIntroduction);
          final name = parser.query(items[i], source.searchName);
          var url = parser.query(items[i], source.searchInformationUrl);
          if (!url.startsWith('http')) {
            url = '${source.url}$url';
          }
          var latestChapter =
              parser.query(items[i], source.searchLatestChapter);
          html = await network.request(
            url,
            charset: source.charset,
            duration: duration,
            method: method,
          );
          document = parser.parse(html);
          cover = parser.query(document, source.informationCover);
          if (!cover.startsWith('http')) {
            cover = '${source.url}$cover';
          }
          latestChapter = parser.query(
            document,
            source.informationLatestChapter,
          );
          var catalogueUrl = parser.query(
            document,
            source.informationCatalogueUrl,
          );
          if (!catalogueUrl.startsWith('http')) {
            catalogueUrl = '${source.url}$catalogueUrl';
          }
          introduction = parser.query(document, source.informationIntroduction);
          if (name.isNotEmpty) {
            var availableSource = AvailableSourceEntity();
            availableSource.id = source.id;
            availableSource.name = source.name;
            availableSource.url = url;
            availableSource.latestChapter = latestChapter;
            var book = BookEntity();
            book.author = author;
            book.catalogueUrl = catalogueUrl;
            book.category = category;
            book.cover = cover;
            book.introduction = introduction;
            book.latestChapter = latestChapter;
            book.name = name;
            book.sourceId = source.id;
            book.url = url;
            var result = SearchResultEntity(
              book: book,
              availableSources: [availableSource],
              covers: [CoverEntity()..url = cover],
            );
            sender.send(result);
          }
        }
        sender.send('completed');
      } catch (error) {
        sender.send('terminated');
      }
    });
  }
}
