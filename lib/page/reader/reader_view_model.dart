import 'dart:math';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/book_source_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/book_source_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/color_extension.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/semaphore.dart';
import 'package:source_parser/util/splitter.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

class ReaderViewModel {
  final BookEntity book;
  final chapters = signal<List<ChapterEntity>>([]);
  final previousChapterContent = signal('');
  final previousChapterPages = signal<List<String>>([]);
  final currentChapterContent = signal('');
  final currentChapterPages = signal<List<String>>([]);
  final nextChapterContent = signal('');
  final nextChapterPages = signal<List<String>>([]);
  late final chapterIndex = signal(book.chapterIndex);
  late final pageIndex = signal(book.pageIndex);
  final theme = signal(Theme());
  final showOverlay = signal(false);
  final showCacheIndicator = signal(false);
  final downloadAmount = signal(0);
  final downloadSucceed = signal(0);
  final downloadFailed = signal(0);
  final battery = signal(100);
  final size = Signal(Size.zero);
  final source = Signal(BookSourceEntity());
  final error = signal('');

  late final progress = computed(() {
    if (downloadAmount.value == 0) return 0.0;
    return (downloadSucceed.value + downloadFailed.value) /
        downloadAmount.value;
  });

  late final controller = PageController(initialPage: book.pageIndex);

  ReaderViewModel({required this.book});

  void downloadChapters(BuildContext context, int amount) async {
    var realAmount = amount;
    if (amount == 0) {
      realAmount = chapters.value.length - (chapterIndex.value + 1);
    }
    realAmount = min(
      realAmount,
      chapters.value.length - (chapterIndex.value + 1),
    );
    downloadAmount.value = realAmount;
    downloadSucceed.value = 0;
    downloadFailed.value = 0;
    showCacheIndicator.value = true;
    final startIndex = book.chapterIndex + 1;
    final endIndex = min(
      startIndex + downloadAmount.value,
      chapters.value.length,
    );
    final semaphore = Semaphore(16);
    List<Future<void>> futures = [];
    for (var i = startIndex; i < endIndex; i++) {
      futures.add(_downloadChapter(source.value, i, semaphore));
    }
    await Future.wait(futures);
    if (!context.mounted) return;
    final message = Message.of(context);
    message.show('缓存完毕，$downloadSucceed章成功，$downloadFailed章失败');
    await Future.delayed(const Duration(seconds: 1));
    showCacheIndicator.value = false;
    downloadAmount.value = 0;
    downloadSucceed.value = 0;
    downloadFailed.value = 0;
  }

  String getFooterText(int index) {
    return '${index + 1}/${currentChapterPages.value.length}';
  }

  String getHeaderText(int index) {
    if (index == 0) return book.name;
    return chapters.value.elementAt(chapterIndex.value).name;
  }

  void hideUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    showOverlay.value = false;
  }

  Future<void> initSignals() async {
    theme.value = _initTheme();
    size.value = _initSize(theme.value);
    chapters.value = await _initChapters();
    source.value = await BookSourceService().getBookSource(book.sourceId);
    battery.value = await Battery().batteryLevel;
    if (chapters.value.isEmpty) {
      error.value = '没有找到章节';
      return;
    }
    _loadCurrentChapter();
    _preloadPreviousChapter();
    _preloadNextChapter();
  }

  Future<void> navigateAvailableSourcePage(BuildContext context) async {
    var copiedBook = book.copyWith(sourceId: source.value.id);
    var id = await AvailableSourceRoute(book: copiedBook).push<int>(context);
    if (id == null) return;
    currentChapterContent.value = '';
    currentChapterPages.value = [];
    var availableSource = await AvailableSourceService().getAvailableSource(id);
    source.value =
        await BookSourceService().getBookSource(availableSource.sourceId);
    chapters.value = await _getRemoteChapters();
    if (chapters.value.isEmpty) {
      error.value = '没有找到章节';
      return;
    }
    _loadCurrentChapter();
    _preloadPreviousChapter();
    _preloadNextChapter();
    await ChapterService().destroyChapters(book.id);
    await ChapterService().addChapters(chapters.value);
    await BookService().updateBook(book.copyWith(sourceId: id));
  }

  Future<void> navigateCataloguePage(BuildContext context) async {
    var currentState = book.copyWith(chapterIndex: chapterIndex.value);
    var index = await CatalogueRoute(book: currentState).push<int>(context);
    if (index == null) return;
    chapterIndex.value = index;
    updatePageIndex(0);
    _preloadPreviousChapter();
    currentChapterContent.value = await _getContent(chapterIndex.value);
    var splitter = Splitter(size: size.value, theme: theme.value);
    currentChapterPages.value = splitter.split(currentChapterContent.value);
    controller.jumpToPage(pageIndex.value);
    _preloadNextChapter();
  }

  void nextChapter() {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value + 1 >= chapters.value.length) {
      return;
    }
    chapterIndex.value++;
    updatePageIndex(0);
    previousChapterContent.value = currentChapterContent.value;
    previousChapterPages.value = currentChapterPages.value;
    currentChapterContent.value = nextChapterContent.value;
    currentChapterPages.value = nextChapterPages.value;
    controller.jumpToPage(pageIndex.value);
    _preloadNextChapter();
  }

  Future<void> nextPage() async {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value == chapters.value.length - 1 &&
        pageIndex.value + 1 >= currentChapterPages.value.length) {
      return;
    }
    if (pageIndex.value + 1 >= currentChapterPages.value.length) {
      chapterIndex.value++;
      updatePageIndex(0);
      previousChapterContent.value = currentChapterContent.value;
      previousChapterPages.value = currentChapterPages.value;
      currentChapterContent.value = nextChapterContent.value;
      currentChapterPages.value = nextChapterPages.value;
      controller.jumpToPage(pageIndex.value);
      _preloadNextChapter();
      return;
    }
    controller.nextPage(
      duration: Durations.medium1,
      curve: Curves.easeInOut,
    );
    battery.value = await Battery().batteryLevel;
  }

  void previousChapter() {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value - 1 < 0) return;
    chapterIndex.value--;
    updatePageIndex(0);
    nextChapterContent.value = currentChapterContent.value;
    nextChapterPages.value = currentChapterPages.value;
    currentChapterContent.value = previousChapterContent.value;
    currentChapterPages.value = previousChapterPages.value;
    controller.jumpToPage(pageIndex.value);
    _preloadPreviousChapter();
  }

  Future<void> previousPage() async {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value == 0 && pageIndex.value == 0) {
      return;
    }
    if (pageIndex.value - 1 < 0) {
      chapterIndex.value--;
      updatePageIndex(previousChapterPages.value.length - 1);
      nextChapterContent.value = currentChapterContent.value;
      nextChapterPages.value = currentChapterPages.value;
      currentChapterContent.value = previousChapterContent.value;
      currentChapterPages.value = previousChapterPages.value;
      controller.jumpToPage(pageIndex.value);
      _preloadPreviousChapter();
      return;
    }
    controller.previousPage(
      duration: Durations.medium1,
      curve: Curves.easeInOut,
    );
    battery.value = await Battery().batteryLevel;
  }

  void showUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    showOverlay.value = true;
  }

  Future<void> syncBookshelf() async {
    GetIt.instance.get<BookshelfViewModel>().initSignals();
  }

  void toggleDarkMode() {
    GetIt.instance.get<SourceParserViewModel>().toggleDarkMode();
    theme.value = _assembleTheme(theme.value);
  }

  void turnPage(TapUpDetails details) {
    final size = GetIt.instance.get<SourceParserViewModel>().screenSize.value;
    final horizontalTapArea = details.globalPosition.dx / size.width;
    final verticalTapArea = details.globalPosition.dy / size.height;
    if (horizontalTapArea < 1 / 3) {
      previousPage();
    } else if (horizontalTapArea > 2 / 3) {
      nextPage();
    } else if (horizontalTapArea >= 1 / 3 && horizontalTapArea <= 2 / 3) {
      if (verticalTapArea > 3 / 4) {
        nextPage();
      } else if (verticalTapArea < 1 / 4) {
        previousPage();
      } else {
        showUiOverlays();
      }
    }
  }

  void updatePageIndex(int index) {
    pageIndex.value = index;
    var copiedBook = book.copyWith(
      chapterIndex: chapterIndex.value,
      pageIndex: pageIndex.value,
      sourceId: source.value.id,
    );
    BookService().updateBook(copiedBook);
  }

  Theme _assembleTheme(Theme theme) {
    var defaultTheme = Theme();
    var backgroundColor = defaultTheme.backgroundColor;
    var contentColor = defaultTheme.contentColor;
    var footerColor = defaultTheme.footerColor;
    var headerColor = defaultTheme.headerColor;
    var darkModel =
        GetIt.instance.get<SourceParserViewModel>().isDarkMode.value;
    if (darkModel) {
      backgroundColor = Colors.black.toHex()!;
      contentColor = Colors.white.withValues(alpha: 0.75).toHex()!;
      footerColor = Colors.white.withValues(alpha: 0.5).toHex()!;
      headerColor = Colors.white.withValues(alpha: 0.5).toHex()!;
    }
    return theme.copyWith(
      backgroundColor: backgroundColor,
      contentColor: contentColor,
      footerColor: footerColor,
      headerColor: headerColor,
    );
  }

  Future<void> _downloadChapter(
    BookSourceEntity source,
    int index,
    Semaphore semaphore,
  ) async {
    await semaphore.acquire();
    try {
      final url = chapters.value.elementAt(index).url;
      final network = CachedNetwork(prefix: book.name);
      final cached = await network.check(url);
      if (!cached) {
        await network.request(
          url,
          charset: source.charset,
          method: source.contentMethod,
        );
      }
      downloadSucceed.value++;
    } catch (error) {
      downloadFailed.value++;
    } finally {
      semaphore.release();
    }
  }

  Future<String> _getContent(int chapterIndex) async {
    final network = CachedNetwork(
      prefix: book.name,
      timeout: Duration(hours: 6),
    );
    var url = chapters.value.elementAt(chapterIndex).url;
    final html = await network.request(
      url,
      charset: source.value.charset,
      method: source.value.contentMethod.toUpperCase(),
    );
    final parser = HtmlParser();
    var document = parser.parse(html);
    var content = parser.query(document, source.value.contentContent);
    if (source.value.contentPagination.isNotEmpty) {
      var validation = parser.query(
        document,
        source.value.contentPaginationValidation,
      );
      while (validation.contains('下一页')) {
        var nextUrl = parser.query(document, source.value.contentPagination);
        if (!nextUrl.startsWith('http')) {
          nextUrl = '${source.value.url}$nextUrl';
        }
        var nextHtml = await network.request(
          nextUrl,
          charset: source.value.charset,
          method: source.value.contentMethod.toUpperCase(),
          reacquire: false,
        );
        document = parser.parse(nextHtml);
        var nextContent = parser.query(document, source.value.contentContent);
        content = '$content\n$nextContent';
        validation = parser.query(
          document,
          source.value.contentPaginationValidation,
        );
      }
    }
    if (content.isEmpty) {
      return content;
    }
    var chapterName = chapters.value.elementAt(chapterIndex).name;
    return '$chapterName\n\n$content';
  }

  Future<List<ChapterEntity>> _getRemoteChapters() async {
    var network = CachedNetwork(prefix: book.name);
    var html = await network.request(book.catalogueUrl);
    final parser = HtmlParser();
    var document = parser.parse(html);
    var preset = parser.query(document, source.value.cataloguePreset);
    var items = parser.queryNodes(document, source.value.catalogueChapters);
    List<ChapterEntity> chapters = [];
    var catalogueUrlRule = source.value.catalogueUrl;
    catalogueUrlRule = catalogueUrlRule.replaceAll('{{preset}}', preset);
    for (var i = 0; i < items.length; i++) {
      final name = parser.query(items[i], source.value.catalogueName);
      var url = parser.query(items[i], catalogueUrlRule);
      if (!url.startsWith('http')) url = '${source.value.url}$url';
      final chapter = ChapterEntity();
      chapter.name = name;
      chapter.url = url;
      chapters.add(chapter);
    }
    return chapters;
  }

  Future<List<ChapterEntity>> _initChapters() async {
    var chapters = await ChapterService().getChapters(book.id);
    if (chapters.isNotEmpty) return chapters;
    return await _getRemoteChapters();
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

  Theme _initTheme() {
    var defaultTheme = Theme()
      ..footerPaddingBottom = 24
      ..headerPaddingTop = 48;
    return _assembleTheme(defaultTheme);
  }

  Future<void> _loadCurrentChapter() async {
    currentChapterContent.value = await _getContent(book.chapterIndex);
    var splitter = Splitter(size: size.value, theme: theme.value);
    currentChapterPages.value = splitter.split(currentChapterContent.value);
  }

  Future<void> _preloadNextChapter() async {
    if (chapterIndex.value + 1 >= chapters.value.length) {
      nextChapterContent.value = '';
      nextChapterPages.value = [];
      return;
    }
    nextChapterContent.value = await _getContent(chapterIndex.value + 1);
    var splitter = Splitter(size: size.value, theme: theme.value);
    nextChapterPages.value = splitter.split(nextChapterContent.value);
  }

  Future<void> _preloadPreviousChapter() async {
    if (chapterIndex.value - 1 < 0) {
      previousChapterContent.value = '';
      previousChapterPages.value = [];
      return;
    }
    previousChapterContent.value = await _getContent(chapterIndex.value - 1);
    var splitter = Splitter(size: size.value, theme: theme.value);
    previousChapterPages.value = splitter.split(previousChapterContent.value);
  }
}
