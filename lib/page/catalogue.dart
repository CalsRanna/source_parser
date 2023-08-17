import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/schema/source.dart';

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
    controller = ScrollController(initialScrollOffset: 56.0 * current - 344);
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
      body: Watcher((context, ref, child) {
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
                style: TextStyle(color: color),
              ),
              onTap: () => startReader(index),
            );
          },
          itemCount: book.chapters.length,
        );
      }),
    );
  }

  void handlePressed() {
    var position = controller.position.maxScrollExtent;
    if (!atTop) {
      position = controller.position.minScrollExtent;
    }
    const curve = Curves.easeInOut;
    const duration = Duration(milliseconds: 200);
    controller.animateTo(position, curve: curve, duration: duration);
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
    router.push('/book-reader');
  }
}
