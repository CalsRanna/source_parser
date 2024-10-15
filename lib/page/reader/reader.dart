import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';
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

class _CacheIndicator extends ConsumerWidget {
  const _CacheIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
    final primary = colorScheme.primary;
    final progress = ref.watch(cacheProgressNotifierProvider);
    final innerDecoration = ShapeDecoration(
      color: primary,
      shape: const StadiumBorder(),
    );
    final innerContainer = AnimatedContainer(
      decoration: innerDecoration,
      duration: const Duration(milliseconds: 300),
      height: 160 * progress.progress,
      width: 8,
    );
    final shapeDecoration = ShapeDecoration(
      color: surfaceContainerHighest,
      shape: const StadiumBorder(),
    );
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: shapeDecoration,
      height: 160,
      width: 8,
      child: innerContainer,
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
    List<PageTurningMode> modes = [];
    if (turningMode & 1 != 0) {
      modes.add(PageTurningMode.drag);
    }
    if (turningMode & 2 != 0) {
      modes.add(PageTurningMode.tap);
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
      onCataloguePressed: handleCataloguePressed,
      onChapterChanged: (index) => handleChapterChanged(ref, index),
      onDarkModePressed: () => toggleDarkMode(ref),
      onDetailPressed: handleDetailPressed,
      onMessage: handleMessage,
      onPop: (index, cursor) => handlePop(ref),
      onProgressChanged: (cursor) => handleProgressChanged(ref, cursor),
      onRefresh: (index) => handleRefresh(ref, index),
      onSettingPressed: handleSettingPressed,
      onSourcePressed: handleSourcePressed,
    );
    const indicator = Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: _CacheIndicator(),
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

  void handleCataloguePressed() {
    final book = ref.read(bookNotifierProvider);
    AutoRouter.of(context).push(CatalogueRoute(index: book.index));
  }

  void handleChapterChanged(WidgetRef ref, int index) async {
    final notifier = ref.read(bookNotifierProvider.notifier);
    return notifier.refreshIndex(index);
  }

  void handleDetailPressed() {
    AutoRouter.of(context).push(InformationRoute());
  }

  void handleMessage(String message) {
    Message.of(context).show(message);
  }

  void handlePop(WidgetRef ref) async {
    Navigator.of(context).pop();
    ref.invalidate(booksProvider);
  }

  void handleProgressChanged(WidgetRef ref, int cursor) async {
    final notifier = ref.read(bookNotifierProvider.notifier);
    return notifier.refreshCursor(cursor);
  }

  Future<String> handleRefresh(WidgetRef ref, int index) async {
    final notifier = ref.read(bookNotifierProvider.notifier);
    return notifier.getContent(index, reacquire: true);
  }

  void handleSettingPressed() {
    AutoRouter.of(context).push(ReaderThemeRoute());
  }

  void handleSourcePressed() {
    AutoRouter.of(context).push(AvailableSourceListRoute());
  }

  void toggleDarkMode(WidgetRef ref) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.toggleDarkMode();
  }
}
