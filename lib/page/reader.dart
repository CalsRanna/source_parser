// import 'package:book_reader/book_reader.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/chapter.dart';
import 'package:source_parser/page/reader/src/widget/reader.dart';
import 'package:source_parser/util/parser.dart';

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
      final chapters = ref.watch(currentChaptersCreator);
      final index = ref.watch(currentChapterIndexCreator);
      final source = ref.watch(currentSourceCreator);

      return BookReader(
        future: (index) => Parser().getContent(
          url: chapters.elementAt(index).url,
          source: source,
        ),
        index: index,
        total: chapters.length,
        name: book.name,
      );
    });
  }
}
