import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/reader/layout/reader_layout_config.dart';
import 'package:source_parser/component/reader/reader_overlay_dark_mode_slot.dart';
import 'package:source_parser/component/reader/reader_view.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_reader_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/layout.dart';
import 'package:source_parser/view_model/layout_view_model.dart';

@RoutePage()
class CloudReaderReaderPage extends StatefulWidget {
  final CloudBookEntity book;
  const CloudReaderReaderPage({super.key, required this.book});

  @override
  State<CloudReaderReaderPage> createState() => _CloudReaderReaderPageState();
}

class _CloudReaderReaderPageState extends State<CloudReaderReaderPage> {
  late final viewModel = GetIt.instance.get<CloudReaderReaderViewModel>(
    param1: widget.book,
  );
  final layoutViewModel = GetIt.instance.get<LayoutViewModel>();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      var children = [
        _buildReaderView(),
        _buildOverlay(),
        _buildSelectionEntryOverlay(),
        _buildSelectionOverlay(),
      ];
      return Stack(children: children);
    });
  }

  @override
  void deactivate() {
    viewModel.syncProgress();
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
      layoutViewModel.initSignals();
      viewModel.initSignals();
      viewModel.controller.hideUiOverlays();
    });
  }

  Widget _buildOverlay() {
    final c = viewModel.controller;
    if (c.isSelectionMode.value || !c.showOverlay.value) {
      return const SizedBox();
    }
    return _CloudReaderOverlayView(
      book: widget.book,
      isDarkMode: c.isDarkMode.value,
      onBarrierTap: c.hideUiOverlays,
      onCatalogue: () => viewModel.navigateCataloguePage(context),
      onDarkMode: () => c.toggleDarkMode(),
      onNext: c.nextChapter,
      onPrevious: c.previousChapter,
      onSource: () => viewModel.navigateSourcePage(context),
      onRefresh: c.forceRefresh,
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

class _CloudReaderOverlayView extends StatelessWidget {
  final CloudBookEntity book;
  final bool isDarkMode;
  final VoidCallback? onBarrierTap;
  final VoidCallback? onCatalogue;
  final VoidCallback? onDarkMode;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onSource;
  final VoidCallback? onRefresh;

  const _CloudReaderOverlayView({
    required this.book,
    required this.isDarkMode,
    this.onBarrierTap,
    this.onCatalogue,
    this.onDarkMode,
    this.onNext,
    this.onPrevious,
    this.onSource,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final layoutViewModel = GetIt.instance.get<LayoutViewModel>();
    return Watch((context) {
      final layout = layoutViewModel.layout.value;
      if (layout.slot0.isEmpty) return const SizedBox();
      var barrier = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onBarrierTap,
        child: SizedBox(height: double.infinity, width: double.infinity),
      );
      return Scaffold(
        appBar: _buildAppBar(layout),
        backgroundColor: Colors.transparent,
        body: barrier,
        bottomNavigationBar: _buildBottomBar(layout),
        floatingActionButton: _buildFloatingButton(layout),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      );
    });
  }

  void handleTap(String slot) {
    if (slot == LayoutSlot.catalogue.name) return onCatalogue?.call();
    if (slot == LayoutSlot.forceRefresh.name) return onRefresh?.call();
    if (slot == LayoutSlot.nextChapter.name) return onNext?.call();
    if (slot == LayoutSlot.previousChapter.name) return onPrevious?.call();
    if (slot == LayoutSlot.source.name) return onSource?.call();
    if (slot == LayoutSlot.darkMode.name) return onDarkMode?.call();
  }

  AppBar _buildAppBar(Layout layout) {
    return AppBar(
      actions: [_buildSlot(layout.slot0), _buildSlot(layout.slot1)],
      title: Text(book.name),
    );
  }

  Widget _buildBottomBar(Layout layout) {
    var children = [
      _buildSlot(layout.slot2),
      _buildSlot(layout.slot3),
      _buildSlot(layout.slot4),
      _buildSlot(layout.slot5),
    ];
    return BottomAppBar(child: Row(children: children));
  }

  Widget _buildFloatingButton(Layout layout) {
    return FloatingActionButton(
      onPressed: () => handleTap(layout.slot6),
      child: Icon(_getIconData(layout.slot6)),
    );
  }

  Widget _buildSlot(String slot) {
    if (slot.isEmpty) return const SizedBox();
    if (slot == LayoutSlot.darkMode.name) {
      return ReaderOverlayDarkModeSlot(
        isDarkMode: isDarkMode,
        onTap: onDarkMode,
      );
    }
    if (slot == LayoutSlot.theme.name) {
      return Builder(builder: (context) {
        return IconButton(
          onPressed: () => ReaderThemeRoute().push(context),
          icon: Icon(_getIconData(slot)),
        );
      });
    }
    if (slot == LayoutSlot.source.name) {
      return IconButton(
        onPressed: onSource,
        icon: Icon(_getIconData(slot)),
        tooltip: StringConfig.changeSource,
      );
    }
    return IconButton(
      onPressed: () => handleTap(slot),
      icon: Icon(_getIconData(slot)),
    );
  }

  IconData _getIconData(String slot) {
    var values = LayoutSlot.values;
    var layoutSlot = values.firstWhere(
      (value) => value.name == slot,
      orElse: () => LayoutSlot.more,
    );
    return switch (layoutSlot) {
      LayoutSlot.audio => HugeIcons.strokeRoundedHeadphones,
      LayoutSlot.cache => HugeIcons.strokeRoundedDownload04,
      LayoutSlot.catalogue => HugeIcons.strokeRoundedMenu01,
      LayoutSlot.darkMode => HugeIcons.strokeRoundedMoon02,
      LayoutSlot.forceRefresh => HugeIcons.strokeRoundedRefresh,
      LayoutSlot.information => HugeIcons.strokeRoundedBook01,
      LayoutSlot.more => HugeIcons.strokeRoundedMoreVertical,
      LayoutSlot.nextChapter => HugeIcons.strokeRoundedNext,
      LayoutSlot.previousChapter => HugeIcons.strokeRoundedPrevious,
      LayoutSlot.source => HugeIcons.strokeRoundedExchange01,
      LayoutSlot.theme => HugeIcons.strokeRoundedTextFont,
      LayoutSlot.replacement => HugeIcons.strokeRoundedSearchReplace,
    };
  }
}
