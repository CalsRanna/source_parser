import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/explore.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/model/explore.dart';
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
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      final loading = ref.watch(exploreLoadingCreator);
      final results = ref.watch(exploreBooksCreator);
      if (loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (results.isEmpty) {
        return const Center(child: Text('空空如也'));
      }
      List<Widget> children = [];
      for (var i = 0; i < results.length; i++) {
        final result = results[i];
        if (result.layout == 'banner') {
          children.add(_ExploreBanner(books: result.books));
        } else {
          children.add(
            _ExploreCard(books: result.books, title: result.title),
          );
        }
        if (i < results.length - 1) {
          children.add(const SizedBox(height: 16));
        }
      }
      return RefreshIndicator(
        onRefresh: refreshExplore,
        child: ListView(children: children),
      );
    });
  }

  @override
  void didChangeDependencies() {
    initExplore();
    super.didChangeDependencies();
  }

  void initExplore() async {
    final ref = context.ref;
    if (ref.read(exploreBooksCreator).isEmpty) {
      ref.set(exploreLoadingCreator, true);
      await getExplore();
      ref.set(exploreLoadingCreator, false);
    }
  }

  Future<void> refreshExplore() async {
    await getExplore();
  }

  Future<void> getExplore() async {
    final ref = context.ref;
    final builder = isar.sources.filter();
    final exploreSource = ref.read(exploreSourceCreator);
    if (exploreSource == 0) {
      final sources = await builder.exploreEnabledEqualTo(true).findAll();
      if (sources.isNotEmpty) {
        ref.set(exploreSourceCreator, sources.first.id);
      }
    }
    final source = await builder.idEqualTo(exploreSource).findFirst();
    if (source != null) {
      List<ExploreResult> results = [];
      final stream = await Parser.getExplore(source);
      stream.listen((result) {
        results.add(result);
        ref.set(exploreBooksCreator, results);
      });
      // final exploreRule = jsonDecode(source.exploreJson);
      //   final stream = await Parser.getExplore(source);
      //   stream.listen((result) {
      //     results.add(result);
      //     ref.set(exploreBooksCreator, results);
      //   });
      // for (var rule in exploreRule) {
      //   final layout = rule['layout'] ?? '';
      //   final title = rule['title'] ?? '';
      //   final exploreUrl = rule['exploreUrl'] ?? '';
      //   final books = await Parser.getExplore(exploreUrl, rule, source);
      //   results.add(
      //     ExploreResult(layout: layout, title: title, books: books),
      //   );
      // }
    }
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
