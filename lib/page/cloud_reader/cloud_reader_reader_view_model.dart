import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/model/cloud_chapter_entity.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/util/color_extension.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/shared_preference_util.dart';
import 'package:source_parser/util/splitter.dart';
import 'package:source_parser/util/volume_util.dart';

class CloudReaderReaderViewModel {
  final CloudBookEntity book;
  final chapters = signal<List<CloudChapterEntity>>([]);
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
  final turningMode = signal(3);

  late final isDarkMode = computed(() {
    var sourceParserViewModel = GetIt.instance.get<SourceParserViewModel>();
    return sourceParserViewModel.isDarkMode.value;
  });

  late final controller = PageController();
  late final subscription = VolumeUtil.stream.listen((event) {
    if (event == 'volume_up') {
      previousPage();
    } else if (event == 'volume_down') {
      nextPage();
    }
  });

  Timer? _progressDebounce;

  CloudReaderReaderViewModel({required this.book});

  Future<void> initSignals() async {
    theme.value = _initTheme();
    size.value = _initSize(theme.value);
    chapterIndex.value = book.durChapterIndex;
    pageIndex.value = 0;
    eInkMode.value = await SharedPreferenceUtil.getEInkMode();
    turningMode.value = await SharedPreferenceUtil.getTurningMode();
    await _getBattery();
    await _loadChapterList();
    if (chapters.value.isEmpty) {
      error.value = '没有找到章节';
      return;
    }
    _loadCurrentChapter();
    _preloadPreviousChapter();
    _preloadNextChapter();
  }

  Future<void> _loadChapterList() async {
    try {
      chapters.value =
          await CloudReaderApiClient().getChapterList(book.bookUrl);
    } catch (e) {
      error.value = '加载章节列表失败: $e';
    }
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
      return chapters.value[chapterIndex.value].title;
    }
    return book.name;
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
    theme.value = _assembleTheme(theme.value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;
      controller.jumpToPage(pageIndex.value);
    });
  }

  void turnPage(TapUpDetails details) {
    final screenSize =
        GetIt.instance.get<SourceParserViewModel>().screenSize.value;
    final horizontalTapArea = details.globalPosition.dx / screenSize.width;
    final verticalTapArea = details.globalPosition.dy / screenSize.height;
    if (horizontalTapArea < 1 / 3) {
      if (eInkMode.value || turningMode.value & 2 == 0) return;
      previousPage();
    } else if (horizontalTapArea > 2 / 3) {
      if (eInkMode.value || turningMode.value & 2 == 0) return;
      nextPage();
    } else if (horizontalTapArea >= 1 / 3 && horizontalTapArea <= 2 / 3) {
      if (verticalTapArea > 2 / 3) {
        if (eInkMode.value || turningMode.value & 2 == 0) return;
        nextPage();
      } else if (verticalTapArea < 1 / 3) {
        if (eInkMode.value || turningMode.value & 2 == 0) return;
        previousPage();
      } else {
        showUiOverlays();
      }
    }
  }

  void nextChapter() {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value + 1 >= chapters.value.length) {
      DialogUtil.snackBar('后续没有任何章节');
      return;
    }
    chapterIndex.value++;
    updatePageIndex(0);
    previousChapterContent.value = currentChapterContent.value;
    previousChapterPages.value = currentChapterPages.value;
    currentChapterContent.value = nextChapterContent.value;
    currentChapterPages.value = nextChapterPages.value;
    _preloadNextChapter();
    if (!controller.hasClients) return;
    controller.jumpToPage(pageIndex.value);
  }

  Future<void> nextPage() async {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value == chapters.value.length - 1 &&
        pageIndex.value + 1 >= currentChapterPages.value.length) {
      DialogUtil.snackBar('后续没有任何章节');
      return;
    }
    if (pageIndex.value + 1 >= currentChapterPages.value.length) {
      chapterIndex.value++;
      updatePageIndex(0);
      previousChapterContent.value = currentChapterContent.value;
      previousChapterPages.value = currentChapterPages.value;
      currentChapterContent.value = nextChapterContent.value;
      currentChapterPages.value = nextChapterPages.value;
      _preloadNextChapter();
      if (!controller.hasClients) return;
      controller.jumpToPage(pageIndex.value);
      return;
    }
    await _getBattery();
    if (!controller.hasClients) return;
    controller.nextPage(
      duration: Durations.medium1,
      curve: Curves.easeInOut,
    );
  }

  void previousChapter() {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value - 1 < 0) {
      DialogUtil.snackBar('当前已是第一章');
      return;
    }
    chapterIndex.value--;
    updatePageIndex(0);
    nextChapterContent.value = currentChapterContent.value;
    nextChapterPages.value = currentChapterPages.value;
    currentChapterContent.value = previousChapterContent.value;
    currentChapterPages.value = previousChapterPages.value;
    _preloadPreviousChapter();
    if (!controller.hasClients) return;
    controller.jumpToPage(pageIndex.value);
  }

  Future<void> previousPage() async {
    if (chapters.value.isEmpty) return;
    if (chapterIndex.value == 0 && pageIndex.value == 0) {
      DialogUtil.snackBar('当前已是第一章');
      return;
    }
    if (pageIndex.value - 1 < 0) {
      chapterIndex.value--;
      updatePageIndex(previousChapterPages.value.length - 1);
      nextChapterContent.value = currentChapterContent.value;
      nextChapterPages.value = currentChapterPages.value;
      currentChapterContent.value = previousChapterContent.value;
      currentChapterPages.value = previousChapterPages.value;
      _preloadPreviousChapter();
      if (!controller.hasClients) return;
      controller.jumpToPage(pageIndex.value);
      return;
    }
    await _getBattery();
    if (!controller.hasClients) return;
    controller.previousPage(
      duration: Durations.medium1,
      curve: Curves.easeInOut,
    );
  }

  void updatePageIndex(int index) {
    pageIndex.value = index;
    _debounceSyncProgress();
  }

  void _debounceSyncProgress() {
    _progressDebounce?.cancel();
    _progressDebounce = Timer(const Duration(seconds: 3), () {
      syncProgress();
    });
  }

  Future<void> syncProgress() async {
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
    chapterIndex.value = index;
    updatePageIndex(0);
    currentChapterPages.value = [];
    _loadCurrentChapter();
    _preloadPreviousChapter();
    _preloadNextChapter();
    if (!controller.hasClients) return;
    controller.jumpToPage(pageIndex.value);
  }

  Future<void> navigateSourcePage(BuildContext context) async {
    var newBookUrl = await CloudReaderSourceRoute(
      bookUrl: book.bookUrl,
      currentOrigin: book.origin,
    ).push<String>(context);
    if (newBookUrl == null) return;
    DialogUtil.loading();
    currentChapterPages.value = [];
    error.value = '';
    book.bookUrl = newBookUrl;
    await _loadChapterList();
    chapterIndex.value = 0;
    updatePageIndex(0);
    _loadCurrentChapter();
    _preloadPreviousChapter();
    _preloadNextChapter();
    DialogUtil.dismiss();
  }

  Future<void> forceRefresh() async {
    currentChapterPages.value = [];
    updatePageIndex(0);
    _loadCurrentChapter();
  }

  // Private methods

  Future<void> _getBattery() async {
    try {
      battery.value = await Battery().batteryLevel;
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<String> _getContent(int index) async {
    var chapterTitle =
        index < chapters.value.length ? chapters.value[index].title : '';
    try {
      var content = await CloudReaderApiClient().getBookContent(
        book.bookUrl,
        index,
      );
      if (content.isEmpty) {
        return '$chapterTitle\n\n没有解析到内容';
      }
      return '$chapterTitle\n\n$content';
    } catch (e) {
      return '$chapterTitle\n\n加载失败: $e';
    }
  }

  Future<void> _loadCurrentChapter() async {
    currentChapterContent.value = await _getContent(chapterIndex.value);
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

  Theme _initTheme() {
    var defaultTheme = Theme()
      ..footerPaddingBottom = 24
      ..headerPaddingTop = 48;
    return _assembleTheme(defaultTheme);
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
}
