import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
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
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    viewModel.loadChapters(widget.bookUrl, widget.currentIndex).then((_) {
      _scrollToCurrentChapter();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentChapter() {
    if (viewModel.chapters.value.isEmpty) return;
    var index = widget.currentIndex;
    if (index < viewModel.chapters.value.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) return;
        var offset = index * 48.0;
        var maxScroll = scrollController.position.maxScrollExtent;
        scrollController.jumpTo(offset.clamp(0, maxScroll));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('目录')),
      body: Watch((context) {
        if (viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          controller: scrollController,
          itemBuilder: (context, index) {
            var chapter = viewModel.chapters.value[index];
            var isCurrent = index == viewModel.currentIndex.value;
            return ListTile(
              title: Text(
                chapter.title,
                style: TextStyle(
                  color: isCurrent
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  fontWeight: isCurrent ? FontWeight.bold : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              dense: true,
              onTap: () => Navigator.pop(context, index),
            );
          },
          itemCount: viewModel.chapters.value.length,
        );
      }),
    );
  }
}
