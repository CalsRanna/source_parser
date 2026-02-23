import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/information_entity.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/widget/book_cover.dart';

@RoutePage()
class ExploreListPage extends StatelessWidget {
  final List<Book> books;

  final String title;
  const ExploreListPage({super.key, required this.books, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return _ExploreTile(book: books[index]);
        },
        itemCount: books.length,
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Divider(
              color: surfaceContainerHighest.withValues(alpha: 0.25),
              height: 1,
            ),
          );
        },
      ),
    );
  }
}

class _ExploreTile extends StatelessWidget {
  final Book book;

  const _ExploreTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => handleTap(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(height: 80, url: book.cover, width: 60),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bodyMedium,
                  ),
                  Text(_buildSubtitle() ?? '', style: bodySmall),
                  const Spacer(),
                  Text(
                    book.introduction.replaceAll(RegExp(r'\s'), ''),
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
    );
  }

  void handleTap(BuildContext context) {
    var bookEntity = BookEntity.fromJson(book.toJson());
    var information = InformationEntity(
      book: bookEntity,
      chapters: [],
      availableSources: [],
      covers: [],
    );
    InformationRoute(information: information).push(context);
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
