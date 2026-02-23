import 'dart:async';

import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_controller.dart';
import 'package:source_parser/component/reader/reader_turning_mode.dart';
import 'package:source_parser/component/reader/reader_view_model_interface.dart';
import 'package:source_parser/component/reader/reader_view_model_mixin.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/database/cloud_available_source_service.dart';
import 'package:source_parser/database/cloud_book_service.dart';
import 'package:source_parser/database/cloud_chapter_service.dart';
import 'package:source_parser/model/cloud_available_source_entity.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/model/cloud_chapter_entity.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/shared_preference_util.dart';
import 'package:source_parser/view_model/app_theme_view_model.dart';

class CloudReaderReaderViewModel
    with ReaderViewModelMixin
    implements ReaderViewModelInterface {
  final CloudBookEntity book;
  final chapters = signal<List<CloudChapterEntity>>([]);
  final availableSources = signal<List<CloudAvailableSourceEntity>>([]);

  @override
  late final pageTurnController = PageTurnController(
    initialIndex: book.durChapterPos,
  );

  Timer? _progressDebounce;

  CloudReaderReaderViewModel({required this.book});

  // --- ReaderViewModelMixin abstract members ---

  @override
  String get bookName => book.name;

  @override
  int get totalChapterCount => chapters.value.length;

  @override
  String getChapterName(int index) => chapters.value[index].title;

  @override
  Future<String> fetchContent(int chapterIndex, {bool reacquire = false}) {
    return _getContent(chapterIndex, reacquire: reacquire);
  }

  @override
  void onPageIndexUpdated(int chapterIdx, int pageIdx) {
    var title = '';
    if (chapterIdx < chapters.value.length) {
      title = chapters.value[chapterIdx].title;
    }
    CloudBookService().updateProgress(
      book.bookUrl,
      chapterIdx,
      title,
      pageIdx,
    );
    _debounceSyncProgress();
  }

  // --- Cloud-only logic ---

  Future<void> initSignals() async {
    await GetIt.instance.get<AppThemeViewModel>().initSignals();
    theme.value = initTheme();
    size.value = initSize(theme.value);
    chapterIndex.value = book.durChapterIndex;
    pageIndex.value = book.durChapterPos;
    await _loadChapterList();
    await _loadAvailableSources();
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

  Future<void> syncProgress() async {
    var title = '';
    if (chapterIndex.value < chapters.value.length) {
      title = chapters.value[chapterIndex.value].title;
    }
    await CloudBookService().updateProgress(
      book.bookUrl,
      chapterIndex.value,
      title,
      pageIndex.value,
    );
    try {
      await CloudReaderApiClient().saveBookProgress(
        book.bookUrl,
        chapterIndex.value,
      );
    } catch (e) {
      logger.e('同步进度失败: $e');
    }
  }

  Future<void> navigateCataloguePage(BuildContext context) async {
    var index = await CloudReaderCatalogueRoute(
      bookUrl: book.bookUrl,
      currentIndex: chapterIndex.value,
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

  Future<void> navigateSourcePage(BuildContext context) async {
    var newBookUrl = await CloudReaderSourceRoute(
      bookUrl: book.bookUrl,
      currentOrigin: book.origin,
    ).push<String>(context);
    if (newBookUrl == null) return;
    DialogUtil.loading();
    isRotating = true;
    currentChapterContent.value = '';
    currentChapterPages.value = [];
    previousChapterContent.value = '';
    previousChapterPages.value = [];
    previousChapterLoading.value = false;
    nextChapterContent.value = '';
    nextChapterPages.value = [];
    nextChapterLoading.value = false;
    error.value = '';
    var oldBookUrl = book.bookUrl;
    book.bookUrl = newBookUrl;
    await CloudChapterService().deleteChapters(oldBookUrl);
    await CloudAvailableSourceService().deleteSources(oldBookUrl);
    await _loadChapterList(forceRemote: true);
    chapterIndex.value = 0;
    updatePageIndex(0);
    await loadCurrentChapter();
    preloadPreviousChapter();
    preloadNextChapter();
    await _loadAvailableSources();
    DialogUtil.dismiss();
  }

  // --- Private helpers ---

  void _debounceSyncProgress() {
    _progressDebounce?.cancel();
    _progressDebounce = Timer(const Duration(seconds: 3), () {
      syncProgress();
    });
  }

  Future<void> _loadChapterList({bool forceRemote = false}) async {
    try {
      if (!forceRemote) {
        var local = await CloudChapterService().getChapters(book.bookUrl);
        if (local.isNotEmpty) {
          chapters.value = local;
          return;
        }
      }
      var remote =
          await CloudReaderApiClient().getChapterList(book.bookUrl);
      chapters.value = remote;
      await CloudChapterService().replaceChapters(book.bookUrl, remote);
    } catch (e) {
      error.value = '${StringConfig.loadingFailed}: $e';
    }
  }

  Future<void> _loadAvailableSources() async {
    try {
      availableSources.value =
          await CloudAvailableSourceService().getSources(book.bookUrl);
    } catch (_) {}
  }

  Future<String> _getContent(int chapterIndex, {bool reacquire = false}) async {
    var chapterTitle =
        chapterIndex < chapters.value.length ? chapters.value[chapterIndex].title : '';
    try {
      var network = CachedNetwork(prefix: book.name);
      var url = chapters.value[chapterIndex].url;
      if (!reacquire) {
        var cached = await network.read(url);
        if (cached != null) {
          return '$chapterTitle\n\n$cached';
        }
      }
      var content = await CloudReaderApiClient().getBookContent(
        book.bookUrl,
        chapterIndex,
      );
      if (content.isEmpty) {
        return '$chapterTitle\n\n${StringConfig.emptyContent}';
      }
      await network.cache(url, content);
      return '$chapterTitle\n\n$content';
    } catch (e) {
      return '$chapterTitle\n\n${StringConfig.loadingFailed}: $e';
    }
  }
}
