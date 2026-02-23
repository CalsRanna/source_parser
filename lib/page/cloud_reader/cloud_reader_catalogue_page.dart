import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/catalogue_list_view.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_catalogue_view_model.dart';

@RoutePage()
class CloudReaderCataloguePage extends StatefulWidget {
  final String bookUrl;
  final int currentIndex;

  const CloudReaderCataloguePage({
    super.key,
    required this.bookUrl,
    required this.currentIndex,
  });

  @override
  State<CloudReaderCataloguePage> createState() =>
      _CloudReaderCataloguePageState();
}

class _CloudReaderCataloguePageState extends State<CloudReaderCataloguePage> {
  final viewModel = GetIt.instance.get<CloudReaderCatalogueViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.loadChapters(widget.bookUrl, widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('目录')),
      body: Watch((context) {
        if (viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return CatalogueListView(
          itemCount: viewModel.chapters.value.length,
          initialIndex: viewModel.currentIndex.value,
          getTitle: (index) => viewModel.chapters.value[index].title,
          onTap: (index) => Navigator.of(context).pop(index),
        );
      }),
    );
  }
}
