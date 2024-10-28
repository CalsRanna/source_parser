import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/widget/book_cover.dart';

class SearchResult extends ConsumerStatefulWidget {
  final String credential;
  const SearchResult(this.credential, {super.key});

  @override
  ConsumerState<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends ConsumerState<SearchResult> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initProvider();
    });
  }

  /// Must call this method cause don't wanna use stream directly
  void _initProvider() {
    var provider = searchBooksProvider(widget.credential);
    var notifier = ref.read(provider.notifier);
    notifier.search();
  }

  @override
  Widget build(BuildContext context) {
    var provider = searchBooksProvider(widget.credential);
    final books = ref.watch(provider);
    if (books.isEmpty) return const Center(child: Text('没有搜索结果'));
    return ListView.separated(
      itemBuilder: (_, index) => _Tile(book: books[index]),
      itemCount: books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}

class _Tile extends ConsumerWidget {
  final Book book;

  const _Tile({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    final title = Text(
      book.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: bodyMedium,
    );
    final introduction = Text(
      book.introduction.replaceAll(RegExp(r'\s'), ''),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: bodyMedium,
    );
    final children = [
      title,
      Text(_buildSubtitle() ?? '', style: bodySmall),
      const Spacer(),
      introduction,
    ];
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
    final rowChildren = [
      BookCover(url: book.cover),
      const SizedBox(width: 16),
      Expanded(child: SizedBox(height: 96, child: column)),
    ];
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowChildren,
    );
    final padding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: row,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(context, ref),
      child: padding,
    );
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

  void _handleTap(BuildContext context, WidgetRef ref) {
    AutoRouter.of(context).push(InformationRoute());
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }
}
