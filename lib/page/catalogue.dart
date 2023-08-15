import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/schema/source.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({super.key});
  @override
  State<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目录'),
        actions: [
          TextButton(onPressed: handlePressed, child: const Text('底部'))
        ],
      ),
      body: Watcher((context, ref, child) {
        final chapters = ref.watch(currentChaptersCreator);
        return ListView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(chapters[index].name),
              onTap: () => startReader(index),
            );
          },
          itemCount: chapters.length,
        );
      }),
    );
  }

  void handlePressed() {
    controller.animateTo(
      controller.position.maxScrollExtent,
      curve: Curves.bounceInOut,
      duration: const Duration(milliseconds: 200),
    );
  }

  void startReader(int index) async {
    final ref = context.ref;
    final router = GoRouter.of(context);
    final book = ref.read(currentBookCreator);
    final source =
        await isar.sources.filter().idEqualTo(book.sourceId).findFirst();
    if (source != null) {
      ref.set(currentSourceCreator, source);
    }
    ref.set(currentChapterIndexCreator, index);
    router.push('/book-reader');
  }
}
