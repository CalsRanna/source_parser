import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/page/reader/animation/cover_page.dart';
import 'package:source_parser/page/reader/component/cache.dart';
import 'package:source_parser/page/reader/component/overlay.dart';
import 'package:source_parser/page/reader/component/view.dart';
import 'package:source_parser/provider/battery.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/reader.dart';
import 'package:source_parser/provider/theme.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/reader_controller.dart';

@RoutePage()
class ReaderPage extends ConsumerStatefulWidget {
  final Book book;
  const ReaderPage({super.key, required this.book});

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

enum ReaderViewTurningMode { drag, tap }

class _ReaderPageState extends ConsumerState<ReaderPage> {
  bool showOverlay = false;
  bool showCache = false;
  ReaderController? controller;

  @override
  Widget build(BuildContext context) {
    var children = [
      _buildReaderView(),
      _buildReaderOverlay(),
      _buildReaderCacheIndicator(),
    ];
    return Stack(children: children);
  }

  @override
  void deactivate() {
    _showUiOverlays();
    _refreshShelf();
    super.deactivate();
  }

  void handleBarrierTaped() {
    _hideUiOverlays();
    setState(() {
      showOverlay = false;
    });
  }

  void handleCached(int amount) async {
    setState(() {
      showCache = true;
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
      showCache = false;
    });
  }

  void handleNextChapterChanged() {
    controller?.nextChapter();
    setState(() {});
    var provider = readerStateNotifierProvider(widget.book);
    var notifier = ref.read(provider.notifier);
    notifier.syncState(chapter: controller!.chapter, page: controller!.page);
  }

  void handlePageChanged(int index) {
    var provider = readerStateNotifierProvider(widget.book);
    var notifier = ref.read(provider.notifier);
    notifier.syncState(chapter: controller!.chapter, page: controller!.page);
  }

  void handlePreviousChapterChanged() {
    controller?.previousChapter(page: 0);
    setState(() {});
    var provider = readerStateNotifierProvider(widget.book);
    var notifier = ref.read(provider.notifier);
    notifier.syncState(chapter: controller!.chapter, page: controller!.page);
  }

  void handleRefresh() {
    controller?.refresh();
    setState(() {});
  }

  void handleTap() {
    _showUiOverlays();
    setState(() {
      showOverlay = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _hideUiOverlays();
    _initController();
  }

  void navigateCatalogue() {
    CatalogueRoute(index: controller!.chapter).push(context);
  }

  Widget _buildReaderCacheIndicator() {
    if (!showCache) return const SizedBox();
    var progress = ref.watch(cacheProgressNotifierProvider);
    var indicator = Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: ReaderCacheIndicator(progress: progress.progress),
    );
    return Align(alignment: Alignment.centerRight, child: indicator);
  }

  Widget _buildReaderOverlay() {
    if (!showOverlay) return const SizedBox();
    return ReaderOverlay(
      book: widget.book,
      onBarrierTap: handleBarrierTaped,
      onCached: handleCached,
      onCatalogue: navigateCatalogue,
      onNext: handleNextChapterChanged,
      onPrevious: handlePreviousChapterChanged,
      onRefresh: handleRefresh,
    );
  }

  Widget _buildReaderView() {
    if (controller == null) return ReaderView.loading();
    return _ReaderView(
      controller: controller!,
      onPageChanged: handlePageChanged,
      onTap: handleTap,
    );
  }

  void _hideUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _initController() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      var size = await ref.watch(readerSizeNotifierProvider.future);
      var theme = await ref.watch(themeNotifierProvider.future);
      controller = ReaderController(widget.book, size: size, theme: theme);
      await controller?.init();
      setState(() {});
    });
  }

  void _refreshShelf() {
    var container = ProviderScope.containerOf(context);
    container.invalidate(booksProvider);
  }

  void _showUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }
}

class _ReaderView extends ConsumerStatefulWidget {
  final ReaderController controller;
  final Function()? onTap;
  final Function(int)? onPageChanged;

  const _ReaderView({
    required this.controller,
    this.onTap,
    this.onPageChanged,
  });

  @override
  ConsumerState<_ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends ConsumerState<_ReaderView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late CoverPageAnimation _pageAnimation;
  Widget? _nextPage;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTapUp: handleTapUp,
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: [
          // 底层始终显示下一页
          if (_pageAnimation.isForward &&
              (_pageAnimation.dragDistance != 0 || _pageAnimation.isAnimating))
            _nextPage ?? _itemBuilder(2),
          // 当前页
          if (_pageAnimation.isForward)
            SlideTransition(
              position: _pageAnimation.slideAnimation!,
              child: SizedBox(
                width: screenSize.width,
                height: screenSize.height,
                child: _itemBuilder(1),
              ),
            )
          else
            _itemBuilder(1),
          // 向右滑时显示上一页，覆盖在当前页上方
          if (!_pageAnimation.isForward &&
              (_pageAnimation.dragDistance != 0 ||
                  _pageAnimation.isAnimating) &&
              !widget.controller.isFirstPage)
            Positioned(
              left: -screenSize.width,
              child: SlideTransition(
                position: _pageAnimation.slideAnimation!,
                child: SizedBox(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: _nextPage ?? _itemBuilder(0),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void handleTapUp(TapUpDetails details) {
    if (_pageAnimation.isAnimating) return;
    final screenSize = MediaQuery.sizeOf(context);
    final horizontalTapArea = details.globalPosition.dx / screenSize.width;
    final verticalTapArea = details.globalPosition.dy / screenSize.height;
    if (horizontalTapArea < 1 / 3 && !widget.controller.isFirstPage) {
      _prepareNextPage(false);
      _animateToPrevious();
    } else if (horizontalTapArea > 2 / 3 && !widget.controller.isLastPage) {
      _prepareNextPage(true);
      _animateToNext();
    } else if (horizontalTapArea >= 1 / 3 && horizontalTapArea <= 2 / 3) {
      if (verticalTapArea > 3 / 4 && !widget.controller.isLastPage) {
        _prepareNextPage(true);
        _animateToNext();
      } else if (verticalTapArea < 1 / 4 && !widget.controller.isFirstPage) {
        _prepareNextPage(false);
        _animateToPrevious();
      } else {
        widget.onTap?.call();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _pageAnimation = CoverPageAnimation(controller: _animationController);
    _pageAnimation.initAnimation();
    _updateBattery();
  }

  void _animateToNext() {
    if (_nextPage == null) {
      _prepareNextPage(true);
    }
    setState(() {
      _pageAnimation.animateToNext(MediaQuery.of(context).size.width);
    });
    _animationController.forward().then((_) {
      widget.controller.nextPage();
      widget.onPageChanged?.call(1);
      setState(() {
        _nextPage = null;
        _pageAnimation.cleanUp();
      });
    });
  }

  void _animateToPrevious() {
    if (_nextPage == null) {
      _prepareNextPage(false);
    }
    setState(() {
      _pageAnimation.animateToPrevious(MediaQuery.of(context).size.width);
    });
    _animationController.forward().then((_) {
      widget.controller.previousPage();
      widget.onPageChanged?.call(1);
      setState(() {
        _nextPage = null;
        _pageAnimation.cleanUp();
      });
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final shouldTurnPage = _pageAnimation.handleDragEnd(
      details,
      MediaQuery.of(context).size.width,
    );

    if (shouldTurnPage) {
      bool isForward = _pageAnimation.dragDistance < 0;
      if (isForward && !widget.controller.isLastPage) {
        _animateToNext();
      } else if (!isForward && !widget.controller.isFirstPage) {
        _animateToPrevious();
      } else {
        _resetPosition();
      }
    } else {
      _resetPosition();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _pageAnimation.handleDragStart(details);
    _nextPage = null;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _pageAnimation.handleDragUpdate(
        details,
        MediaQuery.of(context).size.width,
        isFirstPage: widget.controller.isFirstPage,
        isLastPage: widget.controller.isLastPage,
      );
      _nextPage ??= _itemBuilder(_pageAnimation.isForward ? 2 : 0);
    });
  }

  Widget _itemBuilder(int index) {
    final content = widget.controller.getContent(index);
    return ReaderView(
      content: content,
      headerText: widget.controller.getHeaderText(index),
      pageProgressText: widget.controller.getPageProgressText(index),
      totalProgressText: widget.controller.getTotalProgressText(index),
    );
  }

  void _prepareNextPage(bool isForward) {
    _pageAnimation.isForward = isForward;
    _nextPage = _itemBuilder(isForward ? 2 : 0);
  }

  void _resetPosition() {
    setState(() {
      _pageAnimation.resetPosition(MediaQuery.of(context).size.width);
    });
    _animationController.forward().then((_) {
      setState(() {
        _nextPage = null;
        _pageAnimation.cleanUp();
      });
    });
  }

  Future<void> _updateBattery() async {
    if (!mounted) return;
    await ref.read(batteryNotifierProvider.notifier).updateBattery();
  }
}
