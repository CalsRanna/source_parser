import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/catalogue_list_view.dart';
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
  final viewModel = GetIt.instance.get<CatalogueViewModel>();

  @override
  Widget build(BuildContext context) {
    final iconButton = Watch(
      (_) => TextButton(
        onPressed: viewModel.updatePosition,
        child: Text(viewModel.position.value),
      ),
    );
    final appBar = AppBar(
      actions: [iconButton],
      title: const Text(StringConfig.catalogue),
    );
    return Scaffold(appBar: appBar, body: Watch(_buildBody));
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals(book: widget.book, chapters: widget.chapters);
  }

  Widget _buildBody(BuildContext context) {
    return CatalogueListView(
      globalKey: viewModel.listKey,
      itemCount: viewModel.chapters.value.length,
      initialIndex: viewModel.book.value.chapterIndex,
      getTitle: (index) => viewModel.chapters.value[index].name,
      isCached: (index) => viewModel.checkChapter(index),
      onTap: (index) => viewModel.navigateReaderPage(context, index),
      onRefresh: viewModel.refreshChapters,
    );
  }
}
