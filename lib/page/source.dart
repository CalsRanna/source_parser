import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/book.dart';

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
            return ListTile(title: Text(book.sources[index].toString()));
          },
          itemCount: book.sources.length,
        );
      }),
    );
  }
}
