import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class SearchViewModel {
  final controller = TextEditingController();
  final isSearching = signal(false);
  final searchedBooks = signal(<BookEntity>[]);
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

  void navigateBookInformationPage(BuildContext context, BookEntity book) {
    removeCurrentMaterialBanner(context);
    InformationRoute().push(context);
  }

  void removeCurrentMaterialBanner(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
  }

  Future<void> search(BuildContext context) async {
    searchedBooks.value.clear();
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
        Parser.search(credential, maxConcurrent, cacheDuration, timeout);
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

  BookEntity? _getExistingBook(BookEntity book) {
    return searchedBooks.value.where((item) {
      return item.name == book.name && item.author == book.author;
    }).firstOrNull;
  }

  Future<BookEntity?> _getFilteredBook(Book book) async {
    var entity = BookEntity.fromJson(book.toJson());
    var searchFilter = await SharedPreferenceUtil.getSearchFilter();
    if (!searchFilter) return entity;
    final conditionA = entity.name.contains(controller.text);
    final conditionB = entity.author.contains(controller.text);
    final filtered = conditionA || conditionB;
    return filtered ? entity : null;
  }

  void _listenStream(Book book) async {
    final filteredBook = await _getFilteredBook(book);
    if (filteredBook == null) return;
    var existingBook = _getExistingBook(filteredBook);
    if (existingBook == null) {
      searchedBooks.value = [...searchedBooks.value, filteredBook];
      return;
    }
    // existingBook.sources.addAll(filteredBook.sources);
    if (filteredBook.cover.length > existingBook.cover.length) {
      existingBook.cover = filteredBook.cover;
    }
    if (filteredBook.introduction.length > existingBook.introduction.length) {
      existingBook.introduction = filteredBook.introduction;
    }
    searchedBooks.value = [...searchedBooks.value];
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
}
