import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class CatalogueViewModel {
  final book = signal<BookEntity>(BookEntity());
  final chapters = signal(<ChapterEntity>[]);

  Future<bool> checkChapter(int index) async {
    var chapter = chapters.value.elementAt(index);
    return CachedNetwork(prefix: book.value.name).check(chapter.url);
  }

  Future<void> initSignals(
      {required BookEntity book, List<ChapterEntity>? chapters}) async {
    this.book.value = book;
    if (chapters != null) {
      this.chapters.value = chapters;
      return;
    }
    var isInShelf = await BookService().checkIsInShelf(this.book.value.id);
    if (isInShelf) {
      this.chapters.value =
          await ChapterService().getChapters(this.book.value.id);
    }
  }

  bool isActive(int index) {
    return book.value.chapterIndex == index;
  }

  void navigateReaderPage(BuildContext context, int index) {
    Navigator.of(context).pop(index);
  }

  Future<void> refreshChapters() async {
    var bookSource = await SourceService().getBookSource(book.value.sourceId);
    var source = Source.fromJson(bookSource.toJson());
    final cacheDuration = await SharedPreferenceUtil.getCacheDuration();
    final timeout = await SharedPreferenceUtil.getTimeout();
    var stream = await Parser.getChapters(
      book.value.name,
      book.value.catalogueUrl,
      source,
      Duration(hours: cacheDuration),
      Duration(seconds: timeout),
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
