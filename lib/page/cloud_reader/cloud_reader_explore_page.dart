import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/cloud_explore_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_explore_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';

@RoutePage()
class CloudReaderExplorePage extends StatefulWidget {
  const CloudReaderExplorePage({super.key});

  @override
  State<CloudReaderExplorePage> createState() => _CloudReaderExplorePageState();
}

class _CloudReaderExplorePageState extends State<CloudReaderExplorePage> {
  final viewModel = GetIt.instance.get<CloudReaderExploreViewModel>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    viewModel.loadSources();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('书海'),
        actions: [
          _buildSourceSelector(),
        ],
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
                  onPressed: () => viewModel.loadSources(),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            _buildCategoryTabs(),
            Expanded(child: _buildBookGrid()),
          ],
        );
      }),
    );
  }

  Widget _buildSourceSelector() {
    return Watch((context) {
      final sources = viewModel.sources.value;
      if (sources.isEmpty) return const SizedBox();
      return MenuAnchor(
        alignmentOffset: const Offset(-100, 12),
        builder: (_, controller, __) => IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(HugeIcons.strokeRoundedFilter),
        ),
        menuChildren: sources.map((source) {
          final isSelected =
              viewModel.selectedSource.value?.bookSourceUrl ==
                  source.bookSourceUrl;
          return MenuItemButton(
            onPressed: () => viewModel.selectSource(source),
            trailingIcon: isSelected
                ? const Icon(HugeIcons.strokeRoundedTick02)
                : null,
            child: Text(source.bookSourceName),
          );
        }).toList(),
      );
    });
  }

  Widget _buildCategoryTabs() {
    return Watch((context) {
      final source = viewModel.selectedSource.value;
      if (source == null) return const SizedBox();
      final categories = source.exploreCategories;
      if (categories.isEmpty) return const SizedBox();

      return SizedBox(
        height: 48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Watch((context) {
              final isSelected =
                  viewModel.selectedCategory.value?.url == category.url;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(category.title),
                  selected: isSelected,
                  onSelected: (_) => viewModel.selectCategory(category),
                ),
              );
            });
          },
        ),
      );
    });
  }

  Widget _buildBookGrid() {
    return Watch((context) {
      final books = viewModel.books.value;
      if (books.isEmpty) {
        return const Center(child: Text('暂无书籍'));
      }
      return GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
        ),
        itemCount: books.length + (viewModel.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == books.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return _BookGridTile(book: books[index]);
        },
      );
    });
  }
}

class _BookGridTile extends StatelessWidget {
  final CloudExploreBook book;

  const _BookGridTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final coverUrl = CloudReaderApiClient().getCoverUrl(book.coverUrl);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _openBookInfo(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: coverUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: coverUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: const Icon(
                          HugeIcons.strokeRoundedBook02,
                          size: 32,
                        ),
                      ),
                    )
                  : Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: const Icon(
                        HugeIcons.strokeRoundedBook02,
                        size: 32,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _openBookInfo(BuildContext context) {
    final searchBook = book.toSearchBook();
    CloudReaderBookInfoRoute(book: searchBook).push(context);
  }
}
