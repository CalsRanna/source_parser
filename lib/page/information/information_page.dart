import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/information/information_archive_view.dart';
import 'package:source_parser/page/information/information_available_source_view.dart';
import 'package:source_parser/page/information/information_catalogue_view.dart';
import 'package:source_parser/page/information/information_description_view.dart';
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
  ConsumerState<InformationPage> createState() => _InformationPageState();
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

class _InformationPageState extends ConsumerState<InformationPage> {
  bool loading = false;

  late final viewModel = GetIt.instance<InformationViewModel>(
    param1: widget.book.id,
  );

  @override
  Widget build(BuildContext context) {
    var body = EasyRefresh(
      onRefresh: () => getInformation(ref),
      child: CustomScrollView(slivers: [_buildAppBar(), _buildList(context)]),
    );
    var bottomNavigationBar = Watch(
      (_) => _BottomBar(
        book: widget.book,
        isInShelf: viewModel.isInShelf.value,
        onIsInShelfChanged: () => viewModel.changeIsInShelf(widget.book),
      ),
    );
    return Scaffold(body: body, bottomNavigationBar: bottomNavigationBar);
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

  SliverAppBar _buildAppBar() {
    var children = [
      _BackgroundImage(url: widget.book.cover),
      const _ColorFilter(),
      _Information(book: widget.book),
    ];
    var flexibleSpaceBar = FlexibleSpaceBar(
      background: Stack(children: children),
      collapseMode: CollapseMode.pin,
    );
    return SliverAppBar(
      expandedHeight: 200,
      flexibleSpace: flexibleSpaceBar,
      pinned: true,
      stretch: true,
    );
  }

  SliverList _buildList(BuildContext context) {
    var catalogue = Watch(
      (_) => InformationCatalogueView(
        book: widget.book,
        chapters: viewModel.chapters.value,
        loading: loading,
      ),
    );
    var availableSource = Watch(
      (_) => InformationAvailableSourceView(
        availableSources: [],
        currentSource: viewModel.currentSource.value,
        onTap: () => viewModel.navigateAvailableSourcePage(context),
        // sources: book.sources,
      ),
    );
    var children = [
      InformationDescriptionView(book: widget.book),
      const SizedBox(height: 8),
      catalogue,
      const SizedBox(height: 8),
      availableSource,
      const SizedBox(height: 8),
      InformationArchiveView(isArchive: widget.book.archive),
    ];
    return SliverList(delegate: SliverChildListDelegate(children));
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
