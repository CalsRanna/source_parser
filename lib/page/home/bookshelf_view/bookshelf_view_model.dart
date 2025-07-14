import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/model/information_entity.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_bottom_sheet.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class BookshelfViewModel {
  final books = signal(<BookEntity>[]);
  final shelfMode = signal('list');

  Future<void> initSignals() async {
    shelfMode.value = await SharedPreferenceUtil.getShelfMode();
    books.value = await BookService().getBooks();
    books.value.sort((a, b) {
      final pinyinA = PinyinHelper.getPinyin(a.name);
      final pinyinB = PinyinHelper.getPinyin(b.name);
      return pinyinA.compareTo(pinyinB);
    });
    FlutterNativeSplash.remove();
  }

  void navigateReaderPage(BuildContext context, BookEntity book) {
    ReaderRoute(book: book).push(context);
  }

  void openBookBottomSheet(BuildContext context, BookEntity book) {
    HapticFeedback.heavyImpact();
    var bottomSheet = BookshelfBottomSheet(
      book: book,
      onArchive: () => _archiveBook(book),
      onClearCache: () => _clearCache(context, book),
      onCoverSelect: () => _navigateCoverSelectorPage(context, book),
      onDestroyed: () => _destroyBook(book),
      onDetail: () => _navigateInformationPage(context, book),
    );
    showModalBottomSheet(builder: (_) => bottomSheet, context: context);
  }

  Future<void> refreshSignals(BuildContext context) async {
    try {
      for (var book in books.value) {
        if (book.archive) continue;
        final source = await SourceService().getBookSource(book.sourceId);
        var chapters = await _getRemoteChapters(book, source);
        if (chapters.isEmpty) continue;
        var chapterServer = ChapterService();
        await chapterServer.destroyChapters(book.id);
        await chapterServer.addChapters(chapters);
        var updatedBook = book.copyWith(chapterCount: chapters.length);
        await BookService().updateBook(updatedBook);
      }
      books.value = await BookService().getBooks();
      books.value.sort((a, b) {
        final pinyinA = PinyinHelper.getPinyin(a.name);
        final pinyinB = PinyinHelper.getPinyin(b.name);
        return pinyinA.compareTo(pinyinB);
      });
    } catch (error) {
      logger.e(error);
      if (!context.mounted) return;
      Message.of(context).show(error.toString());
    }
  }

  Future<void> updateShelfMode(String shelfMode) async {
    this.shelfMode.value = shelfMode;
    await SharedPreferenceUtil.setShelfMode(shelfMode);
  }

  Future<void> _archiveBook(BookEntity book) async {
    var updatedBook = book.copyWith(archive: !book.archive);
    await BookService().updateBook(updatedBook);
    books.value = await BookService().getBooks();
    books.value.sort((a, b) {
      final pinyinA = PinyinHelper.getPinyin(a.name);
      final pinyinB = PinyinHelper.getPinyin(b.name);
      return pinyinA.compareTo(pinyinB);
    });
  }

  Future<void> _clearCache(BuildContext context, BookEntity book) async {
    await CacheManager(prefix: book.name).clearCache();
    if (!context.mounted) return;
    Message.of(context).show('缓存已清除');
  }

  Future<void> _destroyBook(BookEntity book) async {
    await CacheManager(prefix: book.name).clearCache();
    await BookService().destroyBook(book.id);
    books.value = await BookService().getBooks();
    books.value.sort((a, b) {
      final pinyinA = PinyinHelper.getPinyin(a.name);
      final pinyinB = PinyinHelper.getPinyin(b.name);
      return pinyinA.compareTo(pinyinB);
    });
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

  void _navigateCoverSelectorPage(BuildContext context, BookEntity book) {
    CoverSelectorRoute(book: book).push(context);
  }

  void _navigateInformationPage(BuildContext context, BookEntity book) {
    var information = InformationEntity(
      book: book,
      chapters: [],
      availableSources: [],
      covers: [],
    );
    InformationRoute(information: information).push(context);
  }
}
