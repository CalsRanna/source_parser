import 'dart:math';
import 'dart:ui';

import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/router.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/creator/source.dart';
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
      final sources = ref.watch(sourcesEmitter.asyncData).data;
      final currentSource =
          sources?.where((source) => source.id == book.sourceId).firstOrNull;
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
                  _Source(
                    currentSource: currentSource?.name,
                    sources: book.sources,
                  ),
                  const SizedBox(height: 8),
                  const _Archive(),
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
        final duration = ref.read(cacheDurationCreator);
        final timeout = ref.read(timeoutCreator);
        final information = await Parser.getInformation(
          book.name,
          book.url,
          source,
          Duration(hours: duration.floor()),
          Duration(milliseconds: timeout),
        );
        String? updatedIntroduction;
        if (information.introduction.length > book.introduction.length) {
          updatedIntroduction = information.introduction;
        }
        var stream = await Parser.getChapters(
          book.name,
          information.catalogueUrl,
          source,
          Duration(hours: duration.floor()),
          Duration(milliseconds: timeout),
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
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => searchSameAuthor(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(book.author),
                        const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 14,
                        )
                      ],
                    ),
                  ),
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

  void searchSameAuthor(BuildContext context) {
    context.push('/search?credential=${book.author}');
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
                  child: const LoadingIndicator(),
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
  const _Source({this.currentSource, required this.sources});

  final String? currentSource;
  final List<AvailableSource> sources;

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    var name = '';
    if (currentSource != null && currentSource!.isNotEmpty) {
      name = '$currentSource · ';
    }
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
                      '$name可用${sources.length}个',
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

class _Archive extends StatelessWidget {
  const _Archive();

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('归档', style: boldTextStyle),
                  const Spacer(),
                  Watcher((context, ref, child) {
                    final book = ref.watch(currentBookCreator);
                    return Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: book.archive,
                      onChanged: (value) => handleTap(context),
                    );
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleTap(BuildContext context) async {
    final message = Message.of(context);
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final archivedBook = book.copyWith(archive: !book.archive);
    ref.set(currentBookCreator, archivedBook);
    if (archivedBook.archive) {
      message.show('归档后，书架不再更新');
    }
    final name = book.name;
    final author = book.author;
    var builder = isar.books.filter();
    builder = builder.nameEqualTo(name);
    final exist = await builder.authorEqualTo(author).findFirst();
    if (exist == null) return;
    isar.writeTxn(() async {
      await isar.books.put(archivedBook);
    });
  }
}

class _BottomBar extends StatefulWidget {
  const _BottomBar();

  @override
  State<StatefulWidget> createState() => __BottomBarState();
}

class __BottomBarState extends State<_BottomBar> {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Container(
      color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05),
      padding: EdgeInsets.fromLTRB(16, 8, 16, padding.bottom + 8),
      child: Row(
        children: [
          TextButton(
            onPressed: updateShelf,
            child: FutureBuilder(
              future: exist(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const Row(
                    children: [Icon(Icons.check_outlined), Text('已在书架')],
                  );
                } else {
                  return const Row(
                    children: [Icon(Icons.library_add_outlined), Text('加入书架')],
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => startReader(context),
              child: Watcher((context, ref, child) {
                final book = ref.watch(currentBookCreator);
                final hasProgress = book.cursor != 0 || book.index != 0;
                String text = hasProgress ? '继续阅读' : '立即阅读';
                return Text(text);
              }),
            ),
          ),
        ],
      ),
    );
  }

  void updateShelf() async {
    final ref = context.ref;
    final book = await exist();
    if (book != null) {
      await isar.writeTxn(() async {
        await isar.books.delete(book.id);
      });
      CacheManager(prefix: book.name).clearCache();
    } else {
      final currentBook = ref.read(currentBookCreator);
      await isar.writeTxn(() async {
        isar.books.put(currentBook);
      });
    }
    final books = await isar.books.where().findAll();
    books.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    ref.set(booksCreator, books);
    setState(() {});
  }

  Future<Book?> exist() async {
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final name = book.name;
    final author = book.author;
    var builder = isar.books.filter();
    builder = builder.nameEqualTo(name);
    final exist = await builder.authorEqualTo(author).findFirst();
    return exist;
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
    final ref = context.ref;
    final availableSources = widget.book.sources;
    for (var availableSource in availableSources) {
      final source =
          await isar.sources.filter().idEqualTo(availableSource.id).findFirst();
      if (source != null) {
        final duration = ref.read(cacheDurationCreator);
        final timeout = ref.read(timeoutCreator);
        final information = await Parser.getInformation(
          widget.book.name,
          availableSource.url,
          source,
          Duration(hours: duration.floor()),
          Duration(milliseconds: timeout),
        );
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
