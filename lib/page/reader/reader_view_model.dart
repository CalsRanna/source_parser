import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/book_source_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/splitter.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

class ReaderViewModel {
  final BookEntity book;
  final availableSources = signal<List<AvailableSourceEntity>>([]);
  final chapters = signal<List<ChapterEntity>>([]);
  final previousChapterContent = signal('');
  final previousChapterPages = signal<List<String>>([]);
  final currentChapterContent = signal('');
  final currentChapterPages = signal<List<String>>([]);
  final nextChapterContent = signal('');
  final nextChapterPages = signal<List<String>>([]);
  late final chapterIndex = signal(book.chapterIndex);
  late final pageIndex = signal(book.pageIndex);

  late final controller = PageController(initialPage: book.pageIndex);

  ReaderViewModel({required this.book});

  Future<void> initSignals() async {
    var theme = Theme();
    var size = _initSize(theme);
    availableSources.value = await _getAvailableSources();
    chapters.value = await _initChapters();
    preloadPreviousChapter();
    currentChapterContent.value = await _getContent(book.chapterIndex);
    var splitter = Splitter(size: size, theme: theme);
    currentChapterPages.value = splitter.split(currentChapterContent.value);
    preloadNextChapter();
  }

  void nextPage() {
    if (chapterIndex.value == chapters.value.length - 1 &&
        pageIndex.value + 1 >= currentChapterPages.value.length) {
      return;
    }
    if (pageIndex.value + 1 >= currentChapterPages.value.length) {
      chapterIndex.value++;
      pageIndex.value = 0;
      previousChapterContent.value = currentChapterContent.value;
      previousChapterPages.value = currentChapterPages.value;
      currentChapterContent.value = nextChapterContent.value;
      currentChapterPages.value = nextChapterPages.value;
      controller.jumpToPage(pageIndex.value);
      preloadNextChapter();
      return;
    }
    pageIndex.value++;
    controller.nextPage(
      duration: Durations.medium1,
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    if (chapterIndex.value == 0 && pageIndex.value == 0) {
      return;
    }
    if (pageIndex.value - 1 < 0) {
      chapterIndex.value--;
      pageIndex.value = currentChapterPages.value.length - 1;
      nextChapterContent.value = currentChapterContent.value;
      nextChapterPages.value = currentChapterPages.value;
      currentChapterContent.value = previousChapterContent.value;
      currentChapterPages.value = previousChapterPages.value;
      controller.jumpToPage(pageIndex.value);
      preloadPreviousChapter();
      return;
    }
    pageIndex.value--;
    controller.previousPage(
      duration: Durations.medium1,
      curve: Curves.easeInOut,
    );
  }

  Future<void> preloadNextChapter() async {
    if (chapterIndex.value + 1 >= chapters.value.length) {
      nextChapterContent.value = '';
      nextChapterPages.value = [];
      return;
    }
    var theme = Theme();
    var size = _initSize(theme);
    nextChapterContent.value = await _getContent(chapterIndex.value + 1);
    var splitter = Splitter(size: size, theme: theme);
    nextChapterPages.value = splitter.split(nextChapterContent.value);
  }

  Future<void> preloadPreviousChapter() async {
    if (chapterIndex.value - 1 < 0) {
      previousChapterContent.value = '';
      previousChapterPages.value = [];
      return;
    }
    var theme = Theme();
    var size = _initSize(theme);
    previousChapterContent.value = await _getContent(chapterIndex.value - 1);
    var splitter = Splitter(size: size, theme: theme);
    previousChapterPages.value = splitter.split(previousChapterContent.value);
  }

  Future<List<AvailableSourceEntity>> _getAvailableSources() async {
    return await AvailableSourceService().getAvailableSources(book.id);
  }

  Future<List<ChapterEntity>> _getChapters() async {
    var source = await BookSourceService().getBookSource(book.sourceId);
    var chapters = await Parser.getChapters(
      book.name,
      book.catalogueUrl,
      Source(),
      Durations.medium1,
      Durations.medium2,
    );
    return [];
  }

  Future<String> _getContent(int chapterIndex) async {
    var source = await BookSourceService().getBookSource(book.sourceId);
    final method = source.contentMethod.toUpperCase();
    final network = CachedNetwork(
      prefix: book.name,
      timeout: Duration(hours: 6),
    );
    var url = chapters.value.elementAt(chapterIndex).url;
    final html = await network.request(
      url,
      charset: source.charset,
      method: method,
      reacquire: false,
    );
    final parser = HtmlParser();
    var document = parser.parse(html);
    var content = parser.query(document, source.contentContent);
    if (source.contentPagination.isNotEmpty) {
      var validation = parser.query(
        document,
        source.contentPaginationValidation,
      );
      while (validation.contains('下一页')) {
        var nextUrl = parser.query(document, source.contentPagination);
        if (!nextUrl.startsWith('http')) {
          nextUrl = '${source.url}$nextUrl';
        }
        var nextHtml = await network.request(
          nextUrl,
          charset: source.charset,
          method: method,
          reacquire: false,
        );
        document = parser.parse(nextHtml);
        var nextContent = parser.query(document, source.contentContent);
        content = '$content\n$nextContent';
        validation = parser.query(
          document,
          source.contentPaginationValidation,
        );
      }
    }
    if (content.isEmpty) {
      return content;
    }
    return '${book.name}\n\n$content';
  }

  Future<List<ChapterEntity>> _initChapters() async {
    var chapters = await ChapterService().getChapters(book.id);
    if (chapters.isNotEmpty) return chapters;
    return await _getChapters();
  }

  Size _initSize(Theme theme) {
    var screenSize =
        GetIt.instance.get<SourceParserViewModel>().screenSize.value;
    var pagePaddingHorizontal =
        theme.contentPaddingLeft + theme.contentPaddingRight;
    var pagePaddingVertical =
        theme.contentPaddingTop + theme.contentPaddingBottom;
    var width = screenSize.width - pagePaddingHorizontal;
    var headerPaddingVertical =
        theme.headerPaddingBottom + theme.headerPaddingTop;
    var footerPaddingVertical =
        theme.footerPaddingBottom + theme.footerPaddingTop;
    var height = screenSize.height - pagePaddingVertical;
    height -= headerPaddingVertical;
    height -= (theme.headerFontSize * theme.headerHeight);
    height -= footerPaddingVertical;
    height -= (theme.footerFontSize * theme.footerHeight);
    return Size(width, height);
  }

  Future<void> syncBookshelf() async {
    var book = this.book.copyWith(
          chapterIndex: chapterIndex.value,
          pageIndex: pageIndex.value,
        );
    await BookService().updateBook(book);
    GetIt.instance.get<BookshelfViewModel>().initSignals();
  }
}
