import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/reader/reader_cache_indicator_view.dart';
import 'package:source_parser/page/reader/reader_content_view.dart';
import 'package:source_parser/page/reader/reader_overlay_view.dart';
import 'package:source_parser/page/reader/reader_view_model.dart';

@RoutePage()
class ReaderPage extends StatefulWidget {
  final BookEntity book;
  const ReaderPage({super.key, required this.book});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late final viewModel = GetIt.instance.get<ReaderViewModel>(
    param1: widget.book,
  );

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      var children = [
        _buildReaderView(),
        _buildReaderOverlay(),
        _buildReaderCacheIndicator(),
      ];
      return Stack(children: children);
    });
  }

  @override
  void deactivate() {
    viewModel.syncBookshelf();
    viewModel.hideUiOverlays();
    super.deactivate();
  }

  @override
  void dispose() {
    viewModel.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initSignals();
      viewModel.hideUiOverlays();
    });
  }

  Widget _buildReaderCacheIndicator() {
    if (!viewModel.showCacheIndicator.value) return const SizedBox();
    var indicator = Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: ReaderCacheIndicatorView(progress: viewModel.progress.value),
    );
    return Align(alignment: Alignment.centerRight, child: indicator);
  }

  Widget _buildReaderOverlay() {
    if (!viewModel.showOverlay.value) return const SizedBox();
    return ReaderOverlayView(
      book: widget.book,
      onBarrierTap: viewModel.hideUiOverlays,
      onCached: (amount) => viewModel.downloadChapters(context, amount),
      onCatalogue: _navigateCatalogue,
      onNext: _nextChapter,
      onPrevious: _previousChapter,
      onAvailableSource: _navigateAvailableSourcePage,
    );
  }

  Widget _buildReaderView() {
    if (viewModel.currentChapterPages.value.isEmpty) {
      return ReaderContentView.loading(theme: viewModel.theme.value);
    }
    return PageView.builder(
      controller: viewModel.controller,
      itemBuilder: (context, index) => GestureDetector(
        onTapUp: _handleTapUp,
        child: ReaderContentView(
          battery: viewModel.battery.value,
          contentText: viewModel.currentChapterPages.value[index],
          headerText: viewModel.headerText.value,
          pageProgressText: viewModel.getFooterText(index),
          theme: viewModel.theme.value,
        ),
      ),
      itemCount: viewModel.currentChapterPages.value.length,
      onPageChanged: viewModel.updatePageIndex,
    );
  }

  // void _changePage() {
  //   var provider = readerStateNotifierProvider(widget.book);
  //   var notifier = ref.read(provider.notifier);
  //   notifier.syncState(
  //     chapterIndex: _readerController!.chapterIndex,
  //     pageIndex: _readerController!.pageIndex,
  //   );
  //   var batteryProvider = batteryNotifierProvider;
  //   var batteryNotifier = ref.read(batteryProvider.notifier);
  //   batteryNotifier.updateBattery();
  // }

  // Future<void> _forceRefresh() async {
  //   setState(() {
  //     _isRefreshing = true;
  //   });
  //   await _readerController?.refresh();
  //   setState(() {
  //     _isRefreshing = false;
  //   });
  // }

  // Future<void> _forward() async {
  //   if (_nextPage == null) _prepareNextPage(true);
  //   var screenSize = MediaQuery.sizeOf(context);
  //   setState(() {
  //     _coverAnimation.forward(screenSize.width);
  //   });
  //   await _animationController.forward();
  //   await _readerController!.nextPage();
  //   _changePage();
  //   setState(() {
  //     _nextPage = null;
  //     _coverAnimation.cleanUp();
  //   });
  // }

  // void _handleDragEnd(DragEndDetails details) {
  //   var screenWidth = MediaQuery.sizeOf(context).width;
  //   final shouldTurnPage = _coverAnimation.handleDragEnd(details, screenWidth);
  //   if (shouldTurnPage) {
  //     bool isForward = _coverAnimation.dragDistance < 0;
  //     if (isForward && !_readerController!.isLastPage) {
  //       _forward();
  //     } else if (!isForward && !_readerController!.isFirstPage) {
  //       _reverse();
  //     } else {
  //       _reset();
  //     }
  //   } else {
  //     _reset();
  //   }
  // }

  // void _handleDragStart(DragStartDetails details) {
  //   _coverAnimation.handleDragStart(details);
  //   _nextPage = null;
  // }

  // void _handleDragUpdate(DragUpdateDetails details) {
  //   var screenSize = MediaQuery.sizeOf(context);
  //   setState(() {
  //     _coverAnimation.handleDragUpdate(
  //       details,
  //       screenSize.width,
  //       isFirstPage: _readerController!.isFirstPage,
  //       isLastPage: _readerController!.isLastPage,
  //     );
  //     _nextPage ??= _itemBuilder(_coverAnimation.isForward ? 2 : 0);
  //   });
  // }

  void _handleTapUp(TapUpDetails details) {
    final screenSize = MediaQuery.sizeOf(context);
    final horizontalTapArea = details.globalPosition.dx / screenSize.width;
    final verticalTapArea = details.globalPosition.dy / screenSize.height;
    if (horizontalTapArea < 1 / 3) {
      viewModel.previousPage();
    } else if (horizontalTapArea > 2 / 3) {
      viewModel.nextPage();
    } else if (horizontalTapArea >= 1 / 3 && horizontalTapArea <= 2 / 3) {
      if (verticalTapArea > 3 / 4) {
        viewModel.nextPage();
      } else if (verticalTapArea < 1 / 4) {
        viewModel.previousPage();
      } else {
        viewModel.showUiOverlays();
      }
    }
  }

  // void _initReaderController() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     var size = await ref.watch(readerSizeNotifierProvider.future);
  //     var theme = await ref.watch(themeNotifierProvider.future);
  //     _readerController = ReaderController(
  //       widget.book,
  //       size: size,
  //       theme: theme,
  //     );
  //     setState(() {});
  //     await _readerController?.init();
  //   });
  // }

  // Widget _itemBuilder(int index) {
  //   String content;
  //   String headerText;
  //   String pageProgressText;

  //   switch (index) {
  //     case 0:
  //       content = _readerController!.previousContent;
  //       headerText = _readerController!.previousHeader;
  //       pageProgressText = _readerController!.previousProgress;
  //       break;
  //     case 1:
  //       content = _readerController!.currentContent;
  //       headerText = _readerController!.currentHeader;
  //       pageProgressText = _readerController!.currentProgress;
  //       break;
  //     case 2:
  //       content = _readerController!.nextContent;
  //       headerText = _readerController!.nextHeader;
  //       pageProgressText = _readerController!.nextProgress;
  //       break;
  //     default:
  //       content = "Invalid page index";
  //       headerText = "Error";
  //       pageProgressText = "";
  //   }
  //   return ReaderContentView(
  //     contentText: content,
  //     headerText: headerText,
  //     pageProgressText: pageProgressText,
  //   );
  // }

  void _navigateAvailableSourcePage() {
    viewModel.navigateAvailableSourcePage(context);
  }

  void _navigateCatalogue() {
    viewModel.navigateCataloguePage(context);
  }

  void _nextChapter() {
    viewModel.nextChapter();
  }

  // void _prepareNextPage(bool isForward) {
  //   _coverAnimation.isForward = isForward;
  //   _nextPage = _itemBuilder(isForward ? 2 : 0);
  // }

  void _previousChapter() {
    viewModel.previousChapter();
  }

  // Future<void> _reset() async {
  //   var screenSize = MediaQuery.sizeOf(context);
  //   setState(() {
  //     _coverAnimation.reset(screenSize.width);
  //   });
  //   await _animationController.reverse();
  //   setState(() {
  //     _nextPage = null;
  //     _coverAnimation.cleanUp();
  //   });
  // }

  // Future<void> _reverse() async {
  //   if (_nextPage == null) _prepareNextPage(false);
  //   var screenSize = MediaQuery.sizeOf(context);
  //   setState(() {
  //     _coverAnimation.reverse(screenSize.width);
  //   });
  //   await _animationController.forward();
  //   await _readerController!.previousPage();
  //   _changePage();
  //   setState(() {
  //     _nextPage = null;
  //     _coverAnimation.cleanUp();
  //   });
  // }
}
