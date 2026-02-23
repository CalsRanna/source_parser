import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_reader_view_model.dart';
import 'package:source_parser/page/reader/reader_content_view.dart';
import 'package:source_parser/page/reader/reader_overlay_dark_mode_slot.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';
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
  final sourceParserViewModel = GetIt.instance.get<SourceParserViewModel>();
  final layoutViewModel = GetIt.instance.get<LayoutViewModel>();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      var children = [
        _buildReaderView(),
        _buildOverlay(),
      ];
      return Stack(children: children);
    });
  }

  @override
  void deactivate() {
    viewModel.syncProgress();
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
      layoutViewModel.initSignals();
      viewModel.initSignals();
      viewModel.hideUiOverlays();
    });
  }

  Widget _buildReaderView() {
    ScrollPhysics? physics;
    if (viewModel.eInkMode.value || viewModel.turningMode.value & 1 == 0) {
      physics = const NeverScrollableScrollPhysics();
    }
    if (viewModel.error.value.isNotEmpty) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: viewModel.turnPage,
        child: IgnorePointer(
          child: ReaderContentView.error(
            errorText: viewModel.error.value,
            theme: viewModel.theme.value,
          ),
        ),
      );
    }
    if (viewModel.currentChapterPages.value.isEmpty) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: viewModel.turnPage,
        child: IgnorePointer(
          child: ReaderContentView.loading(theme: viewModel.theme.value),
        ),
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
          behavior: HitTestBehavior.opaque,
          onTapUp: viewModel.turnPage,
          child: IgnorePointer(child: child),
        );
      },
      itemCount: viewModel.pageCount.value,
      onPageChanged: viewModel.handlePageChanged,
      physics: physics,
    );
  }

  Widget _buildOverlay() {
    if (!viewModel.showOverlay.value) return const SizedBox();
    return _CloudReaderOverlayView(
      book: widget.book,
      isDarkMode: viewModel.isDarkMode.value,
      onBarrierTap: viewModel.hideUiOverlays,
      onCatalogue: () => viewModel.navigateCataloguePage(context),
      onDarkMode: () => viewModel.toggleDarkMode(),
      onNext: viewModel.nextChapter,
      onPrevious: viewModel.previousChapter,
      onSource: () => viewModel.navigateSourcePage(context),
      onRefresh: viewModel.forceRefresh,
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
