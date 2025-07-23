import 'dart:math';

import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';

class CatalogueViewModel {
  final book = signal(BookEntity());
  final chapters = signal(<ChapterEntity>[]);
  final position = signal(StringConfig.toBottom);

  var appBarKey = GlobalKey();
  late ScrollController controller;

  Future<bool> checkChapter(int index) async {
    var chapter = chapters.value.elementAt(index);
    return CachedNetwork(prefix: book.value.name).check(chapter.url);
  }

  void dispose() {
    controller.dispose();
  }

  void initController(BuildContext context) {
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final height = MediaQuery.of(context).size.height;
      final padding = MediaQuery.of(context).padding;
      final maxScrollExtent = controller.position.maxScrollExtent;
      final appBarContext = appBarKey.currentContext;
      final appBarRenderBox = appBarContext!.findRenderObject() as RenderBox;
      var listViewHeight = height - padding.vertical;
      listViewHeight = listViewHeight - appBarRenderBox.size.height;
      final halfHeight = listViewHeight / 2;
      var offset = 56.0 * book.value.chapterIndex;
      offset = max(0, (offset - halfHeight));
      if (maxScrollExtent > 0) {
        offset = offset.clamp(0, maxScrollExtent);
      }
      controller.jumpTo(offset);
    });
  }

  Future<void> initSignals({
    required BookEntity book,
    List<ChapterEntity>? chapters,
  }) async {
    this.book.value = book;
    if (chapters != null) {
      this.chapters.value = chapters;
      return;
    }
    var isInShelf = await BookService().checkIsInShelf(this.book.value.id);
    if (isInShelf) {
      this.chapters.value = await ChapterService().getChapters(
        this.book.value.id,
      );
    }
  }

  bool isActive(int index) {
    return book.value.chapterIndex == index;
  }

  void navigateReaderPage(BuildContext context, int index) {
    Navigator.of(context).pop(index);
  }

  Future<void> refreshChapters() async {
    var source = await SourceService().getBookSource(book.value.sourceId);
    var updatedChapters = await _getRemoteChapters(book.value, source);
    chapters.value = updatedChapters;
    book.value = book.value.copyWith(chapterCount: updatedChapters.length);
    var isInShelf = await BookService().checkIsInShelf(book.value.id);
    if (isInShelf) {
      if (updatedChapters.isEmpty) return;
      var chapterServer = ChapterService();
      await chapterServer.destroyChapters(book.value.id);
      await chapterServer.addChapters(chapters.value);
      await BookService().updateBook(book.value);
    }
  }

  void updatePosition() {
    var offset = controller.position.maxScrollExtent;
    if (position.value == StringConfig.toTop) {
      offset = controller.position.minScrollExtent;
    }
    position.value = position.value == StringConfig.toTop
        ? StringConfig.toBottom
        : StringConfig.toTop;
    controller.animateTo(
      offset,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 200),
    );
  }

  Future<List<ChapterEntity>> _getRemoteChapters(
    BookEntity book,
    SourceEntity source,
  ) async {
    var network = CachedNetwork(prefix: book.name);
    var html = await network.request(book.catalogueUrl);
    final parser = HtmlParser();
    var document = parser.parse(html);
    var preset = parser.query(document, source.cataloguePreset);
    var items = parser.queryNodes(document, source.catalogueChapters);
    List<ChapterEntity> chapters = [];
    var catalogueUrlRule = source.catalogueUrl;
    catalogueUrlRule = catalogueUrlRule.replaceAll('{{preset}}', preset);
    for (var i = 0; i < items.length; i++) {
      final name = parser.query(items[i], source.catalogueName);
      var url = parser.query(items[i], catalogueUrlRule);
      if (!url.startsWith('http')) url = '${source.url}$url';
      final chapter = ChapterEntity();
      chapter.name = name;
      chapter.url = url;
      chapter.bookId = book.id;
      chapters.add(chapter);
    }
    return chapters;
  }
}
