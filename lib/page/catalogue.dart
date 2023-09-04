import 'dart:math';

import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/router.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});
  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  late ScrollController controller;
  bool atTop = true;

  @override
  void didChangeDependencies() {
    final ref = context.ref;
    final current = ref.watch(currentChapterIndexCreator);
    // HACK: offset minus 344 to keep tile in the screen center
    double offset = max(56.0 * current - 344, 0);
    controller = ScrollController(initialScrollOffset: offset);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目录'),
        actions: [
          TextButton(
            onPressed: handlePressed,
            child: Text(atTop ? '底部' : '顶部'),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        child: Watcher((context, ref, child) {
          final book = ref.watch(currentBookCreator);
          final current = ref.watch(currentChapterIndexCreator);
          final theme = Theme.of(context);
          final primary = theme.colorScheme.primary;
          final onSurface = theme.colorScheme.onSurface;

          return ListView.builder(
            controller: controller,
            itemBuilder: (context, index) {
              Color color;
              if (current == index) {
                color = primary;
              } else {
                if (book.chapters[index].cached) {
                  color = onSurface;
                } else {
                  color = onSurface.withOpacity(0.5);
                }
              }
              return ListTile(
                title: Text(
                  book.chapters[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: color),
                ),
                onTap: () => startReader(index),
              );
            },
            itemCount: book.chapters.length,
          );
        }),
      ),
    );
  }

  Future<void> handleRefresh() async {
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final source =
        await isar.sources.filter().idEqualTo(book.sourceId).findFirst();
    if (source != null) {
      final chapters = await Parser().getChapters(book.catalogueUrl, source);
      ref.set(currentBookCreator, book.copyWith(chapters: chapters));
    }
  }

  void handlePressed() {
    var position = controller.position.maxScrollExtent;
    if (!atTop) {
      position = controller.position.minScrollExtent;
    }
    controller.jumpTo(position);
    setState(() {
      atTop = !atTop;
    });
  }

  void startReader(int index) async {
    final ref = context.ref;
    final router = GoRouter.of(context);
    ref.set(currentChapterIndexCreator, index);
    ref.set(currentCursorCreator, 0);
    final book = ref.read(currentBookCreator);
    final source =
        await isar.sources.filter().idEqualTo(book.sourceId).findFirst();
    if (source != null) {
      ref.set(currentSourceCreator, source);
    }
    final from = ref.read(fromCreator);
    if (from == '/book-reader') {
      router.pop();
      router.pushReplacement('/book-reader');
    } else {
      router.push('/book-reader');
    }
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
}
