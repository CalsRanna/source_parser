import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/parser.dart';

class AvailableSources extends StatefulWidget {
  const AvailableSources({super.key});

  @override
  State<AvailableSources> createState() => _AvailableSourcesState();
}

class _AvailableSourcesState extends State<AvailableSources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('可用源')),
      body: Watcher((context, ref, child) {
        final book = ref.watch(currentBookCreator);
        return ListView.builder(
          itemBuilder: (context, index) {
            final active = book.sources[index].id == book.sourceId;
            final primary = Theme.of(context).colorScheme.primary;
            return ListTile(
              subtitle: Text(
                book.sources[index].url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              title: Text(
                book.sources[index].name,
                style: TextStyle(color: active ? primary : null),
              ),
              trailing: active ? const Icon(Icons.check) : null,
              onTap: () => switchSource(index),
            );
          },
          itemCount: book.sources.length,
        );
      }),
    );
  }

  void switchSource(int index) async {
    final message = Message.of(context);
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    if (book.sources[index].id == book.sourceId) {
      message.show('已在当前源');
      return;
    }
    final sourceId = book.sources[index].id;
    final source = await isar.sources.filter().idEqualTo(sourceId).findFirst();
    if (source != null) {
      final url = book.sources[index].url;
      final chapters = await Parser().getChapters(url: url, source: source);
      ref.set(
          currentBookCreator,
          book.copyWith(
            sourceId: sourceId,
            chapters: chapters,
          ));
      message.show('切换成功');
    } else {
      message.show('未找到源');
    }
  }
}
