import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/page/explore.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/explore.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/widget/book_cover.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final provider = ref.watch(exploreBooksProvider);
      return switch (provider) {
        AsyncData(:final value) => RefreshIndicator(
            onRefresh: () => handleRefresh(ref),
            child: ListView.builder(
              itemBuilder: (context, index) {
                final layout = value[index].layout;
                final books = value[index].books;
                final title = value[index].title;
                return switch (layout) {
                  'banner' => _ExploreBanner(books: books),
                  'card' => _ExploreCard(books: books, title: title),
                  'grid' => _ExploreGrid(books: books, title: title),
                  _ => Container(),
                };
              },
              itemCount: value.length,
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      };
    });
  }

  Future<void> handleRefresh(WidgetRef ref) async {
    final notifier = ref.read(exploreBooksProvider.notifier);
    await notifier.refresh();
  }
}

class _ExploreBanner extends StatelessWidget {
  const _ExploreBanner({required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    final itemCount = min(books.length, 3);
    return SizedBox(
      height: 120,
      child: PageView.builder(
        itemBuilder: (context, index) {
          return Consumer(builder: (context, ref, child) {
            return GestureDetector(
              onTap: () => handleTap(context, ref, index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: books[index].cover,
                  ),
                ),
              ),
            );
          });
        },
        itemCount: itemCount,
      ),
    );
  }

  void handleTap(BuildContext context, WidgetRef ref, int index) {
    const BookInformationPageRoute().push(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(books[index]);
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({required this.books, required this.title});

  final List<Book> books;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final background = colorScheme.background;
    final shadow = colorScheme.shadow;
    final textTheme = theme.textTheme;
    final titleMedium = textTheme.titleMedium;
    final itemCount = min(books.length, 3);
    List<Widget> tiles = [];
    for (var i = 0; i < itemCount; i++) {
      tiles.add(_ExploreTile(book: books[i]));
      if (i < books.length - 1) {
        tiles.add(const SizedBox(height: 8));
      }
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: shadow.withOpacity(0.05),
            offset: const Offset(8, 8),
          ),
        ],
        color: background,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Row(
          children: [
            Text(title, style: titleMedium),
            const Spacer(),
            OutlinedButton(
              style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(Size.zero),
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => handleTap(context),
              child: const Text('更多'),
            )
          ],
        ),
        const SizedBox(height: 8),
        ...tiles,
      ]),
    );
  }

  void handleTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return ExploreListPage(books: books, title: title);
    }));
  }
}

class _ExploreTile extends StatelessWidget {
  const _ExploreTile({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => handleTap(context, ref),
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
    });
  }

  void handleTap(BuildContext context, WidgetRef ref) {
    const BookInformationPageRoute().push(context);
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

class _ExploreGrid extends StatelessWidget {
  const _ExploreGrid({required this.books, required this.title});

  final List<Book> books;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final background = colorScheme.background;
    final shadow = colorScheme.shadow;
    final textTheme = theme.textTheme;
    final titleMedium = textTheme.titleMedium;
    final itemCount = min(books.length, 4);
    final mediaQueryData = MediaQuery.of(context);
    final width = mediaQueryData.size.width;
    final widthPerBookCover = ((width - 16 * 4 - 8 * 3) / 4);
    final heightPerBookCover = widthPerBookCover * 4 / 3;
    const heightPerBookName = 14 * 1.2 * 2 + 1; // extra 1 for line gap
    final heightPerBook = heightPerBookCover + heightPerBookName + 8;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: shadow.withOpacity(0.05),
            offset: const Offset(8, 8),
          ),
        ],
        color: background,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Row(
          children: [
            Text(title, style: titleMedium),
            const Spacer(),
            OutlinedButton(
              style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(Size.zero),
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => handleTap(context),
              child: const Text('更多'),
            )
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: heightPerBook + 1,
          child: GridView.custom(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: widthPerBookCover / heightPerBook,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                return _ExploreGridTile(book: books[index]);
              },
              childCount: itemCount,
            ),
            physics: const NeverScrollableScrollPhysics(),
          ),
        )
      ]),
    );
  }

  void handleTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return ExploreListPage(books: books, title: title);
    }));
  }
}

class _ExploreGridTile extends StatelessWidget {
  const _ExploreGridTile({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final width = mediaQueryData.size.width;
    final widthPerBookCover = ((width - 16 * 4 - 8 * 3) / 4);
    final heightPerBookCover = widthPerBookCover * 4 / 3;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => handleTap(context, ref),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(
              url: book.cover,
              height: heightPerBookCover,
              width: widthPerBookCover,
            ),
            const SizedBox(height: 8),
            Text(
              book.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bodyMedium?.copyWith(fontSize: 14),
              strutStyle: const StrutStyle(
                fontSize: 14,
                height: 1.2,
                forceStrutHeight: true,
              ),
            ),
          ],
        ),
      );
    });
  }

  void handleTap(BuildContext context, WidgetRef ref) {
    const BookInformationPageRoute().push(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }
}
