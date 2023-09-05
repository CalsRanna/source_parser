import 'package:book_reader/book_reader.dart';
import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/history.dart';
import 'package:source_parser/creator/router.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/book_cover.dart';

class Reader extends StatefulWidget {
  const Reader({super.key});

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  @override
  void deactivate() {
    updateHistories();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      final book = ref.watch(currentBookCreator);
      var index = ref.watch(currentChapterIndexCreator);
      var cursor = ref.watch(currentCursorCreator);
      final darkMode = ref.watch(darkModeCreator);
      final length = book.chapters.length;
      if (length <= index) {
        ref.set(currentChapterIndexCreator, length - 1);
        ref.set(currentCursorCreator, 0);
        index = length - 1;
        cursor = 0;
      }
      if (cursor < 0) {
        ref.set(currentCursorCreator, 0);
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
    final parser = Parser();
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final source = ref.read(currentSourceCreator);
    final chapters = book.chapters;
    final title = chapters.elementAt(index).name;
    final url = chapters.elementAt(index).url;
    return parser.getContent(source: source, title: title, url: url);
  }

  void handleMessage(String message) {
    Message.of(context).show(message);
  }

  Future<String> handleRefresh(int index) async {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    final book = ref.read(currentBookCreator);
    final chapter = book.chapters.elementAt(index);
    final title = chapter.name;
    final url = chapter.url;
    return Parser().getContent(
      reacquire: true,
      source: source,
      title: title,
      url: url,
    );
  }

  void handleProgressChanged(int cursor) async {
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final index = ref.read(currentChapterIndexCreator);
    var history = await isar.histories
        .filter()
        .nameEqualTo(book.name)
        .authorEqualTo(book.author)
        .findFirst();
    history ??= History();
    history.author = book.author;
    history.cover = book.cover;
    history.name = book.name;
    history.introduction = book.introduction;
    history.url = book.url;
    history.sourceId = book.sourceId;
    history.sources = book.sources;
    history.chapters = book.chapters.map((chapter) {
      return Catalogue.fromJson(chapter.toJson());
    }).toList();
    history.cursor = cursor;
    history.index = index;
    await isar.writeTxn(() async {
      isar.histories.put(history!);
    });
  }

  void handleChapterChanged(int index) {
    context.ref.set(currentChapterIndexCreator, index);
    cacheChapters(index);
  }

  void cacheChapters(int index) async {
    final ref = context.ref;
    final book = context.ref.read(currentBookCreator);
    final length = book.chapters.length;
    final source = ref.read(currentSourceCreator);
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
    updateHistories();
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

  void updateHistories() async {
    final ref = context.ref;
    final histories = await isar.histories.where().findAll();
    histories.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    ref.set(historiesCreator, histories);
  }

  void handleCached(int amount) async {
    final ref = context.ref;
    final message = Message.of(context);
    final book = ref.read(currentBookCreator);
    final source = ref.read(currentSourceCreator);
    if (amount == 0) {
      amount = book.chapters.length;
    }
    final index = ref.read(currentChapterIndexCreator);
    var failed = 0;
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
    message.show('缓存完毕，${amount - failed}章成功，$failed章失败');
  }

  void handleDetailPressed() {
    context.push('/book-information');
  }

  void handleSettingPressed() {
    context.push('/reader-theme');
  }
}
