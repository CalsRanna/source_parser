import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/page/listener.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/book_cover.dart';
import 'package:source_parser/widget/loading.dart';

@RoutePage()
class InformationPage extends ConsumerStatefulWidget {
  const InformationPage({super.key});

  @override
  ConsumerState<InformationPage> createState() {
    return _BookInformationState();
  }
}

class _Archive extends StatelessWidget {
  const _Archive();

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    return Consumer(builder: (context, ref, child) {
      final book = ref.watch(bookNotifierProvider);
      return GestureDetector(
        onTap: () => handleTap(context, ref),
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
                    Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: book.archive,
                      onChanged: (value) => handleTap(context, ref),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void handleTap(BuildContext context, WidgetRef ref) async {
    final message = Message.of(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    await notifier.toggleArchive();
    final book = ref.read(bookNotifierProvider);
    if (book.archive) {
      message.show('归档后，书架不再更新');
    }
  }
}

class _BackgroundImage extends StatelessWidget {
  final String url;

  const _BackgroundImage({required this.url});

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

class _BookInformationState extends ConsumerState<InformationPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(settingNotifierProvider);
    final setting = switch (provider) {
      AsyncData(:final value) => value,
      _ => Setting(),
    };
    final book = ref.watch(bookNotifierProvider);
    final eInkMode = setting.eInkMode;
    final sourceProvider = ref.watch(currentSourceProvider);
    final source = switch (sourceProvider) {
      AsyncData(:final value) => value,
      _ => null,
    };
    return RefreshIndicator(
      onRefresh: () => getInformation(ref),
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
                // const SizedBox(height: 8),
                _Catalogue(book: book, eInkMode: eInkMode, loading: loading),
                const SizedBox(height: 8),
                _Source(
                  currentSource: source?.name,
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
  }

  Future<void> getInformation(WidgetRef ref) async {
    final message = Message.of(context);
    setState(() {
      loading = true;
    });
    try {
      final notifier = ref.read(bookNotifierProvider.notifier);
      await notifier.refreshInformation();
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

  @override
  void initState() {
    super.initState();
    getInformation(ref);
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Container(
      color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05),
      padding: EdgeInsets.fromLTRB(16, 8, 16, padding.bottom + 8),
      child: Row(
        children: [
          Consumer(builder: (context, ref, child) {
            final provider = ref.watch(inShelfProvider);
            final inShelf = switch (provider) {
              AsyncData(:final value) => value,
              _ => false,
            };
            final icon = Icon(
              inShelf ? Icons.check_outlined : Icons.library_add_outlined,
            );
            final shelfText = Text(inShelf ? '已在书架' : '加入书架');
            return TextButton(
              onPressed: () => toggleShelf(ref),
              child: Row(children: [icon, shelfText]),
            );
          }),
          // const SizedBox(width: 8),
          // const Expanded(child: _ListenBook()),
          const SizedBox(width: 8),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final book = ref.watch(bookNotifierProvider);
              final hasProgress = book.cursor != 0 || book.index != 0;
              String readerText = hasProgress ? '继续阅读' : '立即阅读';
              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              final primary = colorScheme.primary;
              final onPrimary = colorScheme.onPrimary;
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primary),
                  foregroundColor: WidgetStatePropertyAll(onPrimary),
                ),
                onPressed: () => startReader(context, ref, book.index),
                child: Text(readerText),
              );
            }),
          ),
        ],
      ),
    );
  }

  void startReader(BuildContext context, WidgetRef ref, int index) async {
    final navigator = Navigator.of(context);
    navigator.popUntil(_predicate);
    AutoRouter.of(context).push(ReaderRoute());
    final bookNotifier = ref.read(bookNotifierProvider.notifier);
    bookNotifier.startReader(index: index);
  }

  void toggleShelf(WidgetRef ref) async {
    final notifier = ref.read(inShelfProvider.notifier);
    notifier.toggleShelf();
  }

  bool _predicate(Route<dynamic> route) {
    return ModalRoute.withName('bookInformation').call(route) ||
        ModalRoute.withName('home').call(route);
  }
}

class _ListenBook extends StatelessWidget {
  const _ListenBook();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryContainer = colorScheme.primaryContainer;
    final onPrimaryContainer = colorScheme.onPrimaryContainer;
    return Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primaryContainer),
          foregroundColor: WidgetStatePropertyAll(onPrimaryContainer),
        ),
        onPressed: () => navigate(context, ref),
        child: const Text('听书'),
      );
    });
  }

  void navigate(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(bookNotifierProvider.notifier);
    await notifier.refreshCatalogue();
    final book = ref.read(bookNotifierProvider);
    if (!context.mounted) return;
    final navigator = Navigator.of(context);
    final route = MaterialPageRoute(builder: (context) {
      return ListenerPage(book: book);
    });
    navigator.push(route);
  }
}

class _Catalogue extends StatelessWidget {
  final Book book;

  final bool eInkMode;
  final bool loading;
  const _Catalogue({
    required this.book,
    this.eInkMode = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        onTap: () => handleTap(context, ref),
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
    });
  }

  void handleTap(BuildContext context, WidgetRef ref) {
    if (loading) return;
    final book = ref.read(bookNotifierProvider);
    AutoRouter.of(context).push(CatalogueRoute(index: book.index));
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
  final Book book;

  const _Information({required this.book});

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
        return BookCoverSelector(book: book);
      },
    );
  }

  void searchSameAuthor(BuildContext context) {
    AutoRouter.of(context).push(SearchRoute(credential: book.author));
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
  final Book book;

  const _Introduction({required this.book});

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

class _Source extends StatelessWidget {
  final String? currentSource;

  final List<AvailableSource> sources;
  const _Source({this.currentSource, required this.sources});

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
    AutoRouter.of(context).push(AvailableSourceListRoute());
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

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
