import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/information/information_view_model.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/book_cover.dart';

@RoutePage()
class InformationPage extends ConsumerStatefulWidget {
  final BookEntity book;
  const InformationPage({super.key, required this.book});

  @override
  ConsumerState<InformationPage> createState() => _InformationState();
}

class _Archive extends ConsumerWidget {
  final bool isArchive;
  const _Archive({required this.isArchive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var surfaceTint = colorScheme.surfaceTint;
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    var switchWidget = Switch(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: isArchive,
      onChanged: (value) {},
    );
    var children = [
      const Text('归档', style: boldTextStyle),
      const Spacer(),
      switchWidget
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Row(children: children)],
    );
    var padding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: column,
    );
    var card = Card(
      color: surfaceTint.withValues(alpha: 0.05),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: padding,
    );
    return GestureDetector(onTap: () => handleTap(context, ref), child: card);
  }

  void handleTap(BuildContext context, WidgetRef ref) async {
    // final message = Message.of(context);
    // final notifier = ref.read(bookNotifierProvider.notifier);
    // await notifier.toggleArchive();
    // final book = ref.read(bookNotifierProvider);
    // if (book.archive) {
    //   message.show('归档后，书架不再更新');
    // }
  }
}

class _AvailableSource extends StatelessWidget {
  final List<AvailableSourceEntity> availableSources;
  final AvailableSourceEntity currentSource;
  final void Function()? onTap;

  const _AvailableSource({
    required this.availableSources,
    required this.currentSource,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    var name = '';
    if (currentSource.name.isNotEmpty) {
      name = '${currentSource.name} · ';
    }
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var surfaceTint = colorScheme.surfaceTint;
    var text = Text(
      '$name可用${availableSources.length}个',
      textAlign: TextAlign.right,
    );
    var children = [
      const Text('书源', style: boldTextStyle),
      Expanded(child: text),
      const Icon(HugeIcons.strokeRoundedArrowRight01)
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Row(children: children)],
    );
    var card = Card(
      color: surfaceTint.withValues(alpha: 0.05),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: Padding(padding: const EdgeInsets.all(16.0), child: column),
    );
    return GestureDetector(onTap: onTap, child: card);
  }
}

class _BackgroundImage extends StatelessWidget {
  final String url;

  const _BackgroundImage({required this.url});

  @override
  Widget build(BuildContext context) {
    var bookCover = BookCover(
      height: double.infinity,
      url: url,
      width: double.infinity,
    );
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: bookCover,
    );
  }
}

class _BottomBar extends StatelessWidget {
  final BookEntity book;
  final bool isInShelf;
  final void Function()? onIsInShelfChanged;
  const _BottomBar({
    required this.book,
    required this.isInShelf,
    this.onIsInShelfChanged,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final icon = Icon(
      isInShelf
          ? HugeIcons.strokeRoundedTick02
          : HugeIcons.strokeRoundedLibrary,
    );
    final shelfText = Text(isInShelf ? '已在书架' : '加入书架');
    return Container(
      color: Theme.of(context).colorScheme.surfaceTint.withValues(alpha: 0.05),
      padding: EdgeInsets.fromLTRB(16, 8, 16, padding.bottom + 8),
      child: Row(
        children: [
          TextButton(
            onPressed: onIsInShelfChanged,
            child: Row(children: [icon, shelfText]),
          ),
          // const SizedBox(width: 8),
          // const Expanded(child: _ListenBook()),
          const SizedBox(width: 8),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final book = ref.watch(bookNotifierProvider);
              final hasProgress = book.cursor != 0 || book.index != 0;
              String readerText = hasProgress ? '继续阅读' : '立即阅读';
              return FilledButton(
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
    // final navigator = Navigator.of(context);
    // navigator.popUntil(_predicate);
    var book = ref.read(bookNotifierProvider);
    AutoRouter.of(context).push(ReaderRoute(book: book));
    final bookNotifier = ref.read(bookNotifierProvider.notifier);
    bookNotifier.startReader(index: index);
  }

  void toggleShelf(WidgetRef ref) async {
    // var provider = inShelfProvider(book);
    // final notifier = ref.read(provider.notifier);
    // notifier.toggleShelf();
  }
}

class _Catalogue extends StatelessWidget {
  final BookEntity book;

  final bool loading;
  const _Catalogue({
    required this.book,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        onTap: () => handleTap(context, ref),
        child: Card(
          color:
              Theme.of(context).colorScheme.surfaceTint.withValues(alpha: 0.05),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('目录', style: boldTextStyle),
                const Spacer(),
                // if (loading && book.chapters.isEmpty)
                //   SizedBox(
                //     height: 24,
                //     width: eInkMode ? null : 24,
                //     child: const LoadingIndicator(),
                //   ),
                // if (!loading || book.chapters.isNotEmpty) ...[
                //   Text(
                //     '共${book.chapters.length}章',
                //     textAlign: TextAlign.right,
                //   ),
                //   const Icon(HugeIcons.strokeRoundedArrowRight01)
                // ]
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
    return Container(color: primary.withValues(alpha: 0.25));
  }
}

class _Information extends StatelessWidget {
  final BookEntity book;

  const _Information({required this.book});

  @override
  Widget build(BuildContext context) {
    const nameTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
    const icon = Icon(
      HugeIcons.strokeRoundedArrowRight01,
      color: Colors.white,
      size: 14,
    );
    var spanTextStyle = TextStyle(color: Colors.white.withValues(alpha: 0.85));
    var authorRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text(book.author), icon],
    );
    var gestureDetector = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => searchSameAuthor(context),
      child: authorRow,
    );
    var columnChildren = [
      Text(book.name, style: nameTextStyle),
      gestureDetector,
      Text(_buildSpan(book), style: spanTextStyle),
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
    var defaultTextStyle = DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.white, height: 1.6),
      child: column,
    );
    var rowChildren = [
      GestureDetector(
        onLongPress: () => handleLongPress(context),
        child: BookCover(height: 120, url: book.cover, width: 90),
      ),
      const SizedBox(width: 16),
      Expanded(child: defaultTextStyle)
    ];
    var row = Row(children: rowChildren);
    return Positioned(bottom: 16, left: 16, right: 16, child: row);
  }

  void handleLongPress(BuildContext context) {
    HapticFeedback.heavyImpact();
    CoverSelectorRoute(book: book).push(context);
  }

  void searchSameAuthor(BuildContext context) {
    AutoRouter.of(context).push(SearchRoute(credential: book.author));
  }

  String _buildSpan(BookEntity book) {
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

class _InformationState extends ConsumerState<InformationPage> {
  bool loading = false;

  late final viewModel = GetIt.instance<InformationViewModel>(
    param1: widget.book.id,
  );

  @override
  Widget build(BuildContext context) {
    // final provider = ref.watch(settingNotifierProvider);
    // final setting = switch (provider) {
    //   AsyncData(:final value) => value,
    //   _ => Setting(),
    // };
    // final eInkMode = setting.eInkMode;
    // final sourceProvider = ref.watch(currentSourceProvider);
    // final source = switch (sourceProvider) {
    //   AsyncData(:final value) => value,
    //   _ => null,
    // };
    return Scaffold(
      body: EasyRefresh(
        onRefresh: () => getInformation(ref),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    _BackgroundImage(url: widget.book.cover),
                    const _ColorFilter(),
                    _Information(book: widget.book),
                  ],
                ),
                collapseMode: CollapseMode.pin,
              ),
              pinned: true,
              stretch: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _Introduction(book: widget.book),
                const SizedBox(height: 8),
                _Catalogue(book: widget.book, loading: loading),
                const SizedBox(height: 8),
                Watch(
                  (_) => _AvailableSource(
                    availableSources: [],
                    currentSource: viewModel.currentSource.value,
                    onTap: () => viewModel.navigateAvailableSourcePage(context),
                    // sources: book.sources,
                  ),
                ),
                const SizedBox(height: 8),
                _Archive(isArchive: widget.book.archive),
              ]),
            )
          ],
        ),
      ),
      bottomNavigationBar: Watch(
        (_) => _BottomBar(
          book: widget.book,
          isInShelf: viewModel.isInShelf.value,
          onIsInShelfChanged: () => viewModel.changeIsInShelf(widget.book),
        ),
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
    viewModel.initSignals();
  }
}

class _Introduction extends StatefulWidget {
  final BookEntity book;

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
      color: surfaceTint.withValues(alpha: 0.05),
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
                    color: surfaceTint.withValues(alpha: 0.1),
                    shape: const StadiumBorder(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    HugeIcons.strokeRoundedArrowDown01,
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

// class _ListenBook extends StatelessWidget {
//   const _ListenBook();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final primaryContainer = colorScheme.primaryContainer;
//     final onPrimaryContainer = colorScheme.onPrimaryContainer;
//     return Consumer(builder: (context, ref, child) {
//       return ElevatedButton(
//         style: ButtonStyle(
//           backgroundColor: WidgetStatePropertyAll(primaryContainer),
//           foregroundColor: WidgetStatePropertyAll(onPrimaryContainer),
//         ),
//         onPressed: () => navigate(context, ref),
//         child: const Text('听书'),
//       );
//     });
//   }

//   void navigate(BuildContext context, WidgetRef ref) async {
//     final notifier = ref.read(bookNotifierProvider.notifier);
//     await notifier.refreshCatalogue();
//     final book = ref.read(bookNotifierProvider);
//     if (!context.mounted) return;
//     final navigator = Navigator.of(context);
//     final route = MaterialPageRoute(builder: (context) {
//       return ListenerPage(book: book);
//     });
//     navigator.push(route);
//   }
// }

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
        color: surfaceTint.withValues(alpha: 0.1),
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
