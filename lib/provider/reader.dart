import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/model/reader_state.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/theme.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';

part 'reader.g.dart';

@Riverpod(keepAlive: true)
class MediaQueryDataNotifier extends _$MediaQueryDataNotifier {
  @override
  MediaQueryData build() => MediaQueryData();

  void updateMediaQueryData(MediaQueryData data) {
    state = data;
  }
}

@riverpod
class ReaderSizeNotifier extends _$ReaderSizeNotifier {
  @override
  Future<Size> build() async {
    var mediaQueryData = ref.watch(mediaQueryDataNotifierProvider);
    var screenSize = mediaQueryData.size;
    var provider = themeNotifierProvider;
    var theme = await ref.watch(provider.future);
    var pagePaddingHorizontal =
        theme.contentPaddingLeft + theme.contentPaddingRight;
    var pagePaddingVertical =
        theme.contentPaddingTop + theme.contentPaddingBottom;
    var width = screenSize.width - pagePaddingHorizontal;
    var headerPaddingVertical =
        theme.headerPaddingBottom + theme.headerPaddingTop;
    var footerPaddingVertical =
        theme.footerPaddingBottom + theme.footerPaddingTop;
    var height = screenSize.height - pagePaddingVertical;
    height -= headerPaddingVertical;
    height -= (theme.headerFontSize * theme.headerHeight);
    height -= footerPaddingVertical;
    height -= (theme.footerFontSize * theme.footerHeight);
    return Size(width, height);
  }
}

@riverpod
class ReaderStateNotifier extends _$ReaderStateNotifier {
  @override
  ReaderState build(Book book) {
    return ReaderState()
      ..chapter = book.index
      ..page = book.cursor;
  }

  void syncState({required int chapter, required int page}) {
    state = state.copyWith(chapter: chapter, page: page);
    _syncProgress(chapter, page);
  }

  Future<void> _syncProgress(int chapter, int page) async {
    var updatedBook = book.copyWith(index: chapter, cursor: page);
    var existed = await isar.books
        .filter()
        .authorEqualTo(book.author)
        .nameEqualTo(book.name)
        .findFirst();
    if (existed != null) {
      updatedBook = existed.copyWith(index: chapter, cursor: page);
    }
    ref.read(bookNotifierProvider.notifier).update(updatedBook);
    isar.writeTxn(() async {
      isar.books.put(updatedBook);
    });
  }
}
