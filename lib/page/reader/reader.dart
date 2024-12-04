import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/reader_state.dart';
import 'package:source_parser/model/reader_theme.dart';
import 'package:source_parser/page/reader/component/background.dart';
import 'package:source_parser/page/reader/component/indicator.dart';
import 'package:source_parser/page/reader/component/overlay.dart';
import 'package:source_parser/page/reader/component/page.dart';
import 'package:source_parser/page/reader/component/page_revisited.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/reader.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/book_cover.dart';
import 'package:source_parser/widget/reader.dart';

class BookReaderRevisited extends StatefulWidget {
  final Book book;
  const BookReaderRevisited({super.key, required this.book});

  @override
  State<BookReaderRevisited> createState() => _BookReaderRevisitedState();
}

@RoutePage()
class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({super.key});

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _BookReaderRevisitedState extends State<BookReaderRevisited> {
  bool showOverlay = false;
  bool showCache = false;

  @override
  Widget build(BuildContext context) {
    var readerOverlay = ReaderOverlay(
      onCached: handleCached,
      onRemoved: handleRemoved,
      title: widget.book.name,
    );
    var children = [
      _ReaderBackground(),
      _ReaderPage(book: widget.book, onTap: handleTap),
      if (showCache) _ReaderCacheIndicator(),
      if (showOverlay) readerOverlay,
    ];
    return Stack(children: children);
  }

  void handleCached(int amount) async {
    setState(() {
      showCache = true;
    });
    var container = ProviderScope.containerOf(context);
    final notifier = container.read(cacheProgressNotifierProvider.notifier);
    await notifier.cacheChapters(amount: amount);
    if (!mounted) return;
    final message = Message.of(context);
    final progress = container.read(cacheProgressNotifierProvider);
    message.show('缓存完毕，${progress.succeed}章成功，${progress.failed}章失败');
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      showCache = false;
    });
  }

  void handleRemoved() {
    setState(() {
      showOverlay = false;
    });
  }

  void handleTap() {
    setState(() {
      showOverlay = true;
    });
  }
}

class _ReaderBackground extends ConsumerWidget {
  const _ReaderBackground();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(readerThemeNotifierProvider).valueOrNull;
    return ReaderBackground(theme: theme ?? ReaderTheme());
  }
}

class _ReaderCacheIndicator extends StatelessWidget {
  const _ReaderCacheIndicator();

  @override
  Widget build(BuildContext context) {
    const indicator = Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: CacheIndicator(),
    );
    return Align(alignment: Alignment.centerRight, child: indicator);
  }
}

class _ReaderPage extends ConsumerWidget {
  final Book book;
  final void Function()? onTap;
  const _ReaderPage({required this.book, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(readerThemeNotifierProvider).valueOrNull;
    var provider = readerStateNotifierProvider(book);
    var state = ref.watch(provider);
    var page = switch (state) {
      AsyncData(:final value) => _buildData(value, theme ?? ReaderTheme()),
      AsyncError(:final error, :final stackTrace) =>
        _buildError(ref, error, stackTrace, theme ?? ReaderTheme()),
      AsyncLoading() => _buildLoading(),
      _ => const SizedBox(),
    };
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: page,
    );
  }

  Widget _buildData(ReaderState state, ReaderTheme theme) {
    if (state.currentChapterPages.isEmpty) {
      return BookReaderPageRevisited.builder(
        builder: () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('空空如也'),
            SizedBox(width: double.infinity),
            TextButton(onPressed: () {}, child: Text('重试'))
          ],
        ),
        eInkMode: false,
        modes: [],
        pageIndex: state.pageIndex,
        title: state.book.name,
        theme: theme,
      );
    }
    return PageView.builder(
      itemBuilder: (_, index) => _itemBuilder(state, theme, index),
      itemCount: state.currentChapterPages.length,
    );
  }

  Widget _buildError(
      WidgetRef ref, Object error, StackTrace stackTrace, ReaderTheme theme) {
    return BookReaderPageRevisited.builder(
      builder: () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error.toString()),
            Text(stackTrace.toString()),
          ],
        ),
      ),
      eInkMode: false,
      modes: [],
      pageIndex: 0,
      title: '',
      theme: theme,
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _itemBuilder(ReaderState state, ReaderTheme theme, int index) {
    return BookReaderPageRevisited(
      eInkMode: false,
      modes: [],
      textSpan: state.currentChapterPages[index],
      pageIndex: state.pageIndex,
      title: state.book.name,
      theme: theme,
    );
  }
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  bool caching = false;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(settingNotifierProvider);
    final setting = switch (provider) {
      AsyncData(:final value) => value,
      _ => Setting(),
    };
    final backgroundColor = setting.backgroundColor;
    Color fontColor = Colors.black.withOpacity(0.75);
    Color variantFontColor = Colors.black.withOpacity(0.5);
    if (backgroundColor == Colors.black.value) {
      fontColor = Colors.white.withOpacity(0.75);
      variantFontColor = Colors.white.withOpacity(0.5);
    }
    final darkMode = setting.darkMode;
    final eInkMode = setting.eInkMode;
    final turningMode = setting.turningMode;
    final lineSpace = setting.lineSpace;
    final fontSize = setting.fontSize;
    final book = ref.watch(bookNotifierProvider);
    var index = book.index;
    var cursor = book.cursor;
    final length = book.chapters.length;
    if (length <= index) {
      index = length - 1;
      cursor = 0;
    }
    if (cursor < 0) {
      cursor = 0;
    }
    var theme = ReaderTheme();
    final mediaQueryData = MediaQuery.of(context);
    final padding = mediaQueryData.padding;
    double bottom;
    if (Platform.isAndroid) {
      bottom = max(padding.bottom + 4, 16.0);
    } else {
      bottom = 20;
    }
    final top = max(padding.top + 4, 16.0);
    theme = theme.copyWith(
      backgroundColor: Color(backgroundColor),
      footerPadding: theme.footerPadding.copyWith(bottom: bottom),
      footerStyle: theme.footerStyle.copyWith(color: variantFontColor),
      headerPadding: theme.headerPadding.copyWith(top: top),
      headerStyle: theme.headerStyle.copyWith(color: variantFontColor),
      pageStyle: theme.pageStyle.copyWith(
        color: fontColor,
        fontSize: fontSize.toDouble(),
        height: lineSpace,
      ),
    );
    if (darkMode) {
      final scheme = Theme.of(context).colorScheme;
      theme = theme.copyWith(
        backgroundColor: Colors.black,
        footerStyle: theme.footerStyle.copyWith(color: scheme.onSurface),
        headerStyle: theme.headerStyle.copyWith(color: scheme.onSurface),
        pageStyle: theme.pageStyle.copyWith(color: scheme.onSurface),
      );
    }
    List<ReaderPageTurningMode> modes = [];
    if (turningMode & 1 != 0) {
      modes.add(ReaderPageTurningMode.drag);
    }
    if (turningMode & 2 != 0) {
      modes.add(ReaderPageTurningMode.tap);
    }
    // String title = '';
    // if (book.chapters.isNotEmpty) {
    //   title = book.chapters.elementAt(index).name;
    // }
    // final bookReader = BookReader(
    //   author: book.author,
    //   cover: BookCover(height: 48, width: 36, url: book.cover),
    //   cursor: cursor,
    //   darkMode: darkMode,
    //   eInkMode: eInkMode,
    //   index: index,
    //   modes: modes,
    //   name: book.name,
    //   theme: theme,
    //   title: title,
    //   total: book.chapters.length,
    // );
    const indicator = Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: CacheIndicator(),
    );
    const align = Align(alignment: Alignment.centerRight, child: indicator);
    // return Stack(children: [bookReader, if (caching) align]);
    return Stack(
      children: [BookReaderRevisited(book: book), if (caching) align],
    );
  }
}
