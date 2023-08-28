import 'package:book_reader/book_reader.dart';
import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/history.dart';
import 'package:source_parser/creator/router.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/book.dart';
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
      final index = ref.watch(currentChapterIndexCreator);
      final cursor = ref.watch(currentCursorCreator);
      final darkMode = ref.watch(darkModeCreator);

      var theme = ReaderTheme();
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
        future: getContent,
        cursor: cursor,
        darkMode: darkMode,
        index: index,
        total: book.chapters.length,
        name: book.name,
        theme: theme,
        title: book.chapters.elementAt(index).name,
        onMessage: handleMessage,
        onRefresh: handleRefresh,
        onProgressChanged: handleProgressChanged,
        onChapterChanged: handleChapterChanged,
        onCatalogueNavigated: handleCatalogueNavigated,
        onPop: handlePop,
        onDarkModePressed: handleDarkModePressed,
        onSourceSwitcherPressed: handleSourceSwitcherPressed,
        onCached: handleCached,
        onDetailPressed: handleDetailPressed,
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
    history.sources = book.sources.map((source) {
      return SourceSwitcher.fromJson(source.toJson());
    }).toList();
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
    for (var i = 1; i <= 3; i++) {
      if (index + i < length) {
        await CachedNetwork().request(book.chapters.elementAt(index + i).url);
        var history = await isar.histories
            .filter()
            .nameEqualTo(book.name)
            .authorEqualTo(book.author)
            .findFirst();
        history ??= History();
        history.chapters.elementAt(index + i).cached = true;
        await isar.writeTxn(() async {
          isar.histories.put(history!);
        });
        ref.set(currentBookCreator, Book.fromJson(history.toJson()));
      }
    }
  }

  void handleCatalogueNavigated() {
    context.ref.set(fromCreator, '/book-reader');
    context.push('/book-catalogue');
  }

  void handleSourceSwitcherPressed() {
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
    ref.set(historiesCreator, histories);
  }

  void handleCached(int amount) async {
    final ref = context.ref;
    final message = Message.of(context);
    final book = ref.read(currentBookCreator);
    if (amount == 0) {
      amount = book.chapters.length;
    }
    final index = ref.read(currentChapterIndexCreator);
    for (var i = 1; i <= amount; i++) {
      if (index + i < book.chapters.length) {
        await CachedNetwork().request(book.chapters.elementAt(index + i).url);
        var history = await isar.histories
            .filter()
            .nameEqualTo(book.name)
            .authorEqualTo(book.author)
            .findFirst();
        history ??= History();
        history.chapters.elementAt(index + i).cached = true;
        await isar.writeTxn(() async {
          isar.histories.put(history!);
        });
        ref.set(currentBookCreator, Book.fromJson(history.toJson()));
      }
    }
    message.show('缓存完毕');
  }

  void handleDetailPressed() {
    context.push('/book-information');
  }
}
