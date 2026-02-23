import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/reader/reader_cache_indicator_view.dart';
import 'package:source_parser/page/reader/reader_content_view.dart';
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
      var backgroundColor = sourceParserViewModel.isDarkMode.value
          ? Colors.black
          : Colors.white;
      var children = [
        _buildReaderView(),
        _buildReaderOverlay(),
        _buildReaderCacheIndicator(),
      ];
      return ColoredBox(
        color: backgroundColor,
        child: Stack(children: children),
      );
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
    ScrollPhysics? physics;
    if (viewModel.eInkMode.value || viewModel.turningMode.value & 1 == 0) {
      physics = const NeverScrollableScrollPhysics();
    }
    if (viewModel.error.value.isNotEmpty) {
      return GestureDetector(
        onTapUp: viewModel.turnPage,
        child: ReaderContentView.error(
          errorText: viewModel.error.value,
          theme: viewModel.theme.value,
        ),
      );
    }
    if (viewModel.currentChapterPages.value.isEmpty) {
      return GestureDetector(
        onTapUp: viewModel.turnPage,
        child: ReaderContentView.loading(theme: viewModel.theme.value),
      );
    }
    return PageView.builder(
      controller: viewModel.controller,
      itemBuilder: (context, index) {
        var pageData = viewModel.getPageData(index);
        Widget child;
        if (pageData.isLoading) {
          child = ReaderContentView.loading(theme: viewModel.theme.value);
        } else {
          child = ReaderContentView(
            battery: viewModel.battery.value,
            contentText: pageData.content,
            headerText: pageData.header,
            pageProgressText: pageData.footer,
            theme: viewModel.theme.value,
            isFirstPage: pageData.isFirstPage,
          );
        }
        return GestureDetector(
          onTapUp: viewModel.turnPage,
          child: child,
        );
      },
      itemCount: viewModel.pageCount.value,
      onPageChanged: viewModel.handlePageChanged,
      physics: physics,
    );
  }
}
