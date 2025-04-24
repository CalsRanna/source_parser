import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/widget/book_cover.dart';

class SearchResultView extends StatelessWidget {
  final List<BookEntity> books;
  final bool isSearching;
  final void Function(BookEntity)? onTap;
  const SearchResultView({
    super.key,
    required this.books,
    this.isSearching = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty && !isSearching) {
      return const Center(child: Text('没有找到相关书籍'));
    }
    return ListView.separated(
      itemBuilder: _buildItem,
      itemCount: books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return _Tile(
      book: books[index],
      onTap: () => onTap?.call(books[index]),
    );
  }
}

class _Tile extends ConsumerWidget {
  final BookEntity book;
  final void Function()? onTap;

  const _Tile({required this.book, this.onTap});

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
      onTap: onTap,
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
}
