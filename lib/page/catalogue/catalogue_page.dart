import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/page/catalogue/catalogue_view_model.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/util/message.dart';

@RoutePage()
class CataloguePage extends StatefulWidget {
  final BookEntity book;

  const CataloguePage({super.key, required this.book});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  bool atTop = true;
  late ScrollController controller;
  GlobalKey globalKey = GlobalKey();

  late final viewModel = GetIt.instance<CatalogueViewModel>(
    param1: widget.book,
  );

  @override
  Widget build(BuildContext context) {
    final iconButton = IconButton(
      icon: Icon(HugeIcons.strokeRoundedArrowDataTransferVertical),
      onPressed: handlePressed,
    );
    final appBar = AppBar(
      key: globalKey,
      title: const Text('目录'),
      actions: [iconButton],
    );
    return Scaffold(appBar: appBar, body: Watch(_buildBody));
  }

  Widget _buildBody(BuildContext context) {
    final listView = ListView.builder(
      controller: controller,
      itemBuilder: (_, index) => _itemBuilder(index),
      itemCount: viewModel.chapters.value.length,
      itemExtent: 56,
    );
    final easyRefresh = EasyRefresh(
      onRefresh: () => viewModel.refreshChapters(),
      child: listView,
    );
    return Scrollbar(controller: controller, child: easyRefresh);
  }

  void handlePressed() {
    var position = controller.position.maxScrollExtent;
    if (!atTop) {
      position = controller.position.minScrollExtent;
    }
    controller.animateTo(
      position,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 200),
    );
    setState(() {
      atTop = !atTop;
    });
  }

  Future<void> handleRefresh(WidgetRef ref) async {
    final message = Message.of(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    try {
      await notifier.refreshCatalogue();
    } catch (error) {
      message.show(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final height = MediaQuery.of(context).size.height;
      final padding = MediaQuery.of(context).padding;
      final maxScrollExtent = controller.position.maxScrollExtent;
      final appBarContext = globalKey.currentContext;
      final appBarRenderBox = appBarContext!.findRenderObject() as RenderBox;
      var listViewHeight = height - padding.vertical;
      listViewHeight = listViewHeight - appBarRenderBox.size.height;
      final halfHeight = listViewHeight / 2;
      var offset = 56.0 * widget.book.chapterIndex;
      offset = (offset - halfHeight);
      if (maxScrollExtent > 0) {
        offset = offset.clamp(0, maxScrollExtent);
      }
      controller.jumpTo(offset);
    });
  }

  Widget _itemBuilder(int index) {
    final chapter = viewModel.chapters.value.elementAt(index);
    final isActive = viewModel.isActive(index);
    final future = viewModel.checkChapter(index);
    return FutureBuilder(
      builder: (_, snapshot) => _Tile(
        chapter,
        isActive: isActive,
        isCached: snapshot.data ?? false,
        onTap: () => viewModel.navigateReaderPage(context, index),
      ),
      future: future,
    );
  }
}

class _Tile extends StatelessWidget {
  final ChapterEntity chapter;
  final bool isActive;
  final bool isCached;
  final void Function()? onTap;

  const _Tile(
    this.chapter, {
    this.isActive = false,
    this.isCached = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor(context);
    final weight = _getFontWeight();
    final textStyle = TextStyle(color: color, fontWeight: weight);
    final title = Text(
      chapter.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
    return ListTile(title: title, onTap: onTap);
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (isActive) return colorScheme.primary;
    if (isCached) return colorScheme.onSurface;
    return colorScheme.onSurface.withValues(alpha: 0.5);
  }

  FontWeight _getFontWeight() {
    if (isActive) return FontWeight.bold;
    return FontWeight.normal;
  }
}
