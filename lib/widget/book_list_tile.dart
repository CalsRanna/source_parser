import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/widget/book_cover.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(url: book.cover),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name,
                      style: bodyMedium,
                    ),
                    Text(_buildSubtitle() ?? '', style: bodySmall),
                    const Spacer(),
                    Text(
                      book.introduction
                          .replaceAll('\n', '')
                          .replaceAll(' ', ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    context.ref.set(currentBookCreator, book);
    context.push('/book-information');
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (book.author.isNotEmpty) {
      spans.add(book.author);
    }
    if (book.category.isNotEmpty) {
      spans.add(book.category);
    }
    // if (book.status != null) {
    //   spans.add(book.status!);
    // }
    // if (book.words != null) {
    //   spans.add(book.words!);
    // }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
