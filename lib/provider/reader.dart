import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/model/reader_state.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/provider/theme.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/reader_controller.dart';
import 'package:source_parser/util/splitter.dart';

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
  Future<ReaderState> build(Book book) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var size = await ref.read(readerSizeNotifierProvider.future);
    var theme = await ref.read(themeNotifierProvider.future);
    var pool = ReaderController(book, size: size, theme: theme);
    await pool.init(book.index);
    return ReaderState()
      ..book = book
      ..chapterIndex = book.index
      ..pageIndex = book.cursor
      ..currentChapterPages = pool.currentChapterPages
      ..nextChapterPages = pool.nextChapterPages
      ..previousChapterPages = pool.previousChapterPages
      ..pages = pool.getPages(book.cursor, chapterIndex: book.index);
  }

  Future<void> nextPage() async {}

  Future<void> updatePageIndex(int index) async {
    if (index == 1) return;

    var readerState = await future;
    var currentPageIndex = readerState.pageIndex;
    var currentChapterIndex = readerState.chapterIndex;

    // 向后翻页
    if (index == 2) {
      // 如果当前页是章节的最后一页，需要切换到下一章
      if (currentPageIndex >= readerState.currentChapterPages.length - 1) {
        // 检查是否还有下一章
        if (currentChapterIndex + 1 >= book.chapters.length) {
          // 如果是最后一章最后一页，保持当前状态
          state = AsyncData(readerState.copyWith(
            pages: [
              if (currentPageIndex > 0)
                readerState.currentChapterPages[currentPageIndex - 1],
              readerState.currentChapterPages[currentPageIndex],
            ],
          ));
          return;
        }

        // 加载下一章内容
        var nextChapterPages = readerState.nextChapterPages;
        if (nextChapterPages.isEmpty) {
          nextChapterPages = await _getChapterPages(currentChapterIndex + 1);
          if (nextChapterPages.isEmpty) return;
        }

        final newChapterIndex = currentChapterIndex + 1;
        final newPageIndex = 0;

        // 立即更新状态：当前章节变为下一章，确保显示第一页
        state = AsyncData(readerState.copyWith(
          chapterIndex: newChapterIndex,
          pageIndex: newPageIndex,
          previousChapterPages: readerState.currentChapterPages,
          currentChapterPages: nextChapterPages,
          nextChapterPages: readerState.nextChapterPages, // 保持已预加载的下一章内容
          pages: [
            readerState.currentChapterPages.last, // 上一章的最后一页
            nextChapterPages[0], // 这一章的第一页
            if (nextChapterPages.length > 1) // 这一章的第二页（如果有）
              nextChapterPages[1],
          ],
        ));

        _syncProgress(newChapterIndex, newPageIndex);

        // 异步预加载下下章
        if (currentChapterIndex + 2 < book.chapters.length) {
          _getChapterPages(currentChapterIndex + 2).then((futureChapterPages) {
            if (futureChapterPages.isNotEmpty) {
              future.then((currentState) {
                state = AsyncData(currentState.copyWith(
                  nextChapterPages: futureChapterPages,
                ));
              });
            }
          });
        }
      } else {
        // 在当前章节内翻页
        var newPageIndex = currentPageIndex + 1;
        var pages = <String>[];

        // 构建新的三页视图
        if (newPageIndex > 0) {
          pages.add(readerState.currentChapterPages[newPageIndex - 1]);
        } else if (readerState.previousChapterPages.isNotEmpty) {
          pages.add(readerState.previousChapterPages.last);
        }
        pages.add(readerState.currentChapterPages[newPageIndex]);
        if (newPageIndex + 1 < readerState.currentChapterPages.length) {
          pages.add(readerState.currentChapterPages[newPageIndex + 1]);
        } else if (readerState.nextChapterPages.isNotEmpty) {
          pages.add(readerState.nextChapterPages[0]);
        }

        state = AsyncData(readerState.copyWith(
          pageIndex: newPageIndex,
          pages: pages,
        ));

        _syncProgress(currentChapterIndex, newPageIndex);
      }
    }

    // 向前翻页
    if (index == 0) {
      // 如果当前页是章节的第一页，需要切换到上一章
      if (currentPageIndex <= 0) {
        // 检查是否还有上一章
        if (currentChapterIndex <= 0) {
          // 如果是第一章第一页，保持当前状态
          state = AsyncData(readerState.copyWith(
            pages: [
              readerState.currentChapterPages[currentPageIndex],
              if (readerState.currentChapterPages.length > 1)
                readerState.currentChapterPages[currentPageIndex + 1],
            ],
          ));
          return;
        }

        // 加载上一章内容
        var previousChapterPages = readerState.previousChapterPages;
        if (previousChapterPages.isEmpty) {
          previousChapterPages =
              await _getChapterPages(currentChapterIndex - 1);
          if (previousChapterPages.isEmpty) return;
        }

        final newChapterIndex = currentChapterIndex - 1;
        final newPageIndex = previousChapterPages.length - 1;

        // 立即更新状态：当前章节变为上一章
        state = AsyncData(readerState.copyWith(
          chapterIndex: newChapterIndex,
          pageIndex: newPageIndex,
          previousChapterPages:
              readerState.previousChapterPages, // 保持已预加载的上一章内容
          currentChapterPages: previousChapterPages,
          nextChapterPages: readerState.currentChapterPages,
          pages: [
            if (newPageIndex > 0) // 上一章的倒数第二页（如果有）
              previousChapterPages[newPageIndex - 1],
            previousChapterPages[newPageIndex], // 上一章的最后一页
            readerState.currentChapterPages[0], // 当前章的第一页
          ],
        ));

        _syncProgress(newChapterIndex, newPageIndex);

        // 异步预加载上上章
        if (currentChapterIndex > 1) {
          _getChapterPages(currentChapterIndex - 2)
              .then((prePreviousChapterPages) {
            if (prePreviousChapterPages.isNotEmpty) {
              future.then((currentState) {
                state = AsyncData(currentState.copyWith(
                  previousChapterPages: prePreviousChapterPages,
                ));
              });
            }
          });
        }
      } else {
        // 在当前章节内翻页
        var newPageIndex = currentPageIndex - 1;
        var pages = <String>[];

        // 构建新的三页视图
        if (newPageIndex > 0) {
          pages.add(readerState.currentChapterPages[newPageIndex - 1]);
        } else if (readerState.previousChapterPages.isNotEmpty) {
          pages.add(readerState.previousChapterPages.last);
        }
        pages.add(readerState.currentChapterPages[newPageIndex]);
        pages.add(readerState.currentChapterPages[newPageIndex + 1]);

        state = AsyncData(readerState.copyWith(
          pageIndex: newPageIndex,
          pages: pages,
        ));
        _syncProgress(currentChapterIndex, newPageIndex);
      }
    }
  }

  ReaderState _createEmptyState(Book book, int index, int cursor) {
    return ReaderState()
      ..book = book
      ..chapterIndex = index
      ..pageIndex = cursor
      ..currentChapterPages = []
      ..nextChapterPages = []
      ..previousChapterPages = []
      ..pages = [];
  }

  Future<List<String>> _getChapterPages(int index) async {
    var setting = await ref.read(settingNotifierProvider.future);
    var timeout = Duration(milliseconds: setting.timeout);
    var source = await _getSource();
    if (source == null) return [];
    var chapter = await Parser.getContent(
      name: book.name,
      source: source,
      timeout: timeout,
      title: book.chapters[index].name,
      url: book.chapters[index].url,
    );
    if (chapter.isEmpty) return [];
    var size = await ref.read(readerSizeNotifierProvider.future);
    var theme = await ref.read(themeNotifierProvider.future);
    return Splitter(size: size, theme: theme).split(chapter);
  }

  Future<Source?> _getSource() async {
    return isar.sources.filter().idEqualTo(book.sourceId).findFirst();
  }

  Future<void> _syncProgress(int chapterIndex, int pageIndex) async {
    final updatedBook = book.copyWith(
      index: chapterIndex,
      cursor: pageIndex,
    );
    isar.writeTxn(() async {
      isar.books.put(updatedBook);
    });
  }
}
