import 'dart:async';
import 'dart:math';

import 'package:book_reader/book_reader.dart';
import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/router.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/semaphore.dart';
import 'package:source_parser/widget/book_cover.dart';

class Reader extends StatefulWidget {
  const Reader({super.key});

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  @override
  void deactivate() {
    updateBooks();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      final book = ref.watch(currentBookCreator);
      var index = book.index;
      var cursor = book.cursor;
      final darkMode = ref.watch(darkModeCreator);
      final length = book.chapters.length;
      if (length <= index) {
        index = length - 1;
        cursor = 0;
      }
      if (cursor < 0) {
        cursor = 0;
      }
      var theme = ReaderTheme();
      final lineSpace = ref.watch(lineSpaceCreator);
      final fontSize = ref.watch(fontSizeCreator);
      final mediaQueryData = MediaQuery.of(context);
      final padding = mediaQueryData.padding;
      final bottom = max(padding.bottom + 4, 16.0);
      final top = max(padding.top + 4, 16.0);
      theme = theme.copyWith(
        footerPadding: theme.footerPadding.copyWith(bottom: bottom),
        headerPadding: theme.headerPadding.copyWith(top: top),
        pageStyle: theme.pageStyle.copyWith(
          fontSize: fontSize.toDouble(),
          height: lineSpace,
        ),
      );
      if (darkMode) {
        final scheme = Theme.of(context).colorScheme;
        theme = theme.copyWith(
          backgroundColor: scheme.background,
          footerStyle: theme.footerStyle.copyWith(color: scheme.onBackground),
          headerStyle: theme.headerStyle.copyWith(color: scheme.onBackground),
          pageStyle: theme.pageStyle.copyWith(color: scheme.onBackground),
        );
      }
      List<PageTurningMode> modes = [];
      final turningMode = ref.watch(turningModeCreator);
      if (turningMode & 1 != 0) {
        modes.add(PageTurningMode.drag);
      }
      if (turningMode & 2 != 0) {
        modes.add(PageTurningMode.tap);
      }
      final eInkMode = ref.watch(eInkModeCreator);

      return BookReader(
        author: book.author,
        cover: BookCover(height: 48, width: 36, url: book.cover),
        cursor: cursor,
        darkMode: darkMode,
        eInkMode: eInkMode,
        future: getContent,
        index: index,
        modes: modes,
        name: book.name,
        theme: theme,
        title: book.chapters.elementAt(index).name,
        total: book.chapters.length,
        onCached: handleCached,
        onCataloguePressed: handleCataloguePressed,
        onChapterChanged: handleChapterChanged,
        onDarkModePressed: handleDarkModePressed,
        onDetailPressed: handleDetailPressed,
        onMessage: handleMessage,
        onPop: handlePop,
        onProgressChanged: handleProgressChanged,
        onRefresh: handleRefresh,
        onSettingPressed: handleSettingPressed,
        onSourcePressed: handleSourcePressed,
      );
    });
  }

  Future<String> getContent(int index) async {
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(book.sourceId).findFirst();
    if (source != null) {
      final chapter = book.chapters.elementAt(index);
      final title = chapter.name;
      final url = chapter.url;
      return Parser.getContent(source: source, title: title, url: url);
    } else {
      return '';
    }
  }

  void handleMessage(String message) {
    Message.of(context).show(message);
  }

  Future<String> handleRefresh(int index) async {
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(book.sourceId).findFirst();
    if (source != null) {
      final chapter = book.chapters.elementAt(index);
      final title = chapter.name;
      final url = chapter.url;
      return Parser.getContent(
        reacquire: true,
        source: source,
        title: title,
        url: url,
      );
    } else {
      return '';
    }
  }

  void handleProgressChanged(int cursor) async {
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final updatedBook = book.copyWith(cursor: cursor);
    ref.set(currentBookCreator, updatedBook);
    await isar.writeTxn(() async {
      isar.books.put(updatedBook);
    });
  }

  void handleChapterChanged(int index) async {
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final updatedBook = book.copyWith(index: index);
    ref.set(currentBookCreator, updatedBook);
    await isar.writeTxn(() async {
      isar.books.put(updatedBook);
    });
    cacheChapters(index);
  }

  void cacheChapters(int index) async {
    final book = context.ref.read(currentBookCreator);
    final length = book.chapters.length;
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(book.sourceId).findFirst();
    if (source != null) {
      for (var i = 1; i <= 3; i++) {
        if (index + i < length) {
          await CachedNetwork().request(
            book.chapters.elementAt(index + i).url,
            charset: source.charset,
            method: source.contentMethod,
          );
        }
      }
    }
  }

  void handleCataloguePressed() {
    context.ref.set(fromCreator, '/book-reader');
    context.push('/book-catalogue');
  }

  void handleSourcePressed() {
    context.ref.set(fromCreator, '/book-reader');
    context.push('/book-available-sources');
  }

  void handlePop(int index, int cursor) async {
    context.pop();
    updateBooks();
  }

  void handleDarkModePressed() async {
    final ref = context.ref;
    final darkMode = ref.read(darkModeCreator);
    ref.set(darkModeCreator, !darkMode);
    var setting = await isar.settings.where().findFirst();
    if (setting != null) {
      setting.darkMode = !darkMode;
      await isar.writeTxn(() async {
        isar.settings.put(setting);
      });
    }
  }

  void updateBooks() async {
    final ref = context.ref;
    final books = await isar.books.where().findAll();
    books.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    ref.set(booksCreator, books);
  }

  void handleCached(int amount) async {
    final ref = context.ref;
    final message = Message.of(context);
    final book = ref.read(currentBookCreator);
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(book.sourceId).findFirst();
    if (source == null) return;

    if (amount == 0) {
      amount = book.chapters.length;
    }

    final startIndex = book.index;
    final endIndex = min(startIndex + amount, book.chapters.length);
    var failed = 0;

    final semaphore = Semaphore(16);
    final futures = <Future>[];
    for (var i = startIndex; i < endIndex; i++) {
      futures.add(
        cacheChapter(book, source, i, semaphore).catchError((error) {
          failed++;
        }),
      );
    }

    await Future.wait(futures);

    message.show('缓存完毕，${amount - failed}章成功，$failed章失败');
  }

  Future<void> cacheChapter(
    Book book,
    Source source,
    int chapterIndex,
    Semaphore semaphore,
  ) async {
    await semaphore.acquire();
    try {
      final url = book.chapters.elementAt(chapterIndex).url;
      final network = CachedNetwork();
      final cached = await network.cached(url);
      if (!cached) {
        await network.request(
          url,
          charset: source.charset,
          method: source.contentMethod,
        );
      }
    } catch (error) {
      rethrow;
    } finally {
      semaphore.release();
    }
  }

  void handleDetailPressed() {
    context.push('/book-information');
  }

  void handleSettingPressed() {
    context.push('/reader-theme');
  }
}
