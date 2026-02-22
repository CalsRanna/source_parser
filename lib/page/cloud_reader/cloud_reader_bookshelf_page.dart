import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_bookshelf_view_model.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';

@RoutePage()
class CloudReaderBookshelfPage extends StatefulWidget {
  const CloudReaderBookshelfPage({super.key});

  @override
  State<CloudReaderBookshelfPage> createState() =>
      _CloudReaderBookshelfPageState();
}

class _CloudReaderBookshelfPageState extends State<CloudReaderBookshelfPage> {
  final viewModel = GetIt.instance.get<CloudReaderBookshelfViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('云阅读'),
          actions: [
            IconButton(
              icon: const Icon(HugeIcons.strokeRoundedSearch01),
              onPressed: () => viewModel.openSearch(context),
            ),
            IconButton(
              icon: const Icon(HugeIcons.strokeRoundedSettings01),
              onPressed: () => viewModel.openSetting(context),
            ),
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(HugeIcons.strokeRoundedCancel01)),
        ),
        body: Watch((context) {
          if (viewModel.isLoading.value && viewModel.books.value.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error.value.isNotEmpty &&
              viewModel.books.value.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(viewModel.error.value),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () => viewModel.refreshBooks(),
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: viewModel.refreshBooks,
            child: ListView.builder(
              itemBuilder: (context, index) => _buildBookTile(context, index),
              itemCount: viewModel.books.value.length,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBookTile(BuildContext context, int index) {
    var book = viewModel.books.value[index];
    var coverUrl = CloudReaderApiClient().getCoverUrl(book.coverUrl);
    Widget leading;
    if (coverUrl.isNotEmpty) {
      leading = ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: coverUrl,
          width: 40,
          height: 56,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => Container(
            width: 40,
            height: 56,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(HugeIcons.strokeRoundedBook02, size: 20),
          ),
        ),
      );
    } else {
      leading = Container(
        width: 40,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(HugeIcons.strokeRoundedBook02, size: 20),
      );
    }
    var progress = '';
    if (book.totalChapterNum > 0) {
      progress = '${book.durChapterIndex + 1}/${book.totalChapterNum}';
    }
    return ListTile(
      leading: leading,
      title: Text(book.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${book.author}  $progress',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        book.durChapterTitle,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => viewModel.openReader(context, index),
      onLongPress: () => _showDeleteDialog(context, index),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除书籍'),
        content: Text('确定要从书架中删除《${viewModel.books.value[index].name}》吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteBook(index);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
