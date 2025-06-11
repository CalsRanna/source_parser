import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/search_result_entity.dart';
import 'package:source_parser/widget/book_cover.dart';

class SearchResultView extends StatelessWidget {
  final List<SearchResultEntity> results;
  final bool isSearching;
  final void Function(BookEntity)? onTap;
  const SearchResultView({
    super.key,
    required this.results,
    this.isSearching = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty && !isSearching) {
      return const Center(child: Text('没有找到相关书籍'));
    }
    return ListView.separated(
      itemBuilder: _buildItem,
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return _Tile(
      result: results[index],
      onTap: () => onTap?.call(results[index].book),
    );
  }
}

class _Tile extends ConsumerWidget {
  final SearchResultEntity result;
  final void Function()? onTap;

  const _Tile({required this.result, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    final title = Text(
      result.book.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: bodyMedium,
    );
    final introduction = Text(
      result.book.introduction.replaceAll(RegExp(r'\s'), ''),
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
      BookCover(url: result.book.cover),
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
    if (result.book.author.isNotEmpty) {
      spans.add(result.book.author);
    }
    if (result.book.category.isNotEmpty) {
      spans.add(result.book.category);
    }
    if (result.book.status.isNotEmpty) {
      spans.add(result.book.status);
    }
    if (result.book.words.isNotEmpty) {
      spans.add(result.book.words);
    }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
