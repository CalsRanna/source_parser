import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/search.dart';
import 'package:source_parser/schema/book.dart';

// ignore: unused_element
class SearchTrending extends ConsumerWidget {
  final void Function(String)? onPressed;
  const SearchTrending({super.key, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = topSearchBooksProvider;
    final books = ref.watch(provider).valueOrNull;
    if (books == null) return const SizedBox();
    if (books.isEmpty) return const SizedBox();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final titleMedium = textTheme.titleMedium;
    List<Widget> chips = books.map((book) => _buildChip(ref, book)).toList();
    final children = [
      Text('热门搜索', style: titleMedium),
      const SizedBox(height: 8),
      Wrap(runSpacing: 8, spacing: 8, children: chips),
    ];
    final column = ListView(children: children);
    const edgeInsets = EdgeInsets.symmetric(horizontal: 16.0);
    return Padding(padding: edgeInsets, child: column);
  }

  void handlePressed(WidgetRef ref, String name) {
    onPressed?.call(name);
  }

  Widget _buildChip(WidgetRef ref, Book book) {
    return ActionChip(
      label: Text(book.name),
      onPressed: () => handlePressed(ref, book.name),
    );
  }
}
