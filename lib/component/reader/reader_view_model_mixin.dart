import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_controller.dart';
import 'package:source_parser/component/reader/reader_turning_mode.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/color_extension.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/splitter.dart';
import 'package:source_parser/util/volume_util.dart';
import 'package:source_parser/view_model/app_theme_view_model.dart';

mixin ReaderViewModelMixin {
  // --- Shared Signals ---
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
  final battery = signal(100);
  final size = signal(Size.zero);
  final error = signal('');
  final eInkMode = signal(false);
  final pageTurnMode = signal(PageTurnMode.slide);
  final previousChapterLoading = signal(false);
  final nextChapterLoading = signal(false);

  late final isDarkMode = computed(() {
    var sourceParserViewModel = GetIt.instance.get<SourceParserViewModel>();
    return sourceParserViewModel.isDarkMode.value;
  });

  late final pageCount = computed(() {
    return computePageCount();
  });

  late final currentChapterOffset = computed(() {
    return computeCurrentChapterOffset();
  });

  late final subscription = VolumeUtil.stream.listen((event) {
    if (event == 'volume_up') {
      previousPage();
    } else if (event == 'volume_down') {
      nextPage();
    }
  });

  bool isRotating = false;

  // --- Abstract members that subclasses must implement ---
  String get bookName;
  int get totalChapterCount;
  PageTurnController get pageTurnController;

  String getChapterName(int index);
  Future<String> fetchContent(int chapterIndex, {bool reacquire = false});
  void onPageIndexUpdated(int chapterIndex, int pageIndex);

  // --- Shared Computed helpers ---
  int computePageCount() {
    var prev = chapterIndex.value > 0 ? 1 : 0;
    var hasChapters = totalChapterCount > 0;
    var next = hasChapters && chapterIndex.value < totalChapterCount - 1 ? 1 : 0;
    return prev + currentChapterPages.value.length + next;
  }

  int computeCurrentChapterOffset() {
    return chapterIndex.value > 0 ? 1 : 0;
  }

  // --- Shared Methods ---

  void handlePageChanged(int flatIndex) {
    if (isRotating) return;
    var offset = currentChapterOffset.value;
    var currLen = currentChapterPages.value.length;

    if (flatIndex < offset) {
      if (previousChapterPages.value.isNotEmpty) {
        rotateToPreviousChapter();
      }
    } else if (flatIndex >= offset + currLen) {
      if (nextChapterPages.value.isNotEmpty) {
        rotateToNextChapter();
      }
    } else {
      updatePageIndex(flatIndex - offset);
    }
  }

  void rotateToNextChapter({int? targetPage}) {
    isRotating = true;
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
    preloadNextChapter();
    if (currentChapterPages.value.isEmpty) {
      loadCurrentChapter();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageTurnController.jumpToPage(currentChapterOffset.value + page);
        isRotating = false;
      });
    }
  }

  void rotateToPreviousChapter({int? targetPage}) {
    isRotating = true;
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
    preloadPreviousChapter();
    if (currentChapterPages.value.isEmpty) {
      loadCurrentChapter();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageTurnController.jumpToPage(currentChapterOffset.value + page);
        isRotating = false;
      });
    }
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
          header: getHeaderForChapter(prevChapterIdx, lastIndex),
          footer: getFooterForChapter(
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
          header: getHeaderForChapter(nextChapterIdx, 0),
          footer: getFooterForChapter(
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

  String getHeaderText(int index) {
    if (index == 0) return bookName;
    if (chapterIndex.value < totalChapterCount) {
      return getChapterName(chapterIndex.value);
    }
    return bookName;
  }

  String getFooterText(int index) {
    var totalPagesInChapter = currentChapterPages.value.length;
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

  String getHeaderForChapter(int chapterIdx, int localIndex) {
    if (chapterIdx < 0 || chapterIdx >= totalChapterCount) return '';
    if (localIndex == 0) return bookName;
    return getChapterName(chapterIdx);
  }

  String getFooterForChapter(
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

  void turnPage(TapUpDetails details) {
    final screenSize =
        GetIt.instance.get<SourceParserViewModel>().screenSize.value;
    final horizontalTapArea = details.globalPosition.dx / screenSize.width;
    final verticalTapArea = details.globalPosition.dy / screenSize.height;
    debugPrint('[turnPage] globalPos=${details.globalPosition}, screenSize=$screenSize, hArea=$horizontalTapArea, vArea=$verticalTapArea');
    if (horizontalTapArea < 1 / 3) {
      debugPrint('[turnPage] → previousPage');
      previousPage();
    } else if (horizontalTapArea > 2 / 3) {
      debugPrint('[turnPage] → nextPage');
      nextPage();
    } else if (horizontalTapArea >= 1 / 3 && horizontalTapArea <= 2 / 3) {
      if (verticalTapArea > 2 / 3) {
        debugPrint('[turnPage] → nextPage (bottom)');
        nextPage();
      } else if (verticalTapArea < 1 / 3) {
        debugPrint('[turnPage] → previousPage (top)');
        previousPage();
      } else {
        debugPrint('[turnPage] → showUiOverlays (center)');
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
    if (nextChapterPages.value.isNotEmpty) {
      rotateToNextChapter();
    } else {
      var nextPlaceholderIndex =
          currentChapterOffset.value + currentChapterPages.value.length;
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
    if (previousChapterPages.value.isNotEmpty) {
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

  void hideUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    showOverlay.value = false;
  }

  void showUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    showOverlay.value = true;
  }

  void toggleDarkMode() {
    GetIt.instance.get<SourceParserViewModel>().toggleDarkMode();
    theme.value = initTheme();
  }

  Theme assembleTheme(Theme theme) {
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

  Theme initTheme() {
    var appThemeViewModel = GetIt.instance.get<AppThemeViewModel>();
    var savedTheme = appThemeViewModel.currentTheme.value;
    return assembleTheme(savedTheme);
  }

  Size initSize(Theme theme) {
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

  Future<void> getBattery() async {
    try {
      battery.value = await Battery().batteryLevel;
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> forceRefresh() async {
    isRotating = true;
    currentChapterPages.value = [];
    updatePageIndex(0);
    await loadCurrentChapter(reacquire: true);
    preloadPreviousChapter();
    preloadNextChapter();
  }

  Future<void> loadCurrentChapter({bool reacquire = false}) async {
    currentChapterContent.value = await fetchContent(
      chapterIndex.value,
      reacquire: reacquire,
    );
    var splitter = Splitter(size: size.value, theme: theme.value);
    isRotating = true;
    currentChapterPages.value = splitter.split(currentChapterContent.value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageTurnController.jumpToPage(
        currentChapterOffset.value + pageIndex.value,
      );
      isRotating = false;
    });
  }

  Future<void> preloadNextChapter() async {
    if (chapterIndex.value + 1 >= totalChapterCount) {
      nextChapterContent.value = '';
      nextChapterPages.value = [];
      nextChapterLoading.value = false;
      return;
    }
    nextChapterLoading.value = true;
    nextChapterContent.value = await fetchContent(chapterIndex.value + 1);
    var splitter = Splitter(size: size.value, theme: theme.value);
    nextChapterPages.value = splitter.split(nextChapterContent.value);
    nextChapterLoading.value = false;
    // Auto-rotate if user is already on the next placeholder
    if (!isRotating) {
      var flatIndex = pageTurnController.currentIndex;
      var offset = currentChapterOffset.value;
      var currLen = currentChapterPages.value.length;
      if (flatIndex >= offset + currLen) {
        rotateToNextChapter();
      }
    }
  }

  Future<void> preloadPreviousChapter() async {
    if (chapterIndex.value - 1 < 0) {
      previousChapterContent.value = '';
      previousChapterPages.value = [];
      previousChapterLoading.value = false;
      return;
    }
    previousChapterLoading.value = true;
    previousChapterContent.value =
        await fetchContent(chapterIndex.value - 1);
    var splitter = Splitter(size: size.value, theme: theme.value);
    previousChapterPages.value = splitter.split(previousChapterContent.value);
    previousChapterLoading.value = false;
    // Auto-rotate if user is already on the previous placeholder
    if (!isRotating) {
      var flatIndex = pageTurnController.currentIndex;
      if (flatIndex < currentChapterOffset.value) {
        rotateToPreviousChapter();
      }
    }
  }

  void updatePageIndex(int index) {
    pageIndex.value = index;
    onPageIndexUpdated(chapterIndex.value, index);
  }
}
