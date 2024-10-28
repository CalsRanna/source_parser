import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/explore.dart';
import 'package:source_parser/page/explore.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/explore.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/widget/book_cover.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _Banner extends StatefulWidget {
  final List<Book> books;

  const _Banner({super.key, required this.books});

  @override
  State<_Banner> createState() => _BannerState();
}

class _BannerState extends State<_Banner> {
  List<Book> books = [];
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    final pageView = PageView.builder(
      controller: controller,
      itemBuilder: (_, index) => _BannerTile(books[index]),
      itemCount: books.length,
    );
    return SizedBox(height: 200, child: pageView);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleTap(BuildContext context, WidgetRef ref, int index) {
    AutoRouter.of(context).push(InformationRoute());
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(books[index]);
  }

  @override
  void initState() {
    super.initState();
    final itemCount = min(widget.books.length, 3);
    if (itemCount == 0) return;
    final limitedBooks = widget.books.sublist(0, itemCount);
    books = [widget.books[itemCount - 1], ...limitedBooks, widget.books[0]];
    controller.addListener(() {
      if (controller.page == 0) {
        controller.jumpToPage(books.length - 2);
      }
      if (controller.page == books.length - 1) {
        controller.jumpToPage(1);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.jumpToPage(1);
    });
  }
}

class _BannerTile extends ConsumerWidget {
  final Book book;
  const _BannerTile(this.book);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeholder = Image.asset(
      'asset/image/default_cover.jpg',
      fit: BoxFit.cover,
    );
    final image = CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: book.cover,
      errorWidget: (context, url, error) => placeholder,
      placeholder: (context, url) => placeholder,
    );
    final clip = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: image,
    );
    const edgeInsets = EdgeInsets.symmetric(horizontal: 16);
    return GestureDetector(
      onTap: () => handleTap(context, ref),
      child: Padding(padding: edgeInsets, child: clip),
    );
  }

  void handleTap(BuildContext context, WidgetRef ref) {
    AutoRouter.of(context).push(InformationRoute());
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }
}

class _ExploreViewState extends ConsumerState<ExploreView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = ref.watch(exploreBooksProvider);
    return provider.when(data: data, error: error, loading: loading);
  }

  Widget data(List<ExploreResult> results) {
    if (results.isEmpty) return const Center(child: Text('空空如也'));
    final listView = ListView.separated(
      itemBuilder: (context, index) => _itemBuilder(results[index]),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
    return RefreshIndicator(
      onRefresh: () => handleRefresh(ref),
      child: listView,
    );
  }

  Widget error(Object error, StackTrace stackTrace) {
    return Center(child: Text(error.toString()));
  }

  Future<void> handleRefresh(WidgetRef ref) async {
    final notifier = ref.read(exploreBooksProvider.notifier);
    await notifier.refresh();
  }

  Widget loading() => const Center(child: CircularProgressIndicator());

  Widget _itemBuilder(ExploreResult result) {
    final layout = result.layout;
    final books = result.books;
    final title = result.title;
    return switch (layout) {
      'banner' => _Banner(key: ValueKey(title), books: books),
      'card' => _List(key: ValueKey(title), books: books, title: title),
      'grid' => _Grid(key: ValueKey(title), books: books, title: title),
      _ => const SizedBox(),
    };
  }
}

class _Grid extends StatelessWidget {
  final List<Book> books;
  final String title;
  const _Grid({super.key, required this.books, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surface = colorScheme.surface;
    final shadow = colorScheme.shadow;
    final textTheme = theme.textTheme;
    final titleLarge = textTheme.titleLarge;
    final itemCount = min(books.length, 4);
    final mediaQueryData = MediaQuery.of(context);
    final width = mediaQueryData.size.width;
    final widthPerBookCover = ((width - 16 * 4 - 8 * 3) / 4);
    final heightPerBookCover = widthPerBookCover * 4 / 3;
    const heightPerBookName = 14 * 1.2 * 2; // extra 1 for line gap
    const heightPerBookSpan = 12 * 1.2; // extra 1 for line gap
    double heightPerBook = 0;
    heightPerBook += heightPerBookCover;
    heightPerBook += heightPerBookName;
    heightPerBook += 8;
    heightPerBook += heightPerBookSpan;
    heightPerBook += 8;
    final titleStyle = titleLarge?.copyWith(fontWeight: FontWeight.bold);
    const edgeInsets = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
    const buttonStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.zero),
      padding: WidgetStatePropertyAll(edgeInsets),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    final outlinedButton = OutlinedButton(
      style: buttonStyle,
      onPressed: () => handleTap(context),
      child: const Text('更多'),
    );
    final titleChildren = [
      Text(title, style: titleStyle),
      const Spacer(),
      outlinedButton
    ];
    final delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: widthPerBookCover / heightPerBook,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
    );
    final childBuilderDelegate = SliverChildBuilderDelegate(
      (_, index) => _GridTile(book: books[index]),
      childCount: itemCount,
    );
    final gridView = GridView.custom(
      gridDelegate: delegate,
      childrenDelegate: childBuilderDelegate,
      physics: const NeverScrollableScrollPhysics(),
    );
    final children = [
      Row(children: titleChildren),
      const SizedBox(height: 8),
      SizedBox(height: heightPerBook + 1, child: gridView)
    ];
    final boxShadow = BoxShadow(
      blurRadius: 16,
      color: shadow.withOpacity(0.05),
      offset: const Offset(8, 8),
    );
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [boxShadow],
      color: surface,
    );
    return Container(
      decoration: boxDecoration,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(children: children),
    );
  }

  void handleTap(BuildContext context) {
    final page = ExploreListPage(books: books, title: title);
    final route = MaterialPageRoute(builder: (_) => page);
    Navigator.of(context).push(route);
  }
}

class _GridTile extends ConsumerWidget {
  final Book book;

  const _GridTile({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQueryData = MediaQuery.of(context);
    final width = mediaQueryData.size.width;
    final widthPerBookCover = ((width - 16 * 4 - 8 * 3) / 4);
    final heightPerBookCover = widthPerBookCover * 4 / 3;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final bookCover = BookCover(
      url: book.cover,
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
      style: bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
      style: bodySmall?.copyWith(color: onSurface.withOpacity(0.5)),
      strutStyle: authorStrutStyle,
    );
    final children = [
      bookCover,
      const SizedBox(height: 8),
      title,
      const SizedBox(height: 8),
      subtitle,
    ];
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => handleTap(context, ref),
      child: column,
    );
  }

  void handleTap(BuildContext context, WidgetRef ref) {
    AutoRouter.of(context).push(InformationRoute());
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (book.author.isNotEmpty) {
      spans.add(book.author);
    }
    if (book.category.isNotEmpty) {
      spans.add(book.category);
    }
    if (book.status.isNotEmpty) {
      spans.add(book.status);
    }
    if (book.words.isNotEmpty) {
      spans.add(book.words);
    }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}

class _List extends StatelessWidget {
  final List<Book> books;
  final String title;
  const _List({super.key, required this.books, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surface = colorScheme.surface;
    final shadow = colorScheme.shadow;
    final textTheme = theme.textTheme;
    final titleLarge = textTheme.titleLarge;
    final itemCount = min(books.length, 3);
    List<Widget> tiles = [];
    for (var i = 0; i < itemCount; i++) {
      tiles.add(_ListTile(book: books[i]));
      if (i < books.length - 1) {
        tiles.add(const SizedBox(height: 8));
      }
    }
    final titleStyle = titleLarge?.copyWith(fontWeight: FontWeight.bold);
    const edgeInsets = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
    const buttonStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.zero),
      padding: WidgetStatePropertyAll(edgeInsets),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    final outlinedButton = OutlinedButton(
      style: buttonStyle,
      onPressed: () => handleTap(context),
      child: const Text('更多'),
    );
    final rowChildren = [
      Text(title, style: titleStyle),
      const Spacer(),
      outlinedButton
    ];
    final columnChildren = [
      Row(children: rowChildren),
      const SizedBox(height: 8),
      ...tiles,
    ];
    final boxShadow = BoxShadow(
      blurRadius: 16,
      color: shadow.withOpacity(0.05),
      offset: const Offset(8, 8),
    );
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [boxShadow],
      color: surface,
    );
    return Container(
      decoration: boxDecoration,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(children: columnChildren),
    );
  }

  void handleTap(BuildContext context) {
    final page = ExploreListPage(books: books, title: title);
    final route = MaterialPageRoute(builder: (_) => page);
    Navigator.of(context).push(route);
  }
}

class _ListTile extends ConsumerWidget {
  final Book book;

  const _ListTile({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final title = Text(
      book.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    );
    final introduction = Text(
      book.introduction.replaceAll(RegExp(r'\s'), ''),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: bodyMedium?.copyWith(color: onSurface.withOpacity(0.75)),
    );
    final subtitle = Text(
      _buildSubtitle() ?? '',
      style: bodySmall?.copyWith(color: onSurface.withOpacity(0.5)),
    );
    final columnChildren = [
      title,
      const Spacer(),
      introduction,
      const Spacer(),
      subtitle,
    ];
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
    final rowChildren = [
      BookCover(height: 80, url: book.cover, width: 60),
      const SizedBox(width: 16),
      Expanded(child: SizedBox(height: 80, child: column)),
    ];
    final tile = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowChildren,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => handleTap(context, ref),
      child: tile,
    );
  }

  void handleTap(BuildContext context, WidgetRef ref) {
    AutoRouter.of(context).push(InformationRoute());
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (book.author.isNotEmpty) {
      spans.add(book.author);
    }
    if (book.category.isNotEmpty) {
      spans.add(book.category);
    }
    if (book.status.isNotEmpty) {
      spans.add(book.status);
    }
    if (book.words.isNotEmpty) {
      spans.add(book.words);
    }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
