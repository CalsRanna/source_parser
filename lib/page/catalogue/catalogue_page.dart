import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/page/catalogue/catalogue_view_model.dart';

@RoutePage()
class CataloguePage extends StatefulWidget {
  final BookEntity book;
  final List<ChapterEntity>? chapters;

  const CataloguePage({super.key, required this.book, this.chapters});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  final viewModel = GetIt.instance<CatalogueViewModel>();

  @override
  Widget build(BuildContext context) {
    final iconButton = Watch(
      (_) => TextButton(
        onPressed: viewModel.updatePosition,
        child: Text(viewModel.position.value),
      ),
    );
    final appBar = AppBar(
      key: viewModel.appBarKey,
      actions: [iconButton],
      title: const Text(StringConfig.catalogue),
    );
    return Scaffold(appBar: appBar, body: Watch(_buildBody));
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals(book: widget.book, chapters: widget.chapters);
    viewModel.initController(context);
  }

  Widget _buildBody(BuildContext context) {
    final listView = ListView.builder(
      controller: viewModel.controller,
      itemBuilder: (_, index) => _itemBuilder(index),
      itemCount: viewModel.chapters.value.length,
      itemExtent: 56,
    );
    final easyRefresh = EasyRefresh(
      onRefresh: () => viewModel.refreshChapters(),
      child: listView,
    );
    return Scrollbar(controller: viewModel.controller, child: easyRefresh);
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
