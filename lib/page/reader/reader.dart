import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/page/reader/component/background.dart';
import 'package:source_parser/page/reader/component/cache.dart';
import 'package:source_parser/page/reader/component/overlay.dart';
import 'package:source_parser/page/reader/component/view.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/reader.dart';
import 'package:source_parser/provider/setting.dart';
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

class _ReaderPageState extends ConsumerState<ReaderPage> {
  bool showOverlay = false;
  bool showCache = false;
  ReaderController? controller;

  @override
  Widget build(BuildContext context) {
    var readerOverlay = ReaderOverlay(
      book: widget.book,
      onCached: handleCached,
      onNext: handleNextChapterChanged,
      onPrevious: handlePreviousChapterChanged,
      onRemoved: handleRemoved,
    );
    var readerView = _ReaderView(
      controller: controller,
      onPageChanged: handlePageChanged,
      onTap: handleTap,
    );
    var children = [
      ReaderBackground(),
      if (controller != null) readerView,
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

  void handleRemoved() {
    _hideUiOverlays();
    setState(() {
      showOverlay = false;
    });
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

  void _hideUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _initController() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var size = await ref.watch(readerSizeNotifierProvider.future);
      var theme = await ref.watch(themeNotifierProvider.future);
      controller = ReaderController(widget.book, size: size, theme: theme);
      await Future.delayed(const Duration(milliseconds: 300));
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

class _ReaderScrollPhysics extends ScrollPhysics {
  final List<ReaderViewTurningMode>? modes;

  const _ReaderScrollPhysics({this.modes});

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _ReaderScrollPhysics(modes: modes);
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    var realModes = modes ?? ReaderViewTurningMode.values;
    var draggable = realModes.contains(ReaderViewTurningMode.drag);
    if (!draggable) return false;
    return super.shouldAcceptUserOffset(position);
  }
}

class _ReaderView extends ConsumerStatefulWidget {
  final ReaderController? controller;
  final void Function(int)? onPageChanged;
  final void Function()? onTap;
  const _ReaderView({
    this.controller,
    this.onPageChanged,
    this.onTap,
  });

  @override
  ConsumerState<_ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends ConsumerState<_ReaderView> {
  var pageController = PageController(initialPage: 1);
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {
      return ReaderView.builder(
        builder: () => const Center(child: CircularProgressIndicator()),
        headerText: '加载中',
        pageProgressText: '',
        totalProgressText: '',
      );
    }
    var setting = ref.watch(settingNotifierProvider).valueOrNull;
    List<ReaderViewTurningMode> modes = _getModes(setting?.turningMode ?? 0);
    var child = PageView.builder(
      controller: pageController,
      itemBuilder: (_, index) => _itemBuilder(index),
      itemCount: 3,
      physics: _ReaderScrollPhysics(modes: modes),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: handleTapUp,
      child: child,
    );
  }

  @override
  void dispose() {
    pageController.removeListener(_handleScroll);
    pageController.dispose();
    super.dispose();
  }

  Future<void> handlePageChanged(WidgetRef ref, int index) async {
    if (index == 0) {
      widget.controller?.previousPage();
    } else {
      widget.controller?.nextPage();
    }
    pageController.jumpToPage(1);
    widget.onPageChanged?.call(index);
  }

  Future<void> handleTapUp(TapUpDetails details) async {
    var provider = settingNotifierProvider;
    var setting = await ref.read(provider.future);
    var modes = _getModes(setting.turningMode);
    if (!modes.contains(ReaderViewTurningMode.tap)) return;
    if (_isAnimating) return;
    var index = _calculateIndex(details);
    if (index == 1) return widget.onTap?.call();
    var duration = Duration(milliseconds: 300);
    var curve = Curves.easeInOut;
    pageController.animateToPage(index, curve: curve, duration: duration);
  }

  @override
  void initState() {
    super.initState();
    pageController.addListener(_handleScroll);
  }

  int _calculateIndex(TapUpDetails details) {
    var position = details.localPosition;
    var size = MediaQuery.of(context).size;
    var horizontalThreshold = size.width / 3;
    var verticalThreshold = size.height / 4;
    if (position.dx < horizontalThreshold) return 0;
    if (position.dx > horizontalThreshold * 2) return 2;
    if (position.dy < verticalThreshold) return 0;
    if (position.dy > verticalThreshold * 3) return 2;
    return 1;
  }

  List<ReaderViewTurningMode> _getModes(int turningMode) {
    List<ReaderViewTurningMode> modes = [];
    if (turningMode & 1 == 1) modes.add(ReaderViewTurningMode.drag);
    if (turningMode & 2 == 2) modes.add(ReaderViewTurningMode.tap);
    return modes;
  }

  void _handleScroll() {
    if (_isAnimating) return;

    final position = pageController.page ?? 1;
    if (position <= 0.0 || position >= 2.0) {
      _isAnimating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await handlePageChanged(ref, position <= 0.0 ? 0 : 2);
        _isAnimating = false;
      });
    }
  }

  Widget _itemBuilder(int index) {
    return ReaderView(
      contentText: widget.controller?.getContentText(index) ?? '',
      headerText: widget.controller?.getHeaderText(index) ?? '',
      pageProgressText: widget.controller?.getPageProgressText(index) ?? '',
      totalProgressText: widget.controller?.getTotalProgressText(index) ?? '',
    );
  }
}
