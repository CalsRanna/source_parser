import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/page/reader/animation/cover_page.dart';
import 'package:source_parser/page/reader/component/cache.dart';
import 'package:source_parser/page/reader/component/overlay.dart';
import 'package:source_parser/page/reader/component/view.dart';
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

class _ReaderPageState extends ConsumerState<ReaderPage>
    with SingleTickerProviderStateMixin {
  bool _showCacheIndicator = false;
  bool _showOverlay = false;
  ReaderController? _readerController;

  late AnimationController _animationController;
  late CoverPageAnimation _coverAnimation;
  Widget? _nextPage;

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
    // Can not use `_showUiOverlays` cause can not call `setState` here
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _refreshShelf();
    super.deactivate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _readerController?.dispose();
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
  }

  Widget _buildReaderCacheIndicator() {
    if (!_showCacheIndicator) return const SizedBox();
    var progress = ref.watch(cacheProgressNotifierProvider);
    var indicator = Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: ReaderCacheIndicator(progress: progress.progress),
    );
    return Align(alignment: Alignment.centerRight, child: indicator);
  }

  Widget _buildReaderOverlay() {
    if (!_showOverlay) return const SizedBox();
    return ReaderOverlay(
      book: widget.book,
      onBarrierTap: _hideUiOverlays,
      onCached: _downloadChapters,
      onCatalogue: _navigateCatalogue,
      onNext: _nextChapter,
      onPrevious: _previousChapter,
      onRefresh: _forceRefresh,
    );
  }

  Widget _buildReaderView() {
    if (_readerController == null) return ReaderView.loading();
    var screenSize = MediaQuery.sizeOf(context);
    Widget bottom = SizedBox();
    var conditionA = _coverAnimation.isForward;
    var conditionB = _coverAnimation.dragDistance != 0;
    var conditionC = _coverAnimation.isAnimating;
    if (conditionA && (conditionB || conditionC)) {
      bottom = _nextPage ?? _itemBuilder(2);
    }
    Widget current = _itemBuilder(1);
    if (_coverAnimation.isForward) {
      var sizedBox = SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: current,
      );
      current = SlideTransition(
        position: _coverAnimation.slideAnimation!,
        child: sizedBox,
      );
    }
    Widget top = SizedBox();
    var conditionD = !_readerController!.isFirstPage;
    if (!conditionA && (conditionB || conditionC) && conditionD) {
      var sizedBox = SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: _nextPage ?? _itemBuilder(0),
      );
      var slideTransition = SlideTransition(
        position: _coverAnimation.slideAnimation!,
        child: sizedBox,
      );
      top = Positioned(left: -screenSize.width, child: slideTransition);
    }
    return GestureDetector(
      onTapUp: _handleTapUp,
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(children: [bottom, current, top]),
    );
  }

  void _changePage() {
    var provider = readerStateNotifierProvider(widget.book);
    var notifier = ref.read(provider.notifier);
    notifier.syncState(
      chapter: _readerController!.chapter,
      page: _readerController!.page,
    );
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

  void _forceRefresh() {
    _readerController?.refresh();
    setState(() {});
  }

  Future<void> _forward() async {
    if (_nextPage == null) _prepareNextPage(true);
    var screenSize = MediaQuery.sizeOf(context);
    setState(() {
      _coverAnimation.forward(screenSize.width);
    });
    await _animationController.forward();
    _readerController!.nextPage();
    _changePage();
    setState(() {
      _nextPage = null;
      _coverAnimation.cleanUp();
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    var screenSize = MediaQuery.sizeOf(context);
    final shouldTurnPage = _coverAnimation.handleDragEnd(
      details,
      screenSize.width,
    );
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
    if (horizontalTapArea < 1 / 3 && !_readerController!.isFirstPage) {
      _prepareNextPage(false);
      _reverse();
    } else if (horizontalTapArea > 2 / 3 && !_readerController!.isLastPage) {
      _prepareNextPage(true);
      _forward();
    } else if (horizontalTapArea >= 1 / 3 && horizontalTapArea <= 2 / 3) {
      if (verticalTapArea > 3 / 4 && !_readerController!.isLastPage) {
        _prepareNextPage(true);
        _forward();
      } else if (verticalTapArea < 1 / 4 && !_readerController!.isFirstPage) {
        _prepareNextPage(false);
        _reverse();
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      var size = await ref.watch(readerSizeNotifierProvider.future);
      var theme = await ref.watch(themeNotifierProvider.future);
      _readerController = ReaderController(
        widget.book,
        size: size,
        theme: theme,
      );
      await _readerController?.init();
      setState(() {});
    });
  }

  Widget _itemBuilder(int index) {
    final content = _readerController!.getContent(index);
    return ReaderView(
      content: content,
      headerText: _readerController!.getHeaderText(index),
      pageProgressText: _readerController!.getPageProgressText(index),
      totalProgressText: _readerController!.getTotalProgressText(index),
    );
  }

  void _navigateCatalogue() {
    CatalogueRoute(index: _readerController!.chapter).push(context);
  }

  void _nextChapter() {
    _readerController?.nextChapter();
    var provider = readerStateNotifierProvider(widget.book);
    var notifier = ref.read(provider.notifier);
    notifier.syncState(
      chapter: _readerController!.chapter,
      page: _readerController!.page,
    );
    setState(() {});
  }

  void _prepareNextPage(bool isForward) {
    _coverAnimation.isForward = isForward;
    _nextPage = _itemBuilder(isForward ? 2 : 0);
  }

  void _previousChapter() {
    _readerController?.previousChapter(page: 0);
    var provider = readerStateNotifierProvider(widget.book);
    var notifier = ref.read(provider.notifier);
    notifier.syncState(
      chapter: _readerController!.chapter,
      page: _readerController!.page,
    );
    setState(() {});
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
    _readerController!.previousPage();
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
