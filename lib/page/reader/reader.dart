import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/reader_theme.dart';
import 'package:source_parser/page/reader/component/indicator.dart';
import 'package:source_parser/page/reader/component/page.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/book_cover.dart';
import 'package:source_parser/widget/reader.dart';

@RoutePage()
class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({super.key});

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
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
    Color? fontColor;
    Color? variantFontColor;
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
    String title = '';
    if (book.chapters.isNotEmpty) {
      title = book.chapters.elementAt(index).name;
    }
    final bookReader = BookReader(
      author: book.author,
      cover: BookCover(height: 48, width: 36, url: book.cover),
      cursor: cursor,
      darkMode: darkMode,
      eInkMode: eInkMode,
      future: (index) => getContent(ref, index),
      index: index,
      modes: modes,
      name: book.name,
      theme: theme,
      title: title,
      total: book.chapters.length,
      onCached: (value) => handleCached(ref, value),
      onChapterChanged: (value) => handleChapterChanged(ref, value),
      onProgressChanged: (value) => handleProgressChanged(ref, value),
    );
    const indicator = Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: CacheIndicator(),
    );
    const align = Align(alignment: Alignment.centerRight, child: indicator);
    return Stack(children: [bookReader, if (caching) align]);
  }

  @override
  void deactivate() {
    ref.invalidate(booksProvider);
    super.deactivate();
  }

  Future<String> getContent(WidgetRef ref, int index) async {
    // Get content while page animation stopped, should override the animation instead
    await Future.delayed(const Duration(milliseconds: 300));
    final notifier = ref.read(bookNotifierProvider.notifier);
    final content = await notifier.getContent(index);
    // final paginator =
    //     Paginator(size: Size(100, 100), text: content, theme: ReaderTheme());
    // paginator.paginate(content);
    return content;
  }

  void handleCached(WidgetRef ref, int amount) async {
    setState(() {
      caching = true;
    });
    final notifier = ref.read(cacheProgressNotifierProvider.notifier);
    await notifier.cacheChapters(amount: amount);
    if (!mounted) return;
    final message = Message.of(context);
    final progress = ref.read(cacheProgressNotifierProvider);
    message.show('缓存完毕，${progress.succeed}章成功，${progress.failed}章失败');
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      caching = false;
    });
  }

  void handleChapterChanged(WidgetRef ref, int index) {
    var provider = bookNotifierProvider;
    var notifier = ref.read(provider.notifier);
    notifier.updateChapter(index);
  }

  void handleProgressChanged(WidgetRef ref, int value) {
    var provider = bookNotifierProvider;
    var notifier = ref.read(provider.notifier);
    notifier.updateCursor(value);
  }
}
