import 'dart:math';

import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/router.dart';
import 'package:source_parser/schema/book.dart';
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
    final book = ref.watch(currentBookCreator);
    // HACK: offset minus 344 to keep tile in the screen center
    double offset = max(56.0 * book.index - 344, 0);
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
          final theme = Theme.of(context);
          final primary = theme.colorScheme.primary;
          final onSurface = theme.colorScheme.onSurface;
          final network = CachedNetwork();

          return ListView.builder(
            controller: controller,
            itemBuilder: (context, index) {
              return ListTile(
                title: FutureBuilder(
                  builder: (context, snapshot) {
                    Color color;
                    if (book.index == index) {
                      color = primary;
                    } else {
                      color = onSurface.withOpacity(0.5);
                      if (snapshot.hasData) {
                        final cached = snapshot.data!;
                        color = onSurface.withOpacity(cached ? 1 : 0.5);
                      }
                    }
                    return Text(
                      book.chapters[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: color),
                    );
                  },
                  future: network.cached(book.chapters[index].url),
                ),
                onTap: () => startReader(index),
              );
            },
            itemCount: book.chapters.length,
            itemExtent: 56,
          );
        }),
      ),
    );
  }

  Future<void> handleRefresh() async {
    try {
      final ref = context.ref;
      final book = ref.read(currentBookCreator);
      final builder = isar.sources.filter();
      final source = await builder.idEqualTo(book.sourceId).findFirst();
      if (source != null) {
        var stream = await Parser.getChapters(book.catalogueUrl, source);
        stream = stream.asBroadcastStream();
        List<Chapter> chapters = [];
        stream.listen(
          (chapter) {
            chapters.add(chapter);
          },
          onDone: () {
            ref.set(currentBookCreator, book.copyWith(chapters: chapters));
          },
        );
        await stream.last;
      }
    } catch (error) {
      // Do nothing
    }
  }

  void handlePressed() {
    var position = controller.position.maxScrollExtent;
    if (!atTop) {
      position = controller.position.minScrollExtent;
    }
    controller.animateTo(
      position,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 200),
    );
    setState(() {
      atTop = !atTop;
    });
  }

  void startReader(int index) async {
    final ref = context.ref;
    final router = GoRouter.of(context);
    final book = ref.read(currentBookCreator);
    final updatedBook = book.copyWith(cursor: 0, index: index);
    ref.set(currentBookCreator, updatedBook);
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
    final book = context.ref.read(currentBookCreator);
    final length = book.chapters.length;
    for (var i = 1; i <= 3; i++) {
      if (index + i < length) {
        await CachedNetwork().request(book.chapters.elementAt(index + i).url);
      }
    }
  }
}
