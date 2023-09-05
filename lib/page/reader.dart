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
import 'package:source_parser/widget/book_cover.dart';

class Reader extends StatefulWidget {
  const Reader({super.key});

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  Parser parser = Parser();

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
      theme = theme.copyWith(
        pageStyle: theme.pageStyle.copyWith(height: lineSpace),
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

      return BookReader(
        author: book.author,
        cover: BookCover(height: 48, width: 36, url: book.cover),
        cursor: cursor,
        darkMode: darkMode,
        future: getContent,
        index: index,
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
      return parser.getContent(source: source, title: title, url: url);
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
      return parser.getContent(
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
    setting ??= Setting();
    setting.darkMode = !darkMode;
    await isar.writeTxn(() async {
      isar.settings.put(setting!);
    });
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
    var failed = 0;
    if (source != null) {
      // 0代表缓存全部
      if (amount == 0) {
        amount = book.chapters.length;
      }
      final index = book.index;
      for (var i = 1; i <= amount; i++) {
        if (index + i < book.chapters.length) {
          try {
            await CachedNetwork().request(
              book.chapters.elementAt(index + i).url,
              charset: source.charset,
              method: source.contentMethod,
            );
          } catch (error) {
            failed += 1;
          }
        }
      }
    }
    message.show('缓存完毕，${amount - failed}章成功，$failed章失败');
  }

  void handleDetailPressed() {
    context.push('/book-information');
  }

  void handleSettingPressed() {
    context.push('/reader-theme');
  }
}
