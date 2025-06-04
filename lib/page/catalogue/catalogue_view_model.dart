import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/book_source_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class CatalogueViewModel {
  final BookEntity book;
  var chapters = Signal(<ChapterEntity>[]);

  CatalogueViewModel({required this.book});

  Future<bool> checkChapter(int index) async {
    var chapter = chapters.value.elementAt(index);
    return CachedNetwork(prefix: book.name).check(chapter.url);
  }

  Future<void> initSignals() async {
    var isInShelf = await BookService().exist(book.id);
    if (isInShelf) {
      chapters.value = await ChapterService().getChapters(book.id);
    }
  }

  bool isActive(int index) {
    return book.chapterIndex == index;
  }

  void navigateReaderPage(BuildContext context, int index) {
    Navigator.of(context).pop(index);
  }

  Future<void> refreshChapters() async {
    var bookSource = await BookSourceService().getBookSource(book.sourceId);
    var source = Source.fromJson(bookSource.toJson());
    final cacheDuration = await SharedPreferenceUtil.getCacheDuration();
    final timeout = await SharedPreferenceUtil.getTimeout();
    var stream = await Parser.getChapters(
      book.name,
      book.catalogueUrl,
      source,
      Duration(hours: cacheDuration.floor()),
      Duration(milliseconds: timeout),
    );
    stream = stream.asBroadcastStream();
    List<ChapterEntity> newChapters = [];
    stream.listen((chapter) {
      newChapters.add(ChapterEntity.fromJson(chapter.toJson()));
    });
    await stream.last;
    chapters.value = newChapters;
  }
}
