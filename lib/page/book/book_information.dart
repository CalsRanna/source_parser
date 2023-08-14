import 'dart:ui';

import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/history.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/model/chapter.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/book_cover.dart';

class BookInformation extends StatefulWidget {
  const BookInformation({super.key});

  @override
  State<BookInformation> createState() {
    return _BookInformationState();
  }
}

class _BookInformationState extends State<BookInformation> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final book = context.ref.watch(currentBookCreator);
    var background = ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: BookCover(
        borderRadius: null,
        height: double.infinity,
        url: book.cover,
        width: double.infinity,
      ),
    );
    var information = Stack(
      children: [
        background,
        Positioned(
          left: 16,
          right: 16,
          top: 135,
          child: Row(
            children: [
              BookCover(url: book.cover),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(book.author),
                    Text(_buildSpan(book)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );

    var header = SliverAppBar(
      centerTitle: false,
      expandedHeight: 240,
      flexibleSpace: FlexibleSpaceBar(
        background: information,
        collapseMode: CollapseMode.pin,
      ),
      title: CreatorWatcher<History>(
        builder: (context, history) => Text(history.name ?? ''),
        creator: historyCreator,
      ),
      titleSpacing: 0,
      pinned: true,
    );

    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    List<Widget> children = [
      const SizedBox(height: 16),
      Card(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [Text('简介', style: boldTextStyle)],
              ),
              const SizedBox(height: 16),
              Text(
                book.introduction,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      _CatalogueCard(book: book),
      const SizedBox(height: 16),
      _SourceCard(book: book),
    ];

    Widget bottomBar = Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: const Row(
              children: [Icon(Icons.library_add_outlined), Text('加入书架')],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: startReader,
              child: const Text('立即阅读'),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, __) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: header,
          )
        ],
        body: Builder(
          builder: (context) => CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(delegate: SliverChildListDelegate(children))
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar,
    );
  }

  String _buildSpan(Book book) {
    final spans = <String>[];
    // if (book.category != null) {
    //   spans.add(book.category!);
    // }
    // if (book.status != null) {
    //   spans.add(book.status!);
    // }
    return spans.join(' · ');
  }

  void startReader() async {
    final ref = context.ref;
    final router = GoRouter.of(context);
    final book = ref.watch(currentBookCreator);
    final source =
        await isar.sources.filter().idEqualTo(book.sourceId).findFirst();
    if (source != null) {
      final chapters = await Parser().getChapters(
        source: source,
        url: book.url,
      );
      ref.set(currentChaptersCreator, chapters);
      ref.set(currentSourceCreator, source);
    }
    router.push('/book-reader');
  }
}

class _CatalogueCard extends StatefulWidget {
  const _CatalogueCard({super.key, required this.book});

  final Book book;

  @override
  State<_CatalogueCard> createState() => __CatalogueCardState();
}

class __CatalogueCardState extends State<_CatalogueCard> {
  List<Chapter> chapters = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getChapters();
  }

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    return GestureDetector(
      onTap: () => context.push('/catalog'),
      child: Card(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text('目录', style: boldTextStyle),
              Expanded(
                child: loading
                    ? const Align(
                        alignment: Alignment.centerRight,
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Text(
                        '${chapters.length}章·${chapters.last.name}',
                        textAlign: TextAlign.right,
                      ),
              ),
              const Icon(Icons.chevron_right_outlined)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getChapters() async {
    setState(() {
      loading = true;
    });
    try {
      final source = await isar.sources
          .filter()
          .idEqualTo(widget.book.sourceId)
          .findFirst();
      if (source != null) {
        final chapters = await Parser().getChapters(
          source: source,
          url: widget.book.url,
        );
        setState(() {
          this.chapters = chapters;
          loading = false;
        });
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
    }
  }
}

class _SourceCard extends StatefulWidget {
  const _SourceCard({super.key, required this.book});

  final Book book;

  @override
  State<_SourceCard> createState() => __SourceCardState();
}

class __SourceCardState extends State<_SourceCard> {
  bool loading = false;
  List<Source> sources = [];

  @override
  void initState() {
    super.initState();
    getChapters();
  }

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    return Card(
      color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('书源', style: boldTextStyle),
                Expanded(
                  child: Text(
                    sources.isEmpty
                        ? ''
                        : '${sources.length}个·${sources.last.name}',
                    textAlign: TextAlign.right,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: loading
                      ? const CupertinoActivityIndicator()
                      : const Icon(Icons.chevron_right_outlined),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getChapters() async {
    setState(() {
      loading = true;
    });
    try {
      final source = await isar.sources
          .filter()
          .idEqualTo(widget.book.sourceId)
          .findFirst();
      if (source != null) {
        setState(() {
          sources.add(source);
          loading = false;
        });
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
    }
  }
}
