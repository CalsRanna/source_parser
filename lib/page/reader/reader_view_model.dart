import 'dart:async';
import 'dart:math';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/database/replacement_service.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/page/reader/page_turn/page_turn_controller.dart';
import 'package:source_parser/page/reader/reader_exception.dart';
import 'package:source_parser/page/reader/reader_turning_mode.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/color_extension.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/semaphore.dart';
import 'package:source_parser/util/shared_preference_util.dart';
import 'package:source_parser/util/splitter.dart';
import 'package:source_parser/util/string_extension.dart';
import 'package:source_parser/util/volume_util.dart';
import 'package:source_parser/view_model/app_theme_view_model.dart';

class ReaderViewModel {
  final BookEntity book;
  final catalogueUrl = signal('');
  final chapters = signal<List<ChapterEntity>>([]);
  final availableSources = signal(<AvailableSourceEntity>[]);
  final previousChapterContent = signal('');
  final previousChapterPages = signal<List<String>>([]);
  final currentChapterContent = signal('');
  final currentChapterPages = signal<List<String>>([]);
  final nextChapterContent = signal('');
  final nextChapterPages = signal<List<String>>([]);
  final chapterIndex = signal(0);
  final pageIndex = signal(0);
  final theme = signal(Theme());
  final showOverlay = signal(false);
  final showCacheIndicator = signal(false);
  final downloadAmount = signal(0);
  final downloadSucceed = signal(0);
  final downloadFailed = signal(0);
  final battery = signal(100);
  final size = signal(Size.zero);
  final source = signal(SourceEntity());
  final error = signal('');
  final eInkMode = signal(false);
  final pageTurnMode = signal(PageTurnMode.slide);
  final previousChapterLoading = signal(false);
  final nextChapterLoading = signal(false);

  late final progress = computed(() {
    if (downloadAmount.value == 0) return 0.0;
    return (downloadSucceed.value + downloadFailed.value) /
        downloadAmount.value;
  });
  late final isDarkMode = computed(() {
    var sourceParserViewModel = GetIt.instance.get<SourceParserViewModel>();
    return sourceParserViewModel.isDarkMode.value;
  });

  late final pageCount = computed(() {
    var prev = chapterIndex.value > 0 ? 1 : 0;
    var hasChapters = chapters.value.isNotEmpty;
    var next =
        hasChapters && chapterIndex.value < chapters.value.length - 1 ? 1 : 0;
    return prev + currentChapterPages.value.length + next;
  });

  late final currentChapterOffset = computed(() {
    return chapterIndex.value > 0 ? 1 : 0;
  });

  late final pageTurnController = PageTurnController(
    initialIndex: book.pageIndex,
  );
  late final subscription = VolumeUtil.stream.listen((event) {
    if (event == 'volume_up') {
      previousPage();
    } else if (event == 'volume_down') {
      nextPage();
    }
  });

  bool _isRotating = false;
  Timer? _progressDebounce;

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
    final startIndex = chapterIndex.value + 1;
    final endIndex = min(
      startIndex + downloadAmount.value,
      chapters.value.length,
    );
    var concurrent = await SharedPreferenceUtil.getMaxConcurrent();
    final semaphore = Semaphore(concurrent);
    List<Future<void>> futures = [];
    for (var i = startIndex; i < endIndex; i++) {
      futures.add(_downloadChapter(source.value, i, semaphore));
    }
    await Future.wait(futures);
    if (!context.mounted) return;
    DialogUtil.snackBar(StringConfig.cacheCompleted.format([
      downloadSucceed.value,
      downloadFailed.value,
    ]));
    await Future.delayed(const Duration(seconds: 1));
    showCacheIndicator.value = false;
    downloadAmount.value = 0;
    downloadSucceed.value = 0;
    downloadFailed.value = 0;
  }

  void navigateReplacementPage(BuildContext context) {
    ReaderReplacementRoute(book: book).push(context);
  }

  String getFooterText(int index) {
    var totalPagesInChapter = currentChapterPages.value.length;
    var totalChapters = chapters.value.length;
    if (totalChapters == 0 || totalPagesInChapter == 0) {
      return '${index + 1}/$totalPagesInChapter 0.00%';
    }
    var pageProgress = '${index + 1}/$totalPagesInChapter';
    var progressInChapter = (index + 1) / totalPagesInChapter;
    var progress = (chapterIndex.value + progressInChapter) / totalChapters;
    var percent = (progress.clamp(0.0, 1.0) * 100).toStringAsFixed(2);
    return '$pageProgress $percent%';
  }

  String getHeaderText(int index) {
    if (index == 0) return book.name;
    if (chapterIndex.value < chapters.value.length) {
      return chapters.value.elementAt(chapterIndex.value).name;
    }
    return book.name;
  }

  ({
    String content,
    String header,
    String footer,
    bool isFirstPage,
    bool isLoading,
  }) getPageData(int flatIndex) {
    var offset = currentChapterOffset.value;
    var currLen = currentChapterPages.value.length;

    // Previous chapter placeholder
    if (flatIndex < offset) {
      if (previousChapterPages.value.isNotEmpty) {
        var lastIndex = previousChapterPages.value.length - 1;
        var prevChapterIdx = chapterIndex.value - 1;
        return (
          content: previousChapterPages.value[lastIndex],
          header: _getHeaderForChapter(prevChapterIdx, lastIndex),
          footer: _getFooterForChapter(
            prevChapterIdx,
            lastIndex,
            previousChapterPages.value.length,
          ),
          isFirstPage: false,
          isLoading: false,
        );
      }
      return (
        content: '',
        header: '',
        footer: '',
        isFirstPage: false,
        isLoading: true,
      );
    }

    // Next chapter placeholder
    if (flatIndex >= offset + currLen) {
      if (nextChapterPages.value.isNotEmpty) {
        var nextChapterIdx = chapterIndex.value + 1;
        return (
          content: nextChapterPages.value[0],
          header: _getHeaderForChapter(nextChapterIdx, 0),
          footer: _getFooterForChapter(
            nextChapterIdx,
            0,
            nextChapterPages.value.length,
          ),
          isFirstPage: true,
          isLoading: false,
        );
      }
      return (
        content: '',
        header: '',
        footer: '',
        isFirstPage: false,
        isLoading: true,
      );
    }

    // Current chapter page
    var localIndex = flatIndex - offset;
    return (
      content: currentChapterPages.value[localIndex],
      header: getHeaderText(localIndex),
      footer: getFooterText(localIndex),
      isFirstPage: localIndex == 0,
      isLoading: false,
    );
  }

  void handlePageChanged(int flatIndex) {
    if (_isRotating) return;
    var offset = currentChapterOffset.value;
    var currLen = currentChapterPages.value.length;

    if (flatIndex < offset) {
      if (previousChapterPages.value.isNotEmpty) {
        _rotateToPreviousChapter();
      }
    } else if (flatIndex >= offset + currLen) {
      if (nextChapterPages.value.isNotEmpty) {
        _rotateToNextChapter();
      }
    } else {
      updatePageIndex(flatIndex - offset);
    }
  }

  void _rotateToNextChapter({int? targetPage}) {
    _isRotating = true;
    chapterIndex.value++;
    previousChapterContent.value = currentChapterContent.value;
    previousChapterPages.value = currentChapterPages.value;
    previousChapterLoading.value = false;
    currentChapterContent.value = nextChapterContent.value;
    currentChapterPages.value = nextChapterPages.value;
    nextChapterContent.value = '';
    nextChapterPages.value = [];
    nextChapterLoading.value = false;
    var page = targetPage ?? 0;
    updatePageIndex(page);
    _preloadNextChapter();
    if (currentChapterPages.value.isEmpty) {
      _loadCurrentChapter();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageTurnController.jumpToPage(currentChapterOffset.value + page);
        _isRotating = false;
      });
    }
  }

  void _rotateToPreviousChapter({int? targetPage}) {
    _isRotating = true;
    chapterIndex.value--;
    nextChapterContent.value = currentChapterContent.value;
    nextChapterPages.value = currentChapterPages.value;
    nextChapterLoading.value = false;
    currentChapterContent.value = previousChapterContent.value;
    currentChapterPages.value = previousChapterPages.value;
    previousChapterContent.value = '';
    previousChapterPages.value = [];
    previousChapterLoading.value = false;
    var page = targetPage ??
        (currentChapterPages.value.isNotEmpty
            ? currentChapterPages.value.length - 1
            : 0);
    updatePageIndex(page);
    _preloadPreviousChapter();
    if (currentChapterPages.value.isEmpty) {
      _loadCurrentChapter();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageTurnController.jumpToPage(currentChapterOffset.value + page);
        _isRotating = false;
      });
    }
  }

  String _getHeaderForChapter(int chapterIdx, int localIndex) {
    if (chapterIdx < 0 || chapterIdx >= chapters.value.length) return '';
    if (localIndex == 0) return book.name;
    return chapters.value.elementAt(chapterIdx).name;
  }

  String _getFooterForChapter(
    int chapterIdx,
    int localIndex,
    int totalPagesInChapter,
  ) {
    var totalChapters = chapters.value.length;
    if (totalChapters == 0 || totalPagesInChapter == 0) {
      return '${localIndex + 1}/$totalPagesInChapter 0.00%';
    }
    var pageProgress = '${localIndex + 1}/$totalPagesInChapter';
    var progressInChapter = (localIndex + 1) / totalPagesInChapter;
    var progress =
        (chapterIdx + progressInChapter) / totalChapters;
    var percent = (progress.clamp(0.0, 1.0) * 100).toStringAsFixed(2);
    return '$pageProgress $percent%';
  }

  void hideUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    showOverlay.value = false;
  }

  Future<void> initSignals() async {
    await GetIt.instance.get<AppThemeViewModel>().initSignals();
    theme.value = _initTheme();
    size.value = _initSize(theme.value);
    chapterIndex.value = book.chapterIndex;
    pageIndex.value = book.pageIndex;
    catalogueUrl.value = book.catalogueUrl;
    chapters.value = await _initChapters();
    availableSources.value = await _initAvailableSources();
    source.value = await SourceService().getBookSource(book.sourceId);
    eInkMode.value = await SharedPreferenceUtil.getEInkMode();
    var modeStr = await SharedPreferenceUtil.getPageTurnMode();
    pageTurnMode.value = PageTurnMode.fromString(modeStr);
    pageTurnController.onPageChanged = handlePageChanged;
    await _getBattery();
    if (chapters.value.isEmpty) {
      error.value = StringConfig.chapterNotFound;
      return;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    await _loadCurrentChapter();
    _preloadPreviousChapter();
    _preloadNextChapter();
  }

  Future<void> navigateAvailableSourcePage(BuildContext context) async {
    var copiedBook = book.copyWith(sourceId: source.value.id);
    var availableSource = await AvailableSourceRoute(
      availableSources: availableSources.value,
      book: copiedBook,
    ).push<AvailableSourceEntity>(context);
    availableSources.value = await _initAvailableSources();
    if (availableSource == null) return;
    DialogUtil.loading();
    _isRotating = true;
    var sourceId = availableSource.sourceId;
    source.value = await SourceService().getBookSource(sourceId);
    var url = availableSource.url;
    var updatedCatalogueUrl = await _getRemoteCatalogueUrl(url);
    catalogueUrl.value = updatedCatalogueUrl;
    var updatedChapters = await _getRemoteChapters();
    if (updatedChapters.isEmpty) {
      _isRotating = false;
      DialogUtil.dismiss();
      if (!context.mounted) return;
      DialogUtil.snackBar(StringConfig.chapterNotFound);
      return;
    }
    chapters.value = updatedChapters;
    chapterIndex.value = min(chapterIndex.value, updatedChapters.length - 1);
    pageIndex.value = 0;
    currentChapterContent.value = '';
    currentChapterPages.value = [];
    previousChapterContent.value = '';
    previousChapterPages.value = [];
    previousChapterLoading.value = false;
    nextChapterContent.value = '';
    nextChapterPages.value = [];
    nextChapterLoading.value = false;
    _loadCurrentChapter();
    _preloadPreviousChapter();
    _preloadNextChapter();
    await ChapterService().destroyChapters(book.id);
    await ChapterService().addChapters(updatedChapters);
    var updatedBook = book.copyWith(
      catalogueUrl: catalogueUrl.value,
      chapterCount: updatedChapters.length,
      sourceId: sourceId,
    );
    await BookService().updateBook(updatedBook);
    DialogUtil.dismiss();
    var bookshelfViewModel = GetIt.instance.get<BookshelfViewModel>();
    bookshelfViewModel.initSignals();
  }

  Future<void> navigateCataloguePage(BuildContext context) async {
    var currentState = book.copyWith(chapterIndex: chapterIndex.value);
    var index = await CatalogueRoute(
      book: currentState,
      chapters: chapters.value,
    ).push<int>(context);
    if (index == null) return;
    _isRotating = true;
    chapterIndex.value = index;
    updatePageIndex(0);
    currentChapterPages.value = [];
    previousChapterContent.value = '';
    previousChapterPages.value = [];
    previousChapterLoading.value = false;
    nextChapterContent.value = '';
    nextChapterPages.value = [];
    nextChapterLoading.value = false;
    await _loadCurrentChapter();
    _preloadPreviousChapter();
    _preloadNextChapter();
  }

  void nextChapter() {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value + 1 >= chapters.value.length) {
      DialogUtil.snackBar(StringConfig.noMoreChapter);
      return;
    }
    if (nextChapterPages.value.isNotEmpty) {
      _rotateToNextChapter();
    } else {
      var nextPlaceholderIndex =
          currentChapterOffset.value + currentChapterPages.value.length;
      pageTurnController.jumpToPage(nextPlaceholderIndex);
    }
  }

  Future<void> nextPage() async {
    if (chapters.value.isEmpty) return;
    await _getBattery();
    if (pageTurnController.currentIndex + 1 < pageCount.value) {
      pageTurnController.animateToNext();
    } else {
      DialogUtil.snackBar(StringConfig.noMoreChapter);
    }
  }

  void previousChapter() {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value - 1 < 0) {
      DialogUtil.snackBar(StringConfig.noChapterBefore);
      return;
    }
    if (previousChapterPages.value.isNotEmpty) {
      _rotateToPreviousChapter(targetPage: 0);
    } else {
      pageTurnController.jumpToPage(0);
    }
  }

  Future<void> previousPage() async {
    if (chapters.value.isEmpty) return;
    await _getBattery();
    if (pageTurnController.currentIndex > 0) {
      pageTurnController.animateToPrevious();
    } else {
      DialogUtil.snackBar(StringConfig.noChapterBefore);
    }
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
    theme.value = _initTheme();
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
      if (verticalTapArea > 2 / 3) {
        nextPage();
      } else if (verticalTapArea < 1 / 3) {
        previousPage();
      } else {
        showUiOverlays();
      }
    }
  }

  void updatePageIndex(int index) {
    pageIndex.value = index;
    _debouncePersistProgress();
  }

  void _debouncePersistProgress() {
    _progressDebounce?.cancel();
    _progressDebounce = Timer(const Duration(seconds: 1), () {
      var copiedBook = book.copyWith(
        chapterIndex: chapterIndex.value,
        pageIndex: pageIndex.value,
        sourceId: source.value.id,
      );
      BookService().updateBook(copiedBook);
    });
  }

  Theme _assembleTheme(Theme theme) {
    var backgroundColor = theme.backgroundColor;
    var contentColor = theme.contentColor;
    var footerColor = theme.footerColor;
    var headerColor = theme.headerColor;
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
    SourceEntity source,
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
    } catch (e) {
      downloadFailed.value++;
    } finally {
      semaphore.release();
    }
  }

  Future<void> _getBattery() async {
    try {
      battery.value = await Battery().batteryLevel;
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<String> _getContent(int chapterIndex, {bool reacquire = false}) async {
    var chapterName = chapters.value.elementAt(chapterIndex).name;
    var seconds = await SharedPreferenceUtil.getTimeout();
    var timeout = Duration(seconds: seconds);
    final network = CachedNetwork(prefix: book.name, timeout: timeout);
    var url = chapters.value.elementAt(chapterIndex).url;
    final html = await network.request(
      url,
      charset: source.value.charset,
      method: source.value.contentMethod.toUpperCase(),
      reacquire: reacquire,
    );
    final parser = HtmlParser();
    var document = parser.parse(html);
    var content = parser.query(document, source.value.contentContent);
    if (content.isEmpty) {
      throw ReaderException('$chapterName\n\n${StringConfig.emptyContent}');
    }
    if (source.value.contentPagination.isNotEmpty) {
      var validation = parser.query(
        document,
        source.value.contentPaginationValidation,
      );
      while (validation.contains(StringConfig.nextPage)) {
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
    var replacements =
        await ReplacementService().getReplacementsByBookId(book.id);
    for (var replacement in replacements) {
      content = content.replaceAll(replacement.source, replacement.target);
    }
    return '$chapterName\n\n$content';
  }

  Future<String> _getRemoteCatalogueUrl(String url) async {
    var network = CachedNetwork(prefix: book.name);
    var html = await network.request(url);
    final parser = HtmlParser();
    var document = parser.parse(html);
    var catalogueUrl =
        parser.query(document, source.value.informationCatalogueUrl);
    if (!catalogueUrl.startsWith('http')) {
      catalogueUrl = '${source.value.url}$catalogueUrl';
    }
    return catalogueUrl;
  }

  Future<List<ChapterEntity>> _getRemoteChapters() async {
    var network = CachedNetwork(prefix: book.name);
    var html = await network.request(catalogueUrl.value);
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
      chapter.bookId = book.id;
      chapters.add(chapter);
    }
    return chapters;
  }

  Future<List<AvailableSourceEntity>> _initAvailableSources() async {
    return await AvailableSourceService().getAvailableSources(book.id);
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
    var appThemeViewModel = GetIt.instance.get<AppThemeViewModel>();
    var savedTheme = appThemeViewModel.currentTheme.value;
    return _assembleTheme(savedTheme);
  }

  Future<void> forceRefresh() async {
    _isRotating = true;
    currentChapterPages.value = [];
    updatePageIndex(0);
    await _loadCurrentChapter(reacquire: true);
    _preloadPreviousChapter();
    _preloadNextChapter();
  }

  Future<void> _loadCurrentChapter({bool reacquire = false}) async {
    try {
      currentChapterContent.value = await _getContent(
        chapterIndex.value,
        reacquire: reacquire,
      );
    } on ReaderException catch (e) {
      currentChapterContent.value = e.message;
    }
    var splitter = Splitter(size: size.value, theme: theme.value);
    _isRotating = true;
    currentChapterPages.value = splitter.split(currentChapterContent.value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageTurnController.jumpToPage(currentChapterOffset.value + pageIndex.value);
      _isRotating = false;
    });
  }

  Future<void> _preloadNextChapter() async {
    if (chapterIndex.value + 1 >= chapters.value.length) {
      nextChapterContent.value = '';
      nextChapterPages.value = [];
      nextChapterLoading.value = false;
      return;
    }
    nextChapterLoading.value = true;
    try {
      nextChapterContent.value = await _getContent(chapterIndex.value + 1);
    } on ReaderException catch (e) {
      nextChapterContent.value = e.message;
    }
    var splitter = Splitter(size: size.value, theme: theme.value);
    nextChapterPages.value = splitter.split(nextChapterContent.value);
    nextChapterLoading.value = false;
    // Auto-rotate if user is already on the next placeholder
    if (!_isRotating) {
      var flatIndex = pageTurnController.currentIndex;
      var offset = currentChapterOffset.value;
      var currLen = currentChapterPages.value.length;
      if (flatIndex >= offset + currLen) {
        _rotateToNextChapter();
      }
    }
  }

  Future<void> _preloadPreviousChapter() async {
    if (chapterIndex.value - 1 < 0) {
      previousChapterContent.value = '';
      previousChapterPages.value = [];
      previousChapterLoading.value = false;
      return;
    }
    previousChapterLoading.value = true;
    try {
      previousChapterContent.value = await _getContent(chapterIndex.value - 1);
    } on ReaderException catch (e) {
      previousChapterContent.value = e.message;
    }
    var splitter = Splitter(size: size.value, theme: theme.value);
    previousChapterPages.value = splitter.split(previousChapterContent.value);
    previousChapterLoading.value = false;
    // Auto-rotate if user is already on the previous placeholder
    if (!_isRotating) {
      var flatIndex = pageTurnController.currentIndex;
      if (flatIndex < currentChapterOffset.value) {
        _rotateToPreviousChapter();
      }
    }
  }
}
