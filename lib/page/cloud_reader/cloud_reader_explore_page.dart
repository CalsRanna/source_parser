import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/cloud_explore_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_explore_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/widget/book_cover.dart';

@RoutePage()
class CloudReaderExplorePage extends StatefulWidget {
  const CloudReaderExplorePage({super.key});

  @override
  State<CloudReaderExplorePage> createState() => _CloudReaderExplorePageState();
}

class _CloudReaderExplorePageState extends State<CloudReaderExplorePage> {
  final viewModel = GetIt.instance.get<CloudReaderExploreViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.loadSources();
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
        if (viewModel.isLoading.value && viewModel.results.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (viewModel.error.value.isNotEmpty &&
            viewModel.results.value.isEmpty) {
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
        return _buildBody();
      }),
    );
  }

  Widget _buildSourceSelector() {
    return Watch((context) {
      final sources = viewModel.sources.value;
      if (sources.isEmpty) return const SizedBox();
      return IconButton(
        onPressed: () => _showSourceBottomSheet(context, sources),
        icon: const Icon(HugeIcons.strokeRoundedFilter),
      );
    });
  }

  void _showSourceBottomSheet(
    BuildContext context,
    List<CloudExploreSource> sources,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '选择书源',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sources.length,
                  itemBuilder: (context, index) {
                    final source = sources[index];
                    final isSelected =
                        viewModel.selectedSource.value?.bookSourceUrl ==
                            source.bookSourceUrl;
                    return ListTile(
                      title: Text(source.bookSourceName),
                      trailing: isSelected
                          ? const Icon(HugeIcons.strokeRoundedTick02)
                          : null,
                      onTap: () {
                        Navigator.of(context).pop();
                        viewModel.selectSource(source);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    final results = viewModel.results.value;
    if (results.isEmpty) return const Center(child: Text('暂无书籍'));
    final listView = ListView.separated(
      itemBuilder: (context, index) => _itemBuilder(results[index]),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
    return EasyRefresh(
      onRefresh: () => viewModel.loadAllCategories(),
      child: listView,
    );
  }

  Widget _itemBuilder(CloudExploreResult result) {
    return switch (result.layout) {
      'banner' => _Banner(
          key: ValueKey(result.title),
          books: result.books,
        ),
      'card' => _List(
          key: ValueKey(result.title),
          books: result.books,
          title: result.title,
        ),
      'grid' => _Grid(
          key: ValueKey(result.title),
          books: result.books,
          title: result.title,
        ),
      _ => const SizedBox(),
    };
  }
}

class _Banner extends StatefulWidget {
  final List<CloudExploreBook> books;

  const _Banner({super.key, required this.books});

  @override
  State<_Banner> createState() => _BannerState();
}

class _BannerState extends State<_Banner> {
  List<CloudExploreBook> books = [];
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    final itemCount = min(widget.books.length, 3);
    if (itemCount == 0) return;
    final limitedBooks = widget.books.sublist(0, itemCount);
    books = [
      widget.books[itemCount - 1],
      ...limitedBooks,
      widget.books[0],
    ];
    controller.addListener(() {
      if (controller.page == 0) {
        controller.jumpToPage(books.length - 2);
      }
      if (controller.page == books.length - 1) {
        controller.jumpToPage(1);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.jumpToPage(1);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: controller,
        itemBuilder: (_, index) => _BannerTile(book: books[index]),
        itemCount: books.length,
      ),
    );
  }
}

class _BannerTile extends StatelessWidget {
  final CloudExploreBook book;

  const _BannerTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final coverUrl = CloudReaderApiClient().getCoverUrl(book.coverUrl);
    final placeholder = Image.asset(
      'asset/image/default_cover.jpg',
      fit: BoxFit.cover,
    );
    final child = coverUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              coverUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: placeholder,
          );
    return GestureDetector(
      onTap: () => _openBookInfo(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }

  void _openBookInfo(BuildContext context) {
    final searchBook = book.toSearchBook();
    CloudReaderBookInfoRoute(book: searchBook).push(context);
  }
}

class _List extends StatelessWidget {
  final List<CloudExploreBook> books;
  final String title;

  const _List({super.key, required this.books, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final itemCount = min(books.length, 3);
    List<Widget> tiles = [];
    for (var i = 0; i < itemCount; i++) {
      tiles.add(_ListTile(book: books[i]));
      if (i < itemCount - 1) {
        tiles.add(const SizedBox(height: 8));
      }
    }
    final titleStyle = textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final boxShadow = BoxShadow(
      blurRadius: 16,
      color: colorScheme.shadow.withValues(alpha: 0.05),
      offset: const Offset(8, 8),
    );
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [boxShadow],
      color: colorScheme.surface,
    );
    return Container(
      decoration: boxDecoration,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Text(title, style: titleStyle),
            const Spacer(),
          ]),
          const SizedBox(height: 8),
          ...tiles,
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final CloudExploreBook book;

  const _ListTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final coverUrl = CloudReaderApiClient().getCoverUrl(book.coverUrl);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final title = Text(
      book.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    );
    final introduction = Text(
      book.intro.replaceAll(RegExp(r'\s'), ''),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium?.copyWith(
        color: onSurface.withValues(alpha: 0.75),
      ),
    );
    final subtitle = Text(
      _buildSubtitle() ?? '',
      style: textTheme.bodySmall?.copyWith(
        color: onSurface.withValues(alpha: 0.5),
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openBookInfo(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(height: 80, url: coverUrl, width: 60),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const Spacer(),
                  introduction,
                  const Spacer(),
                  subtitle,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBookInfo(BuildContext context) {
    final searchBook = book.toSearchBook();
    CloudReaderBookInfoRoute(book: searchBook).push(context);
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (book.author.isNotEmpty) spans.add(book.author);
    if (book.kind.isNotEmpty) spans.add(book.kind);
    if (book.wordCount.isNotEmpty) spans.add(book.wordCount);
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}

class _Grid extends StatelessWidget {
  final List<CloudExploreBook> books;
  final String title;

  const _Grid({super.key, required this.books, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final itemCount = min(books.length, 4);
    final mediaQueryData = MediaQuery.of(context);
    final width = mediaQueryData.size.width;
    final widthPerBookCover = ((width - 16 * 4 - 8 * 3) / 4);
    final heightPerBookCover = widthPerBookCover * 4 / 3;
    const heightPerBookName = 14 * 1.2 * 2;
    const heightPerBookSpan = 12 * 1.2;
    double heightPerBook = 0;
    heightPerBook += heightPerBookCover;
    heightPerBook += heightPerBookName;
    heightPerBook += 8;
    heightPerBook += heightPerBookSpan;
    heightPerBook += 8;
    final titleStyle = textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: widthPerBookCover / heightPerBook,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
    );
    final gridView = GridView.custom(
      gridDelegate: delegate,
      childrenDelegate: SliverChildBuilderDelegate(
        (_, index) => _GridTile(book: books[index]),
        childCount: itemCount,
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
    final boxShadow = BoxShadow(
      blurRadius: 16,
      color: colorScheme.shadow.withValues(alpha: 0.05),
      offset: const Offset(8, 8),
    );
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [boxShadow],
      color: colorScheme.surface,
    );
    return Container(
      decoration: boxDecoration,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Text(title, style: titleStyle),
            const Spacer(),
          ]),
          const SizedBox(height: 8),
          SizedBox(height: heightPerBook + 1, child: gridView),
        ],
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  final CloudExploreBook book;

  const _GridTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final coverUrl = CloudReaderApiClient().getCoverUrl(book.coverUrl);
    final mediaQueryData = MediaQuery.of(context);
    final width = mediaQueryData.size.width;
    final widthPerBookCover = ((width - 16 * 4 - 8 * 3) / 4);
    final heightPerBookCover = widthPerBookCover * 4 / 3;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final bookCover = BookCover(
      url: coverUrl,
      height: heightPerBookCover,
      width: widthPerBookCover,
    );
    const strutStyle = StrutStyle(
      fontSize: 14,
      height: 1.2,
      forceStrutHeight: true,
    );
    final title = Text(
      book.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      strutStyle: strutStyle,
    );
    const authorStrutStyle = StrutStyle(
      fontSize: 12,
      height: 1.2,
      forceStrutHeight: true,
    );
    final subtitle = Text(
      _buildSubtitle() ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodySmall?.copyWith(
        color: onSurface.withValues(alpha: 0.5),
      ),
      strutStyle: authorStrutStyle,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openBookInfo(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bookCover,
          const SizedBox(height: 8),
          title,
          const SizedBox(height: 8),
          subtitle,
        ],
      ),
    );
  }

  void _openBookInfo(BuildContext context) {
    final searchBook = book.toSearchBook();
    CloudReaderBookInfoRoute(book: searchBook).push(context);
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (book.author.isNotEmpty) spans.add(book.author);
    if (book.kind.isNotEmpty) spans.add(book.kind);
    if (book.wordCount.isNotEmpty) spans.add(book.wordCount);
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
