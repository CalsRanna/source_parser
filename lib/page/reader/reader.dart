import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/page/reader/component/background.dart';
import 'package:source_parser/page/reader/component/cache.dart';
import 'package:source_parser/page/reader/component/overlay.dart';
import 'package:source_parser/page/reader/component/view.dart';
import 'package:source_parser/provider/battery.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/reader.dart';
import 'package:source_parser/provider/theme.dart';
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

class _ReaderCacheIndicator extends ConsumerWidget {
  const _ReaderCacheIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var progress = ref.watch(cacheProgressNotifierProvider);
    var indicator = Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: ReaderCacheIndicator(progress: progress.progress),
    );
    return Align(alignment: Alignment.centerRight, child: indicator);
  }
}

class _ReaderLoading extends StatelessWidget {
  const _ReaderLoading();

  @override
  Widget build(BuildContext context) {
    return ReaderView.builder(
      builder: () => const Center(child: CircularProgressIndicator()),
      headerText: '加载中',
      pageProgressText: '',
      totalProgressText: '',
    );
  }
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  bool showOverlay = false;
  bool showCache = false;
  ReaderController? controller;

  @override
  Widget build(BuildContext context) {
    var readerOverlay = ReaderOverlay(
      book: widget.book,
      onBarrierTap: handleBarrierTaped,
      onCached: handleCached,
      onNext: handleNextChapterChanged,
      onPrevious: handlePreviousChapterChanged,
      onRefresh: handleRefresh,
    );
    var children = [
      ReaderBackground(),
      if (controller == null) _ReaderLoading(),
      if (controller != null) _buildReaderView(),
      if (showCache) _ReaderCacheIndicator(),
      if (showOverlay) readerOverlay,
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

  Widget _buildReaderView() {
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
  late Animation<Offset> _slideAnimation;
  bool _isAnimating = false;
  Offset? _dragStartPosition;
  double _dragDistance = 0.0;
  Widget? _nextPage;
  bool _isForward = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initAnimation();
    _animationController.addStatusListener(_handleAnimationStatus);
    _updateBattery();
  }

  void _initAnimation() {
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: _isForward ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _isAnimating = false;
        _dragDistance = 0.0;
        _nextPage = null;
      });
      _initAnimation();
      _animationController.reset();
      _updateBattery();
    }
  }

  void _prepareNextPage(bool isForward) {
    _isForward = isForward;
    _nextPage = _itemBuilder(isForward ? 2 : 0);
  }

  void _handleDragStart(DragStartDetails details) {
    if (_isAnimating) return;
    _dragStartPosition = details.globalPosition;
    _dragDistance = 0.0;
    _nextPage = null;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dragStartPosition == null || _isAnimating) return;

    final delta = details.primaryDelta ?? 0;

    // 检查是否可以继续拖动
    if ((delta > 0 && widget.controller.isFirstPage) ||
        (delta < 0 && widget.controller.isLastPage)) {
      return;
    }

    setState(() {
      _dragDistance += delta;
      double screenWidth = MediaQuery.of(context).size.width;
      _isForward = _dragDistance < 0;

      // 准备下一页内容
      if (_nextPage == null) {
        _nextPage = _itemBuilder(_isForward ? 2 : 0);
      }

      double dragPercent = (_dragDistance / screenWidth).clamp(-1.0, 1.0);
      if (_isForward) {
        // 向左滑：当前页向左移动
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-1.0, 0.0),
        ).animate(AlwaysStoppedAnimation(-dragPercent));
      } else {
        // 向右滑：前一页从左边滑入
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(1.0, 0.0),
        ).animate(AlwaysStoppedAnimation(dragPercent));
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragStartPosition == null) return;
    _dragStartPosition = null;

    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = _dragDistance.abs() / screenWidth;
    final velocity = details.primaryVelocity ?? 0;
    final velocityPercentage = velocity.abs() / screenWidth;

    bool shouldTurnPage = dragPercentage > 0.2 || velocity.abs() > 800;

    if (shouldTurnPage) {
      bool isForward = _dragDistance < 0;

      if (isForward && !widget.controller.isLastPage) {
        _animateToNext(velocity: velocity);
      } else if (!isForward && !widget.controller.isFirstPage) {
        _animateToPrevious();
      } else {
        _resetPosition();
      }
    } else {
      _resetPosition();
    }
  }

  void handleTapUp(TapUpDetails details) {
    if (_isAnimating) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;
    final tapArea = tapPosition / screenWidth;

    if (tapArea < 0.3 && !widget.controller.isFirstPage) {
      _prepareNextPage(false);
      _animateToPrevious();
    } else if (tapArea > 0.7 && !widget.controller.isLastPage) {
      _prepareNextPage(true);
      _animateToNext();
    } else if (tapArea >= 0.3 && tapArea <= 0.7) {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: handleTapUp,
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: [
          // 底层始终显示下一页
          if (_isForward && (_dragDistance != 0 || _isAnimating))
            _nextPage ?? _itemBuilder(2),
          // 当前页
          if (_isForward)
            SlideTransition(
              position: _slideAnimation,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _itemBuilder(1),
              ),
            )
          else
            _itemBuilder(1),
          // 向右滑时显示上一页，覆盖在当前页上方
          if (!_isForward && (_dragDistance != 0 || _isAnimating) && !widget.controller.isFirstPage)
            Positioned(
              left: -MediaQuery.of(context).size.width,
              child: SlideTransition(
                position: _slideAnimation,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: _nextPage ?? _itemBuilder(0),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _animateToNext({double velocity = 0}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentOffset = -_dragDistance / screenWidth;
    final remainingDistance = 1.0 - currentOffset;

    if (_nextPage == null) {
      _prepareNextPage(true);
    }

    setState(() {
      _isAnimating = true;
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-1.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ));
    });

    _animationController.value = currentOffset;
    _animationController.duration = Duration(milliseconds: (300 * remainingDistance).toInt());
    _animationController.forward().then((_) {
      widget.controller.nextPage();
      widget.onPageChanged?.call(1);
      setState(() {
        _isAnimating = false;
        _dragDistance = 0.0;
        _nextPage = null;
      });
      _initAnimation();
      _animationController.reset();
    });
  }

  void _animateToPrevious() {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentOffset = _dragDistance / screenWidth;
    final remainingDistance = 1.0 - currentOffset;

    if (_nextPage == null) {
      _prepareNextPage(false);
    }

    setState(() {
      _isAnimating = true;
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(1.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ));
    });

    _animationController.value = currentOffset;
    _animationController.duration = Duration(milliseconds: (300 * remainingDistance).toInt());
    _animationController.forward().then((_) {
      widget.controller.previousPage();
      widget.onPageChanged?.call(1);
      setState(() {
        _isAnimating = false;
        _dragDistance = 0.0;
        _nextPage = null;
      });
      _initAnimation();
      _animationController.reset();
    });
  }

  void _resetPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentOffset = _dragDistance.abs() / screenWidth;

    setState(() {
      _isAnimating = true;
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: _isForward ? Offset(-1.0, 0.0) : Offset(1.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ));
    });

    _animationController.value = currentOffset;
    final remainingDistance = 1.0 - currentOffset;
    _animationController.duration = Duration(milliseconds: (300 * remainingDistance).toInt());
    _animationController.forward().then((_) {
      setState(() {
        _isAnimating = false;
        _dragDistance = 0.0;
        _nextPage = null;
      });
      _initAnimation();
      _animationController.reset();
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

  Future<void> _updateBattery() async {
    if (!mounted) return;
    await ref.read(batteryNotifierProvider.notifier).updateBattery();
  }
}
