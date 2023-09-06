import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/page/explore_list.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/book_cover.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  late Future future;
  List<String> layouts = [];
  List<String> titles = [];
  List<List<Book>> books = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (var i = 0; i < layouts.length; i++) {
      if (layouts[i] == 'banner') {
        children.add(_ExploreBanner(books: books[i]));
      } else {
        children.add(_ExploreCard(books: books[i], title: titles[i]));
      }
      if (i < layouts.length - 1) {
        children.add(const SizedBox(height: 16));
      }
    }
    return FutureBuilder(
      future: getExplore(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: getExplore,
            child: ListView(children: children),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    future = getExplore();
  }

  // 必须要有一个返回值，当返回值为null或者void时，FutureBuilder会认为snapshot.hasData为false
  Future<String> getExplore() async {
    final builder = isar.sources.filter();
    final sources = await builder.exploreEnabledEqualTo(true).findAll();
    if (sources.isNotEmpty) {
      final source = sources.first;
      final exploreRule = jsonDecode(source.exploreJson);
      List<String> layouts = [];
      List<String> titles = [];
      List<List<Book>> books = [];
      for (var rule in exploreRule) {
        final layout = rule['layout'] ?? '';
        final title = rule['title'] ?? '';
        final exploreUrl = rule['exploreUrl'] ?? '';
        final booksPerRule = await Parser.getExplore(
          exploreUrl,
          rule,
          source.id,
        );
        layouts.add(layout);
        titles.add(title);
        books.add(booksPerRule);
      }
      setState(() {
        this.layouts = layouts;
        this.titles = titles;
        this.books = books;
      });
    }
    return 'Success';
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
          return GestureDetector(
            onTap: () => handleTap(context, index),
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
        },
        itemCount: itemCount,
      ),
    );
  }

  void handleTap(BuildContext context, int index) {
    context.ref.set(currentBookCreator, books[index]);
    context.push('/book-information');
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
    if (book.status.isNotEmpty) {
      spans.add(book.status);
    }
    if (book.words.isNotEmpty) {
      spans.add(book.words);
    }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
