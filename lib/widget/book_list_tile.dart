import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../entity/book.dart';
import '../state/book.dart';
import 'book_cover.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(url: book.cover ?? ''),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  book.name ?? '',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(_buildSubtitle() ?? ''),
                Text(book.introduction ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context) {
    context.ref.set(bookCreator, book);
    context.push('/book-information');
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (book.author != null) {
      spans.add(book.author!);
    }
    if (book.category != null) {
      spans.add(book.category!);
    }
    if (book.status != null) {
      spans.add(book.status!);
    }
    if (book.words != null) {
      spans.add(book.words!);
    }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
