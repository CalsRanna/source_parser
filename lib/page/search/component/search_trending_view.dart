import 'package:flutter/material.dart';
import 'package:source_parser/model/book_entity.dart';

class SearchTrendingView extends StatelessWidget {
  final List<BookEntity> books;
  final void Function(BookEntity)? onPressed;
  const SearchTrendingView({super.key, required this.books, this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const SizedBox();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final titleMedium = textTheme.titleMedium;
    List<Widget> chips = books.map((book) => _buildChip(book)).toList();
    final children = [
      Text('热门搜索', style: titleMedium),
      const SizedBox(height: 8),
      Wrap(runSpacing: 8, spacing: 8, children: chips),
    ];
    final column = ListView(children: children);
    const edgeInsets = EdgeInsets.symmetric(horizontal: 16.0);
    return Padding(padding: edgeInsets, child: column);
  }

  Widget _buildChip(BookEntity book) {
    return ActionChip(
      label: Text(book.name),
      onPressed: () => onPressed?.call(book),
    );
  }
}
