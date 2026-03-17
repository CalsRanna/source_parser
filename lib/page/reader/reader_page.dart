import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/reader/layout/reader_layout_config.dart';
import 'package:source_parser/component/reader/reader_view.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/reader/reader_cache_indicator_view.dart';
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
        _buildSelectionEntryOverlay(),
        _buildSelectionOverlay(),
        _buildReaderCacheIndicator(),
      ];
      return Stack(children: children);
    });
  }

  @override
  void deactivate() {
    viewModel.syncBookshelf();
    viewModel.controller.showUiOverlays();
    super.deactivate();
  }

  @override
  void dispose() {
    viewModel.controller.pageTurnController.dispose();
    viewModel.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initSignals();
      viewModel.controller.hideUiOverlays();
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
    final c = viewModel.controller;
    if (c.isSelectionMode.value || !c.showOverlay.value) {
      return const SizedBox();
    }
    return ReaderOverlayView(
      book: widget.book,
      isDarkMode: c.isDarkMode.value,
      onBarrierTap: c.hideUiOverlays,
      onCached: (amount) => viewModel.downloadChapters(context, amount),
      onCatalogue: () => viewModel.navigateCataloguePage(context),
      onDarkMode: () => c.toggleDarkMode(),
      onNext: c.nextChapter,
      onPrevious: c.previousChapter,
      onAvailableSource: () => viewModel.navigateAvailableSourcePage(context),
      onRefresh: c.forceRefresh,
      onReplacement: () => viewModel.navigateReplacementPage(context),
    );
  }

  Widget _buildReaderView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final c = viewModel.controller;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          c.updateLayoutConfig(
            ReaderLayoutConfig(
              locale: Localizations.maybeLocaleOf(context),
              textDirection: Directionality.of(context),
              textHeightBehavior: DefaultTextHeightBehavior.maybeOf(context),
              textScaleFactor: MediaQuery.textScalerOf(context).scale(1),
            ),
          );
          c.updateViewportSize(constraints.biggest);
        });
        return Watch((context) {
          var error = c.error.value;
          return ReaderView(
            errorText: error.isNotEmpty ? error : null,
            isLoading: c.currentChapterLayout.value.isEmpty,
            battery: c.battery.value,
            eInkMode: c.eInkMode.value,
            renderConfig: c.renderConfig,
            selectionEnabled: c.isSelectionMode.value,
            pageTurnMode: c.pageTurnMode.value,
            pageCount: c.pageCount.value,
            controller: c.pageTurnController,
            onLongPress: c.enterSelectionMode,
            onTapUp: c.turnPage,
            getPageData: c.getPageData,
          );
        });
      },
    );
  }

  Widget _buildSelectionOverlay() {
    final c = viewModel.controller;
    if (!c.isSelectionMode.value) return const SizedBox();
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.tonalIcon(
            onPressed: c.exitSelectionMode,
            icon: const Icon(Icons.check),
            label: const Text(StringConfig.exitSelection),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionEntryOverlay() {
    final c = viewModel.controller;
    if (c.isSelectionMode.value || !c.showOverlay.value) {
      return const SizedBox();
    }
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.tonalIcon(
            onPressed: c.enterSelectionMode,
            icon: const Icon(Icons.select_all),
            label: const Text(StringConfig.enterSelection),
          ),
        ),
      ),
    );
  }
}
