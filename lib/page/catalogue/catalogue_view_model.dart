import 'package:flutter/widgets.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/component/catalogue_list_view.dart';
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
  final listKey = GlobalKey<CatalogueListViewState>();

  Future<bool> checkChapter(int index) async {
    var chapter = chapters.value.elementAt(index);
    return CachedNetwork(prefix: book.value.name).check(chapter.url);
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
    var position = this.position.value == StringConfig.toTop
        ? CatalogueScrollPosition.top
        : CatalogueScrollPosition.center;
    listKey.currentState?.scrollToPosition(position);
    this.position.value = this.position.value == StringConfig.toTop
        ? StringConfig.toBottom
        : StringConfig.toTop;
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
