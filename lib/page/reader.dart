// import 'package:book_reader/book_reader.dart';
import 'package:book_reader/book_reader.dart';
import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/history.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/message.dart';

class Reader extends StatefulWidget {
  const Reader({super.key});

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      final book = ref.watch(currentBookCreator);
      final index = ref.watch(currentChapterIndexCreator);
      final source = ref.watch(currentSourceCreator);
      final cursor = ref.watch(currentCursorCreator);

      return BookReader(
        future: (index) => Parser().getContent(
          url: book.chapters.elementAt(index).url,
          source: source,
          title: book.chapters.elementAt(index).name,
        ),
        cursor: cursor,
        index: index,
        total: book.chapters.length,
        name: book.name,
        title: book.chapters.elementAt(index).name,
        onMessage: handleMessage,
        onRefresh: (index) => Parser().getContent(
          url: book.chapters.elementAt(index).url,
          reacquire: true,
          source: source,
          title: book.chapters.elementAt(index).name,
        ),
        onProgressChanged: handleProgressChanged,
        onChapterChanged: handleChapterChanged,
        onCatalogueNavigated: handleCatalogueNavigated,
        onPop: handlePop,
      );
    });
  }

  void handleMessage(String message) {
    Message.of(context).show(message);
  }

  void handleProgressChanged(int cursor) async {
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final index = ref.read(currentChapterIndexCreator);
    var history = await isar.historys
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
    history.chapters = book.chapters.map((chapter) {
      return Catalogue.fromJson(chapter.toJson());
    }).toList();
    history.cursor = cursor;
    history.index = index;
    await isar.writeTxn(() async {
      isar.historys.put(history!);
    });
  }

  void handleChapterChanged(int index) {
    context.ref.set(currentChapterIndexCreator, index);
    cacheChapters(index);
  }

  void cacheChapters(int index) {
    final book = context.ref.read(currentBookCreator);
    final length = book.chapters.length;
    for (var i = 1; i <= 2; i++) {
      if (index + i < length) {
        CachedNetwork().request(book.chapters.elementAt(index + i).url);
      }
    }
  }

  void handleCatalogueNavigated() {
    context.push('/book-catalogue');
  }

  void handlePop(int index, int cursor) async {
    final ref = context.ref;
    final histories = await isar.historys.where().findAll();
    ref.set(historiesCreator, histories);
  }
}
