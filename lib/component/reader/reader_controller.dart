import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/component/reader/layout/chapter_layout_result.dart';
import 'package:source_parser/component/reader/layout/reader_layout_cache_key.dart';
import 'package:source_parser/component/reader/layout/reader_layout_config.dart';
import 'package:source_parser/component/reader/layout/reader_render_config.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_controller.dart';
import 'package:source_parser/component/reader/reader_delegate.dart';
import 'package:source_parser/component/reader/reader_turning_mode.dart';
import 'package:source_parser/component/reader/reader_viewport.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/color_extension.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/shared_preference_util.dart';
import 'package:source_parser/util/splitter.dart';
import 'package:source_parser/util/volume_util.dart';
import 'package:source_parser/view_model/app_theme_view_model.dart';

/// 统一的阅读器控制器，管理阅读核心状态和逻辑。
///
/// 不直接依赖本地数据库或云 API，通过 [ReaderDelegate] 获取数据。
class ReaderController {
  final ReaderDelegate delegate;

  /// 进度保存防抖时长，本地默认 1 秒，云端可设为 3 秒。
  final Duration progressDebounceDuration;

  ReaderController({
    required this.delegate,
    required int initialPageIndex,
    this.progressDebounceDuration = const Duration(seconds: 1),
  }) {
    pageTurnController = PageTurnController(initialIndex: initialPageIndex);
  }

  // --- Signals ---
  final previousChapterContent = signal('');
  final previousChapterLayout = signal(ChapterLayoutResult.empty());
  final currentChapterContent = signal('');
  final currentChapterLayout = signal(ChapterLayoutResult.empty());
  final nextChapterContent = signal('');
  final nextChapterLayout = signal(ChapterLayoutResult.empty());
  final chapterIndex = signal(0);
  final pageIndex = signal(0);
  final theme = signal(Theme());
  final showOverlay = signal(false);
  final isSelectionMode = signal(false);
  final battery = signal(100);
  final size = signal(Size.zero);
  final error = signal('');
  final eInkMode = signal(false);
  final pageTurnMode = signal(PageTurnMode.slide);
  final previousChapterLoading = signal(false);
  final nextChapterLoading = signal(false);
  final layoutConfig = signal(const ReaderLayoutConfig());

  late final isDarkMode = computed(() {
    var sourceParserViewModel = GetIt.instance.get<SourceParserViewModel>();
    return sourceParserViewModel.isDarkMode.value;
  });

  late final pageCount = computed(() {
    return _computePageCount();
  });

  late final currentChapterOffset = computed(() {
    return chapterIndex.value > 0 ? 1 : 0;
  });

  late final _volumeSubscription = VolumeUtil.stream.listen((event) {
    if (event == 'volume_up') {
      previousPage();
    } else if (event == 'volume_down') {
      nextPage();
    }
  });

  late final PageTurnController pageTurnController;

  bool isRotating = false;
  Size _pageSize = Size.zero;
  final _layoutCache = <ReaderLayoutCacheKey, ChapterLayoutResult>{};
  static const _maxLayoutCacheEntries = 12;
  Timer? _progressDebounce;

  String _bookName = '';
  String get bookName => _bookName;

  int get totalChapterCount => delegate.totalChapterCount;

  ReaderRenderConfig get renderConfig {
    return ReaderRenderConfig(theme: theme.value, layout: layoutConfig.value);
  }

  // --- 统一初始化编排 ---

  Future<void> init() async {
    await GetIt.instance.get<AppThemeViewModel>().initSignals();
    theme.value = _initTheme();
    size.value = _initSize(theme.value);
    var initialState = await delegate.loadInitialState();
    _bookName = initialState.bookName;
    chapterIndex.value = initialState.initialChapterIndex;
    pageIndex.value = initialState.initialPageIndex;
    eInkMode.value = await SharedPreferenceUtil.getEInkMode();
    var modeStr = await SharedPreferenceUtil.getPageTurnMode();
    pageTurnMode.value = PageTurnMode.fromString(modeStr);
    pageTurnController.onPageChanged = handlePageChanged;
    await getBattery();
    if (initialState.totalChapterCount == 0) {
      error.value = StringConfig.chapterNotFound;
      return;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    await loadCurrentChapter();
    preloadPreviousChapter();
    preloadNextChapter();
  }

  void dispose() {
    _progressDebounce?.cancel();
    _volumeSubscription.cancel();
  }

  // --- 翻页与章节轮转 ---

  void handlePageChanged(int flatIndex) {
    if (isRotating) return;
    var offset = currentChapterOffset.value;
    var currLen = currentChapterLayout.value.pageCount;

    if (flatIndex < offset) {
      if (previousChapterLayout.value.isNotEmpty) {
        rotateToPreviousChapter();
      }
    } else if (flatIndex >= offset + currLen) {
      if (nextChapterLayout.value.isNotEmpty) {
        rotateToNextChapter();
      }
    } else {
      _updatePageIndex(flatIndex - offset);
    }
  }

  void rotateToNextChapter({int? targetPage}) {
    isRotating = true;
    chapterIndex.value++;
    previousChapterContent.value = currentChapterContent.value;
    previousChapterLayout.value = currentChapterLayout.value;
    previousChapterLoading.value = false;
    currentChapterContent.value = nextChapterContent.value;
    currentChapterLayout.value = nextChapterLayout.value;
    nextChapterContent.value = '';
    nextChapterLayout.value = ChapterLayoutResult.empty();
    nextChapterLoading.value = false;
    var page = targetPage ?? 0;
    _updatePageIndex(page);
    if (currentChapterLayout.value.isEmpty) {
      loadCurrentChapter();
    } else {
      pageTurnController.updatePageCount(pageCount.value);
      pageTurnController.confirmJump(currentChapterOffset.value + page);
      isRotating = false;
    }
    preloadNextChapter();
  }

  void rotateToPreviousChapter({int? targetPage}) {
    isRotating = true;
    chapterIndex.value--;
    nextChapterContent.value = currentChapterContent.value;
    nextChapterLayout.value = currentChapterLayout.value;
    nextChapterLoading.value = false;
    currentChapterContent.value = previousChapterContent.value;
    currentChapterLayout.value = previousChapterLayout.value;
    previousChapterContent.value = '';
    previousChapterLayout.value = ChapterLayoutResult.empty();
    previousChapterLoading.value = false;
    var page = targetPage ??
        (currentChapterLayout.value.isNotEmpty
            ? currentChapterLayout.value.pageCount - 1
            : 0);
    _updatePageIndex(page);
    if (currentChapterLayout.value.isEmpty) {
      loadCurrentChapter();
    } else {
      pageTurnController.updatePageCount(pageCount.value);
      pageTurnController.confirmJump(currentChapterOffset.value + page);
      isRotating = false;
    }
    preloadPreviousChapter();
  }

  // --- 页面数据 ---

  ({
    String content,
    String header,
    String footer,
    bool isFirstPage,
    bool isLoading,
  }) getPageData(int flatIndex) {
    var offset = currentChapterOffset.value;
    var currLen = currentChapterLayout.value.pageCount;

    if (flatIndex < offset) {
      if (previousChapterLayout.value.isNotEmpty) {
        var lastIndex = previousChapterLayout.value.pageCount - 1;
        var prevChapterIdx = chapterIndex.value - 1;
        return (
          content: previousChapterLayout.value.pageTextAt(lastIndex),
          header: _getHeaderForChapter(prevChapterIdx, lastIndex),
          footer: _getFooterForChapter(
            prevChapterIdx,
            lastIndex,
            previousChapterLayout.value.pageCount,
          ),
          isFirstPage:
              previousChapterLayout.value.pageRangeAt(lastIndex).isFirstPage,
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

    if (flatIndex >= offset + currLen) {
      if (nextChapterLayout.value.isNotEmpty) {
        var nextChapterIdx = chapterIndex.value + 1;
        return (
          content: nextChapterLayout.value.pageTextAt(0),
          header: _getHeaderForChapter(nextChapterIdx, 0),
          footer: _getFooterForChapter(
            nextChapterIdx,
            0,
            nextChapterLayout.value.pageCount,
          ),
          isFirstPage: nextChapterLayout.value.pageRangeAt(0).isFirstPage,
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

    var localIndex = flatIndex - offset;
    final pageRange = currentChapterLayout.value.pageRangeAt(localIndex);
    return (
      content: currentChapterLayout.value.pageTextAt(localIndex),
      header: _getHeaderText(localIndex),
      footer: _getFooterText(localIndex),
      isFirstPage: pageRange.isFirstPage,
      isLoading: false,
    );
  }

  // --- 用户交互 ---

  void turnPage(TapUpDetails details) {
    if (isSelectionMode.value) return;
    final screenSize =
        GetIt.instance.get<SourceParserViewModel>().screenSize.value;
    final horizontalTapArea = details.globalPosition.dx / screenSize.width;
    final verticalTapArea = details.globalPosition.dy / screenSize.height;
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

  void nextChapter() {
    if (totalChapterCount == 0) return;
    if (chapterIndex.value + 1 >= totalChapterCount) {
      DialogUtil.snackBar(StringConfig.noMoreChapter);
      return;
    }
    if (nextChapterLayout.value.isNotEmpty) {
      rotateToNextChapter();
    } else {
      var nextPlaceholderIndex =
          currentChapterOffset.value + currentChapterLayout.value.pageCount;
      pageTurnController.jumpToPage(nextPlaceholderIndex);
    }
  }

  Future<void> nextPage() async {
    if (totalChapterCount == 0) return;
    await getBattery();
    if (pageTurnController.currentIndex + 1 < pageCount.value) {
      pageTurnController.animateToNext();
    } else {
      DialogUtil.snackBar(StringConfig.noMoreChapter);
    }
  }

  void previousChapter() {
    if (totalChapterCount == 0) return;
    if (chapterIndex.value - 1 < 0) {
      DialogUtil.snackBar(StringConfig.noChapterBefore);
      return;
    }
    if (previousChapterLayout.value.isNotEmpty) {
      rotateToPreviousChapter(targetPage: 0);
    } else {
      pageTurnController.jumpToPage(0);
    }
  }

  Future<void> previousPage() async {
    if (totalChapterCount == 0) return;
    await getBattery();
    if (pageTurnController.currentIndex > 0) {
      pageTurnController.animateToPrevious();
    } else {
      DialogUtil.snackBar(StringConfig.noChapterBefore);
    }
  }

  // --- UI 控制 ---

  void hideUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    showOverlay.value = false;
  }

  void showUiOverlays() {
    exitSelectionMode();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    showOverlay.value = true;
  }

  void toggleDarkMode() {
    GetIt.instance.get<SourceParserViewModel>().toggleDarkMode();
    theme.value = _initTheme();
    _recomputeViewport();
  }

  void enterSelectionMode() {
    if (isSelectionMode.value) return;
    isSelectionMode.value = true;
    showOverlay.value = false;
  }

  void exitSelectionMode() {
    if (!isSelectionMode.value) return;
    isSelectionMode.value = false;
  }

  // --- 章节加载 ---

  Future<void> loadCurrentChapter({bool reacquire = false}) async {
    currentChapterContent.value = await delegate.fetchContent(
      chapterIndex.value,
      reacquire: reacquire,
    );
    isRotating = true;
    currentChapterLayout.value = _paginateContent(
      chapterIndex.value,
      currentChapterContent.value,
    );
    final targetPage = currentChapterLayout.value.pageCount <= 0
        ? 0
        : pageIndex.value.clamp(0, currentChapterLayout.value.pageCount - 1);
    if (targetPage != pageIndex.value) {
      _updatePageIndex(targetPage);
    }
    pageTurnController.updatePageCount(pageCount.value);
    pageTurnController.confirmJump(
      currentChapterOffset.value + pageIndex.value,
    );
    isRotating = false;
  }

  Future<void> preloadNextChapter() async {
    if (chapterIndex.value + 1 >= totalChapterCount) {
      nextChapterContent.value = '';
      nextChapterLayout.value = ChapterLayoutResult.empty();
      nextChapterLoading.value = false;
      return;
    }
    nextChapterLoading.value = true;
    nextChapterContent.value =
        await delegate.fetchContent(chapterIndex.value + 1);
    nextChapterLayout.value = _paginateContent(
      chapterIndex.value + 1,
      nextChapterContent.value,
    );
    nextChapterLoading.value = false;
    if (!isRotating) {
      var flatIndex = pageTurnController.currentIndex;
      var offset = currentChapterOffset.value;
      var currLen = currentChapterLayout.value.pageCount;
      if (flatIndex >= offset + currLen) {
        rotateToNextChapter();
      }
    }
  }

  Future<void> preloadPreviousChapter() async {
    if (chapterIndex.value - 1 < 0) {
      previousChapterContent.value = '';
      previousChapterLayout.value = ChapterLayoutResult.empty();
      previousChapterLoading.value = false;
      return;
    }
    previousChapterLoading.value = true;
    previousChapterContent.value =
        await delegate.fetchContent(chapterIndex.value - 1);
    previousChapterLayout.value = _paginateContent(
      chapterIndex.value - 1,
      previousChapterContent.value,
    );
    previousChapterLoading.value = false;
    if (!isRotating) {
      var flatIndex = pageTurnController.currentIndex;
      if (flatIndex < currentChapterOffset.value) {
        rotateToPreviousChapter();
      }
    }
  }

  Future<void> forceRefresh() async {
    isRotating = true;
    currentChapterLayout.value = ChapterLayoutResult.empty();
    _updatePageIndex(0);
    await loadCurrentChapter(reacquire: true);
    preloadPreviousChapter();
    preloadNextChapter();
  }

  // --- 缓冲区与跳转 ---

  void clearLayoutCache() {
    _layoutCache.clear();
  }

  void resetChapterBuffer() {
    currentChapterLayout.value = ChapterLayoutResult.empty();
    previousChapterContent.value = '';
    previousChapterLayout.value = ChapterLayoutResult.empty();
    previousChapterLoading.value = false;
    nextChapterContent.value = '';
    nextChapterLayout.value = ChapterLayoutResult.empty();
    nextChapterLoading.value = false;
  }

  Future<void> jumpToChapter(int index, {int page = 0}) async {
    isRotating = true;
    chapterIndex.value = index;
    _updatePageIndex(page);
    resetChapterBuffer();
    await loadCurrentChapter();
    preloadPreviousChapter();
    preloadNextChapter();
  }

  // --- 视口与主题 ---

  void updateViewportSize(Size pageSize) {
    if (_sameSize(_pageSize, pageSize)) return;
    _pageSize = pageSize;
    _recomputeViewport();
  }

  void updateLayoutConfig(ReaderLayoutConfig value) {
    if (layoutConfig.value == value) return;
    layoutConfig.value = value;
    _recomputeViewport();
  }

  Future<void> getBattery() async {
    try {
      battery.value = await Battery().batteryLevel;
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  // --- Private helpers ---

  void _updatePageIndex(int index) {
    pageIndex.value = index;
    _debounceSaveProgress();
  }

  void _debounceSaveProgress() {
    _progressDebounce?.cancel();
    _progressDebounce = Timer(progressDebounceDuration, () {
      delegate.saveProgress(
        chapterIndex: chapterIndex.value,
        pageIndex: pageIndex.value,
      );
    });
  }

  int _computePageCount() {
    var prev = chapterIndex.value > 0 ? 1 : 0;
    var hasChapters = totalChapterCount > 0;
    var next =
        hasChapters && chapterIndex.value < totalChapterCount - 1 ? 1 : 0;
    return prev + currentChapterLayout.value.pageCount + next;
  }

  String _getHeaderText(int index) {
    if (index == 0) return _bookName;
    if (chapterIndex.value < totalChapterCount) {
      return delegate.getChapterName(chapterIndex.value);
    }
    return _bookName;
  }

  String _getFooterText(int index) {
    var totalPagesInChapter = currentChapterLayout.value.pageCount;
    var totalChapters = totalChapterCount;
    if (totalChapters == 0 || totalPagesInChapter == 0) {
      return '${index + 1}/$totalPagesInChapter 0.00%';
    }
    var pageProgress = '${index + 1}/$totalPagesInChapter';
    var progressInChapter = (index + 1) / totalPagesInChapter;
    var progress = (chapterIndex.value + progressInChapter) / totalChapters;
    var percent = (progress.clamp(0.0, 1.0) * 100).toStringAsFixed(2);
    return '$pageProgress $percent%';
  }

  String _getHeaderForChapter(int chapterIdx, int localIndex) {
    if (chapterIdx < 0 || chapterIdx >= totalChapterCount) return '';
    if (localIndex == 0) return _bookName;
    return delegate.getChapterName(chapterIdx);
  }

  String _getFooterForChapter(
    int chapterIdx,
    int localIndex,
    int totalPagesInChapter,
  ) {
    var totalChapters = totalChapterCount;
    if (totalChapters == 0 || totalPagesInChapter == 0) {
      return '${localIndex + 1}/$totalPagesInChapter 0.00%';
    }
    var pageProgress = '${localIndex + 1}/$totalPagesInChapter';
    var progressInChapter = (localIndex + 1) / totalPagesInChapter;
    var progress = (chapterIdx + progressInChapter) / totalChapters;
    var percent = (progress.clamp(0.0, 1.0) * 100).toStringAsFixed(2);
    return '$pageProgress $percent%';
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

  Theme _initTheme() {
    var appThemeViewModel = GetIt.instance.get<AppThemeViewModel>();
    var savedTheme = appThemeViewModel.currentTheme.value;
    return _assembleTheme(savedTheme);
  }

  Size _initSize(Theme theme) {
    var screenSize =
        GetIt.instance.get<SourceParserViewModel>().screenSize.value;
    _pageSize = screenSize;
    return ReaderViewportCalculator.calculate(
      pageSize: screenSize,
      renderConfig: renderConfig,
    ).contentSize;
  }

  ChapterLayoutResult _paginateContent(int chapterIdx, String content) {
    if (content.isEmpty) return ChapterLayoutResult.empty();
    final cacheKey = ReaderLayoutCacheKey.fromContent(
      chapterIndex: chapterIdx,
      content: content,
      contentSize: size.value,
      renderConfig: renderConfig,
    );
    final cached = _layoutCache.remove(cacheKey);
    if (cached != null) {
      _layoutCache[cacheKey] = cached;
      return cached;
    }

    final result = Splitter(
      size: size.value,
      renderConfig: renderConfig,
    ).paginate(content);
    _layoutCache[cacheKey] = result;
    if (_layoutCache.length > _maxLayoutCacheEntries) {
      _layoutCache.remove(_layoutCache.keys.first);
    }
    return result;
  }

  void _recomputeViewport() {
    if (_pageSize == Size.zero) return;
    final newContentSize = ReaderViewportCalculator.calculate(
      pageSize: _pageSize,
      renderConfig: renderConfig,
    ).contentSize;
    if (_sameSize(size.value, newContentSize)) return;
    final oldPageCount = currentChapterLayout.value.pageCount;
    final oldPageIndex = pageIndex.value;
    size.value = newContentSize;
    if (currentChapterContent.value.isNotEmpty) {
      currentChapterLayout.value = _paginateContent(
        chapterIndex.value,
        currentChapterContent.value,
      );
      pageIndex.value = _remapPageIndex(
        oldIndex: oldPageIndex,
        oldCount: oldPageCount,
        newCount: currentChapterLayout.value.pageCount,
      );
      _debounceSaveProgress();
    }
    if (nextChapterContent.value.isNotEmpty) {
      nextChapterLayout.value = _paginateContent(
        chapterIndex.value + 1,
        nextChapterContent.value,
      );
    }
    if (previousChapterContent.value.isNotEmpty) {
      previousChapterLayout.value = _paginateContent(
        chapterIndex.value - 1,
        previousChapterContent.value,
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isRotating) {
        pageTurnController
            .jumpToPage(currentChapterOffset.value + pageIndex.value);
      }
    });
  }

  int _remapPageIndex({
    required int oldIndex,
    required int oldCount,
    required int newCount,
  }) {
    if (newCount <= 0) return 0;
    if (oldCount <= 1) return oldIndex.clamp(0, newCount - 1);
    final progress = oldIndex / (oldCount - 1);
    return (progress * (newCount - 1)).round().clamp(0, newCount - 1);
  }

  bool _sameSize(Size a, Size b) {
    return (a.width - b.width).abs() < 0.5 &&
        (a.height - b.height).abs() < 0.5;
  }
}
