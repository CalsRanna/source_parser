import 'dart:math';
import 'dart:ui';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/router.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/book_cover.dart';
import 'package:source_parser/widget/loading.dart';

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
  void didChangeDependencies() {
    getInformation();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      final book = ref.watch(currentBookCreator);
      final eInkMode = ref.watch(eInkModeCreator);
      return RefreshIndicator(
        onRefresh: getInformation,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      _BackgroundImage(url: book.cover),
                      const _ColorFilter(),
                      _Information(book: book),
                    ],
                  ),
                  collapseMode: CollapseMode.pin,
                ),
                pinned: true,
                stretch: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _Introduction(book: book),
                  const SizedBox(height: 8),
                  _Catalogue(book: book, eInkMode: eInkMode, loading: loading),
                  const SizedBox(height: 8),
                  _Source(sources: book.sources),
                ]),
              )
            ],
          ),
          bottomNavigationBar: const _BottomBar(),
        ),
      );
    });
  }

  Future<void> getInformation() async {
    final message = Message.of(context);
    setState(() {
      loading = true;
    });
    try {
      final ref = context.ref;
      final book = ref.read(currentBookCreator);
      final queryBuilder = isar.sources.filter();
      final sourceId = book.sourceId;
      final source = await queryBuilder.idEqualTo(sourceId).findFirst();
      if (source != null) {
        final information = await Parser.getInformation(book.url, source);
        String? updatedIntroduction;
        if (information.introduction.length > book.introduction.length) {
          updatedIntroduction = information.introduction;
        }
        var stream = await Parser.getChapters(
          information.catalogueUrl,
          source,
        );
        stream = stream.asBroadcastStream();
        List<Chapter> chapters = [];
        stream.listen(
          (chapter) {
            chapters.add(chapter);
          },
        );
        await stream.last;
        String updatedCover = book.cover;
        if (updatedCover.isEmpty) {
          updatedCover = information.cover;
        }
        List<Chapter> updatedChapters = [];
        if (chapters.length > book.chapters.length) {
          final start = max(book.chapters.length - 1, 0);
          final end = max(chapters.length - 1, 0);
          updatedChapters = chapters.getRange(start, end).toList();
        }
        var updatedBook = book.copyWith(
          catalogueUrl: information.catalogueUrl,
          category: information.category,
          chapters: [...book.chapters, ...updatedChapters],
          cover: updatedCover,
          introduction: updatedIntroduction,
          latestChapter: information.latestChapter,
          words: information.words,
        );
        final builder = isar.books.filter();
        final exist = await builder
            .nameEqualTo(book.name)
            .authorEqualTo(book.author)
            .findFirst();
        if (exist != null) {
          updatedBook = exist.copyWith(
            catalogueUrl: updatedBook.catalogueUrl,
            category: updatedBook.category,
            chapters: updatedBook.chapters,
            cover: updatedBook.cover,
            introduction: updatedBook.introduction,
            latestChapter: updatedBook.latestChapter,
            words: updatedBook.words,
          );
        }
        ref.set(currentBookCreator, updatedBook);
      }
      setState(() {
        loading = false;
      });
    } catch (error) {
      message.show(error.toString());
      setState(() {
        loading = false;
      });
    }
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: BookCover(
        height: double.infinity,
        url: url,
        width: double.infinity,
      ),
    );
  }
}

class _ColorFilter extends StatelessWidget {
  const _ColorFilter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    return Container(color: primary.withOpacity(0.25));
  }
}

class _Information extends StatelessWidget {
  const _Information({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Row(
        children: [
          GestureDetector(
            onLongPress: () => handleLongPress(context),
            child: BookCover(height: 120, url: book.cover, width: 90),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.white, height: 1.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(book.author),
                  Text(
                    _buildSpan(book),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void handleLongPress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _CoverSelector(book: book);
      },
    );
  }

  String _buildSpan(Book book) {
    final spans = <String>[];
    if (book.category.isNotEmpty) {
      spans.add(book.category);
    }
    if (book.status.isNotEmpty) {
      spans.add(book.status);
    }
    return spans.join(' · ');
  }
}

class _Introduction extends StatefulWidget {
  const _Introduction({required this.book});

  final Book book;

  @override
  State<_Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<_Introduction> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceTint = colorScheme.surfaceTint;
    var introduction = widget.book.introduction;
    introduction = introduction
        .replaceAll(' ', '')
        .replaceAll(RegExp(r'\u2003'), '')
        .replaceAll(RegExp(r'\n+'), '\n\u2003\u2003')
        .trim();
    introduction = '\u2003\u2003$introduction';
    return Card(
      color: surfaceTint.withOpacity(0.05),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    if (widget.book.words.isNotEmpty)
                      _Tag(text: widget.book.words),
                    if (widget.book.status.isNotEmpty)
                      _Tag(text: widget.book.status),
                  ],
                ),
                if (widget.book.words.isNotEmpty ||
                    widget.book.status.isNotEmpty)
                  const SizedBox(height: 16),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleTap,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      introduction,
                      maxLines: expanded ? null : 4,
                      overflow: expanded ? null : TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            if (!expanded)
              Positioned(
                bottom: 8,
                right: 0,
                child: Container(
                  decoration: ShapeDecoration(
                    color: surfaceTint.withOpacity(0.1),
                    shape: const StadiumBorder(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: surfaceTint,
                    size: 12,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void handleTap() {
    setState(() {
      expanded = !expanded;
    });
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceTint = colorScheme.surfaceTint;
    final textTheme = theme.textTheme;
    final labelMedium = textTheme.labelMedium;
    return Container(
      decoration: ShapeDecoration(
        color: surfaceTint.withOpacity(0.1),
        shape: const StadiumBorder(),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Text(text, style: labelMedium),
    );
  }
}

class _Catalogue extends StatelessWidget {
  const _Catalogue({
    required this.book,
    this.eInkMode = false,
    this.loading = false,
  });

  final Book book;
  final bool eInkMode;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    return GestureDetector(
      onTap: () => handleTap(context),
      child: Card(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text('目录', style: boldTextStyle),
              const Spacer(),
              if (loading && book.chapters.isEmpty)
                SizedBox(
                  height: 24,
                  width: eInkMode ? null : 24,
                  child: const LoadingIndicator(strokeWidth: 2),
                ),
              if (!loading || book.chapters.isNotEmpty) ...[
                Text(
                  '共${book.chapters.length}章',
                  textAlign: TextAlign.right,
                ),
                const Icon(Icons.chevron_right_outlined)
              ]
            ],
          ),
        ),
      ),
    );
  }

  void handleTap(BuildContext context) {
    if (!loading) {
      context.ref.set(fromCreator, '/book-information');
      context.push('/book-catalogue');
    }
  }
}

class _Source extends StatelessWidget {
  const _Source({required this.sources});

  final List<AvailableSource> sources;

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    return GestureDetector(
      onTap: () => handleTap(context),
      child: Card(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05),
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
                      '可用${sources.length}个',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const Icon(Icons.chevron_right_outlined)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleTap(BuildContext context) {
    context.ref.set(fromCreator, '/book-information');
    context.push('/book-available-sources');
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Container(
      color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05),
      padding: EdgeInsets.fromLTRB(16, 16, 16, padding.bottom),
      child: Row(
        children: [
          // TextButton(
          //   onPressed: () {},
          //   child: const Row(
          //     children: [Icon(Icons.library_add_outlined), Text('加入书架')],
          //   ),
          // ),
          // const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => startReader(context),
              child: const Text('立即阅读'),
            ),
          ),
        ],
      ),
    );
  }

  void startReader(BuildContext context) async {
    context.push('/book-reader');
  }
}

class _CoverSelector extends StatefulWidget {
  const _CoverSelector({required this.book});

  final Book book;

  @override
  State<_CoverSelector> createState() => __CoverSelectorState();
}

class __CoverSelectorState extends State<_CoverSelector> {
  bool loading = true;
  List<String> covers = [];

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: LoadingIndicator());
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 4,
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => handleTap(covers[index]),
          child: BookCover(height: 120, url: covers[index], width: 90),
        );
      },
      itemCount: covers.length,
      padding: const EdgeInsets.all(16),
    );
  }

  @override
  void initState() {
    super.initState();
    getCovers();
  }

  void getCovers() async {
    setState(() {
      loading = true;
    });
    final availableSources = widget.book.sources;
    for (var availableSource in availableSources) {
      final source =
          await isar.sources.filter().idEqualTo(availableSource.id).findFirst();
      if (source != null) {
        final information =
            await Parser.getInformation(availableSource.url, source);
        final cover = information.cover;
        if (cover.isNotEmpty) {
          setState(() {
            covers.add(cover);
          });
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  void handleTap(String cover) async {
    final ref = context.ref;
    final navigator = Navigator.of(context);
    final book = ref.read(currentBookCreator);
    final updatedBook = book.copyWith(cover: cover);
    ref.set(currentBookCreator, updatedBook);
    navigator.pop();
    var exist = await isar.books
        .filter()
        .nameEqualTo(book.name)
        .authorEqualTo(book.author)
        .findFirst();
    if (exist != null) {
      await isar.writeTxn(() async {
        isar.books.put(updatedBook);
      });
    }
  }
}
