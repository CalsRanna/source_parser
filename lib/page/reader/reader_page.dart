import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/reader/reader_view.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/reader/reader_cache_indicator_view.dart';
import 'package:source_parser/page/reader/reader_overlay_view.dart';
import 'package:source_parser/page/reader/reader_view_model.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';

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
  final sourceParserViewModel = GetIt.instance.get<SourceParserViewModel>();

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
    viewModel.showUiOverlays();
    super.deactivate();
  }

  @override
  void dispose() {
    viewModel.pageTurnController.dispose();
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
      isDarkMode: viewModel.isDarkMode.value,
      onBarrierTap: viewModel.hideUiOverlays,
      onCached: (amount) => viewModel.downloadChapters(context, amount),
      onCatalogue: () => viewModel.navigateCataloguePage(context),
      onDarkMode: () => viewModel.toggleDarkMode(),
      onNext: viewModel.nextChapter,
      onPrevious: viewModel.previousChapter,
      onAvailableSource: () => viewModel.navigateAvailableSourcePage(context),
      onRefresh: viewModel.forceRefresh,
      onReplacement: () => viewModel.navigateReplacementPage(context),
    );
  }

  Widget _buildReaderView() {
    var error = viewModel.error.value;
    return ReaderView(
      errorText: error.isNotEmpty ? error : null,
      isLoading: viewModel.currentChapterPages.value.isEmpty,
      theme: viewModel.theme.value,
      battery: viewModel.battery.value,
      eInkMode: viewModel.eInkMode.value,
      pageTurnMode: viewModel.pageTurnMode.value,
      pageCount: viewModel.pageCount.value,
      controller: viewModel.pageTurnController,
      onTapUp: viewModel.turnPage,
      getPageData: viewModel.getPageData,
    );
  }
}
