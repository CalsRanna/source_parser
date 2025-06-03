import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/reader/animation/cover_page.dart';
import 'package:source_parser/page/reader/reader_cache_indicator_view.dart';
import 'package:source_parser/page/reader/reader_overlay_view.dart';
import 'package:source_parser/page/reader/reader_content_view.dart';
import 'package:source_parser/page/reader/reader_view_model.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/page/reader/reader_controller.dart';

@RoutePage()
class ReaderPage extends ConsumerStatefulWidget {
  final BookEntity book;
  const ReaderPage({super.key, required this.book});

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage>
    with SingleTickerProviderStateMixin {
  bool _showCacheIndicator = false;
  bool _showOverlay = false;
  bool _isRefreshing = false;
  ReaderController? _readerController;

  late AnimationController _animationController;
  late CoverPageAnimation _coverAnimation;
  Widget? _nextPage;

  late final viewModel = GetIt.instance<ReaderViewModel>(
    param1: widget.book,
  );

  @override
  Widget build(BuildContext context) {
    var children = [
      Watch((context) => _buildReaderView()),
      _buildReaderOverlay(),
      _buildReaderCacheIndicator(),
    ];
    return Stack(children: children);
  }

  @override
  void deactivate() {
    // Can not use `_showUiOverlays` cause can not call `setState` here
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _refreshShelf();
    viewModel.syncBookshelf();
    super.deactivate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _readerController?.dispose();
    viewModel.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hideUiOverlays();
    _initReaderController();
    _animationController = AnimationController(vsync: this);
    _coverAnimation = CoverPageAnimation(controller: _animationController);
    _coverAnimation.initAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initSignals();
    });
  }

  Widget _buildReaderCacheIndicator() {
    if (!_showCacheIndicator) return const SizedBox();
    var progress = ref.watch(cacheProgressNotifierProvider);
    var indicator = Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: ReaderCacheIndicatorView(progress: progress.progress),
    );
    return Align(alignment: Alignment.centerRight, child: indicator);
  }

  Widget _buildReaderOverlay() {
    if (!_showOverlay) return const SizedBox();
    return ReaderOverlayView(
      book: widget.book,
      onBarrierTap: _hideUiOverlays,
      onCached: _downloadChapters,
      onCatalogue: _navigateCatalogue,
      onNext: _nextChapter,
      onPrevious: _previousChapter,
      onAvailableSource: _navigateAvailableSourcePage,
    );
  }

  Widget _buildReaderView() {
    if (viewModel.currentChapterPages.value.isEmpty) {
      return ReaderContentView.loading();
    }
    return PageView.builder(
      controller: viewModel.controller,
      itemBuilder: (context, index) => GestureDetector(
        onTapUp: _handleTapUp,
        child: ReaderContentView(
          content: viewModel.currentChapterPages.value[index],
          headerText: viewModel.headerText.value,
          pageProgressText:
              '${viewModel.pageIndex.value + 1} / ${viewModel.currentChapterPages.value.length}',
          customTheme: viewModel.theme.value,
        ),
      ),
      itemCount: viewModel.currentChapterPages.value.length,
    );
  }

  void _changePage() {
    // var provider = readerStateNotifierProvider(widget.book);
    // var notifier = ref.read(provider.notifier);
    // notifier.syncState(
    //   chapterIndex: _readerController!.chapterIndex,
    //   pageIndex: _readerController!.pageIndex,
    // );
    // var batteryProvider = batteryNotifierProvider;
    // var batteryNotifier = ref.read(batteryProvider.notifier);
    // batteryNotifier.updateBattery();
  }

  void _downloadChapters(int amount) async {
    setState(() {
      _showCacheIndicator = true;
    });
    var container = ProviderScope.containerOf(context);
    final notifier = container.read(cacheProgressNotifierProvider.notifier);
    await notifier.cacheChapters(amount: amount);
    if (!mounted) return;
    final message = Message.of(context);
    final progress = container.read(cacheProgressNotifierProvider);
    message.show('缓存完毕，${progress.succeed}章成功，${progress.failed}章失败');
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _showCacheIndicator = false;
    });
  }

  void _navigateAvailableSourcePage() {
    viewModel.navigateAvailableSourcePage(context);
  }

  Future<void> _forceRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await _readerController?.refresh();
    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> _forward() async {
    if (_nextPage == null) _prepareNextPage(true);
    var screenSize = MediaQuery.sizeOf(context);
    setState(() {
      _coverAnimation.forward(screenSize.width);
    });
    await _animationController.forward();
    await _readerController!.nextPage();
    _changePage();
    setState(() {
      _nextPage = null;
      _coverAnimation.cleanUp();
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    var screenWidth = MediaQuery.sizeOf(context).width;
    final shouldTurnPage = _coverAnimation.handleDragEnd(details, screenWidth);
    if (shouldTurnPage) {
      bool isForward = _coverAnimation.dragDistance < 0;
      if (isForward && !_readerController!.isLastPage) {
        _forward();
      } else if (!isForward && !_readerController!.isFirstPage) {
        _reverse();
      } else {
        _reset();
      }
    } else {
      _reset();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _coverAnimation.handleDragStart(details);
    _nextPage = null;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    var screenSize = MediaQuery.sizeOf(context);
    setState(() {
      _coverAnimation.handleDragUpdate(
        details,
        screenSize.width,
        isFirstPage: _readerController!.isFirstPage,
        isLastPage: _readerController!.isLastPage,
      );
      _nextPage ??= _itemBuilder(_coverAnimation.isForward ? 2 : 0);
    });
  }

  void _handleTapUp(TapUpDetails details) {
    if (_coverAnimation.isAnimating) return;
    final screenSize = MediaQuery.sizeOf(context);
    final horizontalTapArea = details.globalPosition.dx / screenSize.width;
    final verticalTapArea = details.globalPosition.dy / screenSize.height;
    if (horizontalTapArea < 1 / 3) {
      // _prepareNextPage(false);
      // _reverse();
      viewModel.previousPage();
    } else if (horizontalTapArea > 2 / 3) {
      // _prepareNextPage(true);
      // _forward();
      viewModel.nextPage();
    } else if (horizontalTapArea >= 1 / 3 && horizontalTapArea <= 2 / 3) {
      if (verticalTapArea > 3 / 4) {
        // _prepareNextPage(true);
        // _forward();
        viewModel.nextPage();
      } else if (verticalTapArea < 1 / 4) {
        // _prepareNextPage(false);
        // _reverse();
        viewModel.previousPage();
      } else {
        _showUiOverlays();
      }
    }
  }

  void _hideUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    setState(() {
      _showOverlay = false;
    });
  }

  void _initReaderController() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await Future.delayed(const Duration(milliseconds: 300));
    //   var size = await ref.watch(readerSizeNotifierProvider.future);
    //   var theme = await ref.watch(themeNotifierProvider.future);
    //   _readerController = ReaderController(
    //     widget.book,
    //     size: size,
    //     theme: theme,
    //   );
    //   setState(() {});
    //   await _readerController?.init();
    // });
  }

  Widget _itemBuilder(int index) {
    String content;
    String headerText;
    String pageProgressText;

    switch (index) {
      case 0:
        content = _readerController!.previousContent;
        headerText = _readerController!.previousHeader;
        pageProgressText = _readerController!.previousProgress;
        break;
      case 1:
        content = _readerController!.currentContent;
        headerText = _readerController!.currentHeader;
        pageProgressText = _readerController!.currentProgress;
        break;
      case 2:
        content = _readerController!.nextContent;
        headerText = _readerController!.nextHeader;
        pageProgressText = _readerController!.nextProgress;
        break;
      default:
        content = "Invalid page index";
        headerText = "Error";
        pageProgressText = "";
    }
    return ReaderContentView(
      content: content,
      headerText: headerText,
      pageProgressText: pageProgressText,
    );
  }

  void _navigateCatalogue() {
    viewModel.navigateCataloguePage(context);
  }

  void _nextChapter() {
    viewModel.nextChapter();
  }

  void _prepareNextPage(bool isForward) {
    _coverAnimation.isForward = isForward;
    _nextPage = _itemBuilder(isForward ? 2 : 0);
  }

  void _previousChapter() {
    viewModel.previousChapter();
  }

  void _refreshShelf() {
    var container = ProviderScope.containerOf(context);
    container.invalidate(booksProvider);
  }

  Future<void> _reset() async {
    var screenSize = MediaQuery.sizeOf(context);
    setState(() {
      _coverAnimation.reset(screenSize.width);
    });
    await _animationController.reverse();
    setState(() {
      _nextPage = null;
      _coverAnimation.cleanUp();
    });
  }

  Future<void> _reverse() async {
    if (_nextPage == null) _prepareNextPage(false);
    var screenSize = MediaQuery.sizeOf(context);
    setState(() {
      _coverAnimation.reverse(screenSize.width);
    });
    await _animationController.forward();
    await _readerController!.previousPage();
    _changePage();
    setState(() {
      _nextPage = null;
      _coverAnimation.cleanUp();
    });
  }

  void _showUiOverlays() {
    setState(() {
      _showOverlay = true;
    });
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }
}
