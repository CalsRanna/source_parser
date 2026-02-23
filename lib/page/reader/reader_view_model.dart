import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_controller.dart';
import 'package:source_parser/component/reader/reader_exception.dart';
import 'package:source_parser/component/reader/reader_turning_mode.dart';
import 'package:source_parser/component/reader/reader_view_model_interface.dart';
import 'package:source_parser/component/reader/reader_view_model_mixin.dart';
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
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/semaphore.dart';
import 'package:source_parser/util/shared_preference_util.dart';
import 'package:source_parser/util/string_extension.dart';
import 'package:source_parser/view_model/app_theme_view_model.dart';

class ReaderViewModel with ReaderViewModelMixin implements ReaderViewModelInterface {
  final BookEntity book;
  final catalogueUrl = signal('');
  final chapters = signal<List<ChapterEntity>>([]);
  final availableSources = signal(<AvailableSourceEntity>[]);
  final showCacheIndicator = signal(false);
  final downloadAmount = signal(0);
  final downloadSucceed = signal(0);
  final downloadFailed = signal(0);
  final source = signal(SourceEntity());

  late final progress = computed(() {
    if (downloadAmount.value == 0) return 0.0;
    return (downloadSucceed.value + downloadFailed.value) /
        downloadAmount.value;
  });

  @override
  late final pageTurnController = PageTurnController(
    initialIndex: book.pageIndex,
  );

  Timer? _progressDebounce;

  ReaderViewModel({required this.book});

  // --- ReaderViewModelMixin abstract members ---

  @override
  String get bookName => book.name;

  @override
  int get totalChapterCount => chapters.value.length;

  @override
  String getChapterName(int index) => chapters.value.elementAt(index).name;

  @override
  Future<String> fetchContent(int chapterIndex, {bool reacquire = false}) async {
    try {
      return await _getContent(chapterIndex, reacquire: reacquire);
    } on ReaderException catch (e) {
      return e.message;
    }
  }

  @override
  void onPageIndexUpdated(int chapterIdx, int pageIdx) {
    _debouncePersistProgress();
  }

  // --- Local-only logic ---

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

  Future<void> initSignals() async {
    await GetIt.instance.get<AppThemeViewModel>().initSignals();
    theme.value = initTheme();
    size.value = initSize(theme.value);
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
    await getBattery();
    if (chapters.value.isEmpty) {
      error.value = StringConfig.chapterNotFound;
      return;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    await loadCurrentChapter();
    preloadPreviousChapter();
    preloadNextChapter();
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
    isRotating = true;
    var sourceId = availableSource.sourceId;
    source.value = await SourceService().getBookSource(sourceId);
    var url = availableSource.url;
    var updatedCatalogueUrl = await _getRemoteCatalogueUrl(url);
    catalogueUrl.value = updatedCatalogueUrl;
    var updatedChapters = await _getRemoteChapters();
    if (updatedChapters.isEmpty) {
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
    loadCurrentChapter();
    preloadPreviousChapter();
    preloadNextChapter();
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
    isRotating = true;
    chapterIndex.value = index;
    updatePageIndex(0);
    currentChapterPages.value = [];
    previousChapterContent.value = '';
    previousChapterPages.value = [];
    previousChapterLoading.value = false;
    nextChapterContent.value = '';
    nextChapterPages.value = [];
    nextChapterLoading.value = false;
    await loadCurrentChapter();
    preloadPreviousChapter();
    preloadNextChapter();
  }

  Future<void> syncBookshelf() async {
    GetIt.instance.get<BookshelfViewModel>().initSignals();
  }

  // --- Private helpers ---

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
}
