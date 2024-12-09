import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/model/reader_state.dart';
import 'package:source_parser/model/reader_theme.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/splitter.dart';

part 'reader.g.dart';

@Riverpod(keepAlive: true)
class MediaQueryDataNotifier extends _$MediaQueryDataNotifier {
  @override
  MediaQueryData build() => MediaQueryData();

  void updateSize(MediaQueryData data) {
    state = data;
  }
}

@riverpod
class ReaderSizeNotifier extends _$ReaderSizeNotifier {
  @override
  Future<Size> build() async {
    var mediaQueryData = ref.watch(mediaQueryDataNotifierProvider);
    var screenSize = mediaQueryData.size;
    var theme = await ref.watch(readerThemeNotifierProvider.future);
    var headerHeight = theme.headerStyle.fontSize! * theme.headerStyle.height!;
    var headerPadding = theme.headerPadding.vertical;
    var footerHeight = theme.footerStyle.fontSize! * theme.footerStyle.height!;
    var footerPadding = theme.footerPadding.vertical;
    var width = screenSize.width - theme.pagePadding.horizontal;
    var height = screenSize.height - theme.pagePadding.vertical;
    height -= (headerHeight + headerPadding);
    height -= (footerHeight + footerPadding);
    return Size(width, height);
  }
}

@riverpod
class ReaderStateNotifier extends _$ReaderStateNotifier {
  @override
  Future<ReaderState> build(Book book) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      var index = book.index;
      var cursor = book.cursor;

      List<TextSpan> currentChapterPages;
      try {
        currentChapterPages = await _getChapterPages(index);
      } catch (e) {
        return _createEmptyState(book, index, cursor);
      }
      if (currentChapterPages.isEmpty) {
        return _createEmptyState(book, index, cursor);
      }

      List<TextSpan> nextChapterPages = [];
      if (index + 1 < book.chapters.length) {
        var pages = await _getChapterPages(index + 1);
        if (pages.isNotEmpty) {
          nextChapterPages = pages;
        }
      }

      List<TextSpan> previousChapterPages = [];
      if (index > 0) {
        var pages = await _getChapterPages(index - 1);
        if (pages.isNotEmpty) {
          previousChapterPages = pages;
        }
      }

      cursor = cursor.clamp(0, currentChapterPages.length - 1);
      List<TextSpan> pages = [];

      // 处理前一页的显示
      if (cursor > 0) {
        pages.add(currentChapterPages[cursor - 1]);
      } else if (previousChapterPages.isNotEmpty) {
        pages.add(previousChapterPages.last);
      }

      // 添加当前页
      pages.add(currentChapterPages[cursor]);

      // 处理后一页的显示
      if (cursor + 1 < currentChapterPages.length) {
        pages.add(currentChapterPages[cursor + 1]);
      } else if (nextChapterPages.isNotEmpty) {
        pages.add(nextChapterPages.first);
      }

      return ReaderState()
        ..book = book
        ..chapterIndex = index
        ..pageIndex = cursor
        ..currentChapterPages = currentChapterPages
        ..nextChapterPages = nextChapterPages
        ..previousChapterPages = previousChapterPages
        ..pages = pages;
    } catch (e) {
      return _createEmptyState(book, book.index, book.cursor);
    }
  }

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
        var pages = <TextSpan>[];

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
        var pages = <TextSpan>[];

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

  Future<List<TextSpan>> _getChapterPages(int index) async {
    var setting = await ref.read(settingNotifierProvider.future);
    var timeout = Duration(milliseconds: setting.timeout);
    var source =
        await isar.sources.filter().idEqualTo(book.sourceId).findFirst();
    if (source == null) return [];

    // 最多重试3次
    for (var i = 0; i < 3; i++) {
      var chapter = await Parser.getContent(
        name: book.name,
        source: source,
        timeout: timeout,
        title: book.chapters[index].name,
        url: book.chapters[index].url,
        // 第一次不重新获取，后续重试时重新获取
        reacquire: i > 0,
      );

      if (chapter.isNotEmpty) {
        var theme = await ref.watch(readerThemeNotifierProvider.future);
        var size = await ref.watch(readerSizeNotifierProvider.future);
        var pages = Splitter(size: size, theme: theme).split(chapter);
        if (pages.isNotEmpty) {
          return pages;
        }
      }

      // 如果获取失败或内容为空，等待一段时间后重试
      if (i < 2) {
        await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
      }
    }

    return [];
  }

  Future<void> _syncProgress(int chapterIndex, int pageIndex) async {
    final updatedBook = book.copyWith(
      index: chapterIndex,
      cursor: pageIndex,
    );
    await isar.writeTxn(() async {
      await isar.books.put(updatedBook);
    });
  }
}

@riverpod
class ReaderThemeNotifier extends _$ReaderThemeNotifier {
  @override
  Future<ReaderTheme> build() async {
    final provider = settingNotifierProvider;
    var setting = await ref.watch(provider.future);
    Color backgroundColor = Color(setting.backgroundColor);
    Color fontColor = Colors.black.withOpacity(0.75);
    Color variantFontColor = Colors.black.withOpacity(0.5);
    if (setting.darkMode) {
      backgroundColor = Colors.black;
      fontColor = Colors.white.withOpacity(0.75);
      variantFontColor = Colors.white.withOpacity(0.5);
    }
    final lineSpace = setting.lineSpace;
    final fontSize = setting.fontSize.toDouble();
    var theme = ReaderTheme();
    final mediaQueryData = ref.watch(mediaQueryDataNotifierProvider);
    final padding = mediaQueryData.padding;
    double bottom = 20;
    if (Platform.isAndroid) bottom = max(padding.bottom + 4, 16.0);
    final top = max(padding.top + 4, 16.0);
    theme = theme.copyWith(
      backgroundColor: backgroundColor,
      chapterStyle: theme.chapterStyle.copyWith(color: fontColor),
      footerPadding: theme.footerPadding.copyWith(bottom: bottom),
      footerStyle: theme.footerStyle.copyWith(color: variantFontColor),
      headerPadding: theme.headerPadding.copyWith(top: top),
      headerStyle: theme.headerStyle.copyWith(color: variantFontColor),
      pageStyle: theme.pageStyle.copyWith(
        color: fontColor,
        fontSize: fontSize,
        height: lineSpace,
      ),
    );
    return theme;
  }
}
