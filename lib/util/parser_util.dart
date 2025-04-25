import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:charset/charset.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/database/book_source_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/book_source_entity.dart';
import 'package:source_parser/model/cover_entity.dart';
import 'package:source_parser/model/parser_search_result_entity.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/semaphore.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class ParserUtil {
  static ParserUtil instance = ParserUtil._internal();
  ParserUtil._internal();

  Stream<AvailableSourceEntity> getAvailableSources(BookEntity book) async* {
    var stream = search(book.name);
    var broadcastStream = stream.asBroadcastStream();
    await for (var item in broadcastStream) {
      if (item.book.name == book.name && item.book.author == book.author) {
        yield item.availableSource;
      }
    }
  }

  Stream<CoverEntity> getCovers(BookEntity book) async* {
    var stream = search(book.name);
    var broadcastStream = stream.asBroadcastStream();
    await for (var item in broadcastStream) {
      if (item.book.name == book.name && item.book.author == book.author) {
        yield item.cover;
      }
    }
  }

  Stream<ParserSearchResultEntity> search(String credential) async* {
    var storedCacheDuration = await SharedPreferenceUtil.getCacheDuration();
    var cachedDuration = Duration(hours: storedCacheDuration.floor());
    var storedTimeout = await SharedPreferenceUtil.getTimeout();
    var timeout = Duration(milliseconds: storedTimeout);
    var storedMaxConcurrent = await SharedPreferenceUtil.getMaxConcurrent();
    var maxConcurrent = storedMaxConcurrent.floor();
    final bookSources = await BookSourceService().getEnabledBookSources();
    final directory = await getTemporaryDirectory();
    final network = CachedNetwork(
      temporaryDirectory: directory,
      timeout: timeout,
    );
    final controller = StreamController<ParserSearchResultEntity>();
    var count = 0;
    final semaphore = Semaphore(maxConcurrent);
    for (var source in bookSources) {
      await semaphore.acquire();
      final sender = ReceivePort();
      final receiver = ReceivePort();
      final isolate = await Isolate.spawn(_searchInIsolate, sender.sendPort);
      var message = [
        network,
        cachedDuration,
        source,
        credential,
        receiver.sendPort
      ];
      (await sender.first as SendPort).send(message);
      receiver.listen((item) {
        if (item is ParserSearchResultEntity) {
          controller.add(item);
        } else {
          isolate.kill();
          count++;
          semaphore.release();
          if (count == bookSources.length) {
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
      final bookSource = message[2] as BookSourceEntity;
      var credential = message[3] as String;
      final sender = message[4] as SendPort;
      try {
        try {
          final header = jsonDecode(bookSource.header);
          if (header['Content-Type'] == 'application/x-www-form-urlencoded') {
            if (bookSource.charset == 'gbk') {
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
        final searchUrl = bookSource.searchUrl
            .replaceAll('{{credential}}', credential)
            .replaceAll('{{page}}', '1');
        final method = bookSource.searchMethod.toUpperCase();
        var html = await network.request(
          searchUrl,
          charset: bookSource.charset,
          duration: duration,
          method: method,
        );
        final parser = HtmlParser();
        var document = parser.parse(html);
        var items = parser.queryNodes(document, bookSource.searchBooks);
        for (var i = 0; i < items.length; i++) {
          final author = parser.query(items[i], bookSource.searchAuthor);
          final category = parser.query(items[i], bookSource.searchCategory);
          var cover = parser.query(items[i], bookSource.searchCover);
          var needFurtherParse = cover.isEmpty;
          if (!cover.startsWith('http')) {
            cover = '${bookSource.url}$cover';
          }
          final introduction =
              parser.query(items[i], bookSource.searchIntroduction);
          final name = parser.query(items[i], bookSource.searchName);
          var url = parser.query(items[i], bookSource.searchInformationUrl);
          if (!url.startsWith('http')) {
            url = '${bookSource.url}$url';
          }
          var latestChapter =
              parser.query(items[i], bookSource.searchLatestChapter);
          if (!needFurtherParse) needFurtherParse = latestChapter.isEmpty;
          if (needFurtherParse) {
            html = await network.request(
              url,
              charset: bookSource.charset,
              duration: duration,
              method: method,
            );
            document = parser.parse(html);
            cover = parser.query(document, bookSource.informationCover);
            if (!cover.startsWith('http')) {
              cover = '${bookSource.url}$cover';
            }
            latestChapter = parser.query(
              document,
              bookSource.informationLatestChapter,
            );
          }
          if (name.isNotEmpty) {
            var availableSourceEntity = AvailableSourceEntity();
            availableSourceEntity.id = bookSource.id;
            availableSourceEntity.name = bookSource.name;
            availableSourceEntity.url = url;
            availableSourceEntity.latestChapter = latestChapter;
            var bookEntity = BookEntity();
            bookEntity.author = author;
            bookEntity.category = category;
            bookEntity.cover = cover;
            bookEntity.introduction = introduction;
            bookEntity.latestChapter = latestChapter;
            bookEntity.name = name;
            bookEntity.availableSourceId = bookSource.id;
            bookEntity.url = url;
            var coverEntity = CoverEntity();
            coverEntity.url = cover;
            coverEntity.bookId = bookEntity.id;
            var result = ParserSearchResultEntity(
              availableSource: availableSourceEntity,
              book: bookEntity,
              chapters: [],
              cover: coverEntity,
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
