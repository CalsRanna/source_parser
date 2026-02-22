import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/cloud_search_book_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_search_view_model.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class CloudReaderBookInfoPage extends StatelessWidget {
  final CloudSearchBookEntity book;

  const CloudReaderBookInfoPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.name)),
      body: ListView(
        children: [
          _buildHeader(context),
          _buildInfo(context),
          if (book.intro.isNotEmpty) _buildIntro(context),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    var coverUrl = CloudReaderApiClient().getCoverUrl(book.coverUrl);
    Widget cover;
    if (coverUrl.isNotEmpty) {
      cover = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: coverUrl,
          width: 90,
          height: 120,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => Container(
            width: 90,
            height: 120,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(HugeIcons.strokeRoundedBook02, size: 32),
          ),
        ),
      );
    } else {
      cover = Container(
        width: 90,
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(HugeIcons.strokeRoundedBook02, size: 32),
      );
    }
    var meta = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(book.author, style: Theme.of(context).textTheme.bodyMedium),
        if (book.kind.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            book.kind,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (book.originName.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '来源: ${book.originName}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [cover, const SizedBox(width: 16), Expanded(child: meta)],
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    var children = <Widget>[];
    if (book.latestChapterTitle.isNotEmpty) {
      children.add(ListTile(
        leading: const Icon(HugeIcons.strokeRoundedBook02),
        title: const Text('最新章节'),
        subtitle: Text(
          book.latestChapterTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ));
    }
    if (book.wordCount.isNotEmpty) {
      children.add(ListTile(
        leading: const Icon(HugeIcons.strokeRoundedTextFont),
        title: const Text('字数'),
        subtitle: Text(book.wordCount),
      ));
    }
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(children: children);
  }

  Widget _buildIntro(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('简介', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            book.intro,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: FilledButton.icon(
          onPressed: () => _addToShelf(context),
          icon: const Icon(HugeIcons.strokeRoundedAdd01),
          label: const Text('加入书架'),
        ),
      ),
    );
  }

  void _addToShelf(BuildContext context) async {
    var viewModel = GetIt.instance.get<CloudReaderSearchViewModel>();
    var success = await viewModel.addToShelf(book);
    if (!context.mounted) return;
    if (success) {
      DialogUtil.snackBar('已加入书架');
      Navigator.pop(context, true);
    } else {
      DialogUtil.snackBar('加入书架失败');
    }
  }
}
