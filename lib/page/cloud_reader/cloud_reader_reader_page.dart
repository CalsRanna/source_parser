import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_reader_view_model.dart';
import 'package:source_parser/page/reader/reader_content_view.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';
import 'package:source_parser/router/router.gr.dart';

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
      key: ValueKey(viewModel.theme.value),
      controller: viewModel.controller,
      itemBuilder: (context, index) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: viewModel.turnPage,
        child: IgnorePointer(
          child: ReaderContentView(
            battery: viewModel.battery.value,
            contentText: viewModel.currentChapterPages.value[index],
            headerText: viewModel.getHeaderText(index),
            pageProgressText: viewModel.getFooterText(index),
            theme: viewModel.theme.value,
            isFirstPage: index == 0,
          ),
        ),
      ),
      itemCount: viewModel.currentChapterPages.value.length,
      onPageChanged: viewModel.updatePageIndex,
      physics: physics,
    );
  }

  Widget _buildOverlay() {
    if (!viewModel.showOverlay.value) return const SizedBox();
    return _CloudReaderOverlayView(
      bookName: widget.book.name,
      isDarkMode: viewModel.isDarkMode.value,
      onBarrierTap: viewModel.hideUiOverlays,
      onCatalogue: () => viewModel.navigateCataloguePage(context),
      onDarkMode: () => viewModel.toggleDarkMode(),
      onNext: viewModel.nextChapter,
      onPrevious: viewModel.previousChapter,
      onSource: () => viewModel.navigateSourcePage(context),
      onRefresh: viewModel.forceRefresh,
      onTheme: () => ReaderThemeRoute().push(context),
    );
  }
}

class _CloudReaderOverlayView extends StatelessWidget {
  final String bookName;
  final bool isDarkMode;
  final VoidCallback? onBarrierTap;
  final VoidCallback? onCatalogue;
  final VoidCallback? onDarkMode;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onSource;
  final VoidCallback? onRefresh;
  final VoidCallback? onTheme;

  const _CloudReaderOverlayView({
    required this.bookName,
    required this.isDarkMode,
    this.onBarrierTap,
    this.onCatalogue,
    this.onDarkMode,
    this.onNext,
    this.onPrevious,
    this.onSource,
    this.onRefresh,
    this.onTheme,
  });

  @override
  Widget build(BuildContext context) {
    var barrier = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onBarrierTap,
      child: const SizedBox(height: double.infinity, width: double.infinity),
    );
    return Scaffold(
      appBar: AppBar(title: Text(bookName)),
      backgroundColor: Colors.transparent,
      body: barrier,
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: onRefresh,
        child: const Icon(HugeIcons.strokeRoundedRefresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  Widget _buildBottomBar() {
    var children = [
      IconButton(
        onPressed: onCatalogue,
        icon: const Icon(HugeIcons.strokeRoundedMenu01),
        tooltip: '目录',
      ),
      IconButton(
        onPressed: onSource,
        icon: const Icon(HugeIcons.strokeRoundedExchange01),
        tooltip: '换源',
      ),
      IconButton(
        onPressed: onDarkMode,
        icon: Icon(
          isDarkMode
              ? HugeIcons.strokeRoundedSun01
              : HugeIcons.strokeRoundedMoon02,
        ),
        tooltip: '夜间模式',
      ),
      IconButton(
        onPressed: onTheme,
        icon: const Icon(HugeIcons.strokeRoundedTextFont),
        tooltip: '主题',
      ),
    ];
    return BottomAppBar(child: Row(children: children));
  }
}
