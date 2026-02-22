import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_search_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/util/dialog_util.dart';

@RoutePage()
class CloudReaderSearchPage extends StatefulWidget {
  const CloudReaderSearchPage({super.key});

  @override
  State<CloudReaderSearchPage> createState() => _CloudReaderSearchPageState();
}

class _CloudReaderSearchPageState extends State<CloudReaderSearchPage> {
  final viewModel = GetIt.instance.get<CloudReaderSearchViewModel>();
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: '搜索书籍',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) => viewModel.search(value),
        ),
        actions: [
          IconButton(
            icon: const Icon(HugeIcons.strokeRoundedSearch01),
            onPressed: () => viewModel.search(searchController.text),
          ),
        ],
      ),
      body: Watch((context) {
        if (viewModel.isSearching.value && viewModel.results.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (viewModel.results.value.isEmpty) {
          return const Center(child: Text('输入关键词搜索书籍'));
        }
        return ListView.builder(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index == viewModel.results.value.length) {
              return viewModel.isSearching.value
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox();
            }
            return _buildResultTile(context, index);
          },
          itemCount: viewModel.results.value.length + 1,
        );
      }),
    );
  }

  Widget _buildResultTile(BuildContext context, int index) {
    var book = viewModel.results.value[index];
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
    return ListTile(
      leading: leading,
      title: Text(book.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${book.author} - ${book.originName}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(HugeIcons.strokeRoundedAdd01),
        onPressed: () async {
          var success = await viewModel.addToShelf(book);
          if (!context.mounted) return;
          DialogUtil.snackBar(success ? '已加入书架' : '加入书架失败');
        },
      ),
      onTap: () => CloudReaderBookInfoRoute(book: book).push(context),
    );
  }
}
