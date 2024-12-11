import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/reader_state.dart';
import 'package:source_parser/page/reader/component/background.dart';
import 'package:source_parser/page/reader/component/cache.dart';
import 'package:source_parser/page/reader/component/overlay.dart';
import 'package:source_parser/page/reader/component/view.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/reader.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/message.dart';

@RoutePage()
class ReaderPage extends StatefulWidget {
  final Book book;
  const ReaderPage({super.key, required this.book});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
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

class _ReaderPageState extends State<ReaderPage> {
  bool showOverlay = false;
  bool showCache = false;

  @override
  Widget build(BuildContext context) {
    var readerOverlay = ReaderOverlay(
      book: widget.book,
      onCached: handleCached,
      onRemoved: handleRemoved,
    );
    var children = [
      ReaderBackground(),
      _ReaderView(book: widget.book, onTap: handleTap),
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
  }

  void _hideUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
  final Book book;
  final void Function()? onTap;
  const _ReaderView({required this.book, this.onTap});

  @override
  ConsumerState<_ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends ConsumerState<_ReaderView> {
  var controller = PageController(initialPage: 1);
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    var provider = readerStateNotifierProvider(widget.book);
    var state = ref.watch(provider);
    var page = switch (state) {
      AsyncData(:final value) => _buildData(ref, value),
      AsyncError(:final error, :final stackTrace) =>
        _buildError(ref, error, stackTrace),
      AsyncLoading() => _buildLoading(),
      _ => const SizedBox(),
    };
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: handleTapUp,
      child: page,
    );
  }

  @override
  void dispose() {
    controller.removeListener(_handleScroll);
    controller.dispose();
    super.dispose();
  }

  Future<void> handlePageChanged(WidgetRef ref, int index) async {
    var provider = readerStateNotifierProvider(widget.book);
    final notifier = ref.read(provider.notifier);
    notifier.updatePageIndex(index);
    controller.jumpToPage(1);
  }

  Future<void> handleTapUp(TapUpDetails details) async {
    if (_isAnimating) return;
    var index = _calculateIndex(details);
    if (index == 1) return widget.onTap?.call();
    var duration = Duration(milliseconds: 300);
    var curve = Curves.easeInOut;
    controller.animateToPage(index, curve: curve, duration: duration);
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_handleScroll);
  }

  Widget _buildData(WidgetRef ref, ReaderState state) {
    if (state.pages.isEmpty) return _buildEmpty();
    return PageView.builder(
      controller: controller,
      itemBuilder: (_, index) => _itemBuilder(state, index),
      itemCount: state.pages.length,
    );
  }

  Widget _buildEmpty() {
    var child = Center(child: Text('空空如也'));
    return ReaderView.builder(
      builder: () => child,
      chapterText: '',
      eInkMode: false,
      progressText: '',
      headerText: widget.book.name,
    );
  }

  Widget _buildError(WidgetRef ref, Object error, StackTrace stackTrace) {
    var children = [
      Text(error.toString()),
      Text(stackTrace.toString()),
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
    var padding = Padding(
      padding: const EdgeInsets.all(16.0),
      child: column,
    );
    return ReaderView.builder(
      builder: () => padding,
      chapterText: '',
      eInkMode: false,
      progressText: '',
      headerText: widget.book.name,
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
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

  String _getChapterText(ReaderState state, int index) {
    var pageIndex = switch (index) {
      0 => state.pageIndex - 1,
      1 => state.pageIndex,
      2 => state.pageIndex + 1,
      _ => 0,
    };
    return '${pageIndex + 1}/${state.currentChapterPages.length}';
  }

  String _getHeaderText(ReaderState state) {
    if (state.book.cursor == 0) return state.book.name;
    return state.book.chapters[state.book.index].name;
  }

  String _getProgressText(ReaderState state) {
    var chapterLength = state.book.chapters.length;
    var chapterIndex = state.chapterIndex;
    var pageLength = state.currentChapterPages.length;
    var pageIndex = state.pageIndex;
    var chapterProgress = chapterIndex / chapterLength;
    var pageProgress = pageIndex / pageLength;
    var progress = chapterProgress + pageProgress * 1 / chapterLength;
    var text = (progress * 100).toStringAsFixed(2);
    return '$text%';
  }

  void _handleScroll() {
    if (_isAnimating) return;

    final position = controller.page ?? 1;
    if (position <= 0.0 || position >= 2.0) {
      _isAnimating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await handlePageChanged(ref, position <= 0.0 ? 0 : 2);
        _isAnimating = false;
      });
    }
  }

  Widget _itemBuilder(ReaderState state, int index) {
    return ReaderView(
      chapterText: _getChapterText(state, index),
      contentText: state.pages[index],
      eInkMode: false,
      headerText: _getHeaderText(state),
      progressText: _getProgressText(state),
    );
  }
}
