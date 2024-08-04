import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/model/reader.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/util/paginator.dart';
import 'package:source_parser/util/theme.dart';

part 'reader.g.dart';

@riverpod
class ReaderNotifier extends _$ReaderNotifier {
  @override
  Future<ReaderState> build() async {
    final mediaQuery = ref.watch(mediaQueryDataNotifierProvider);
    final theme = await ref.watch(readerThemeNotifierProvider.future);
    final paginator = Paginator(size: mediaQuery.size, theme: theme);
    final book = ref.watch(bookNotifierProvider);
    final index = book.index;
    final notifier = ref.read(bookNotifierProvider.notifier);
    final content = await notifier.getContent(index);
    var title = book.name;
    final pages = paginator.paginate(content, title: title);
    return ReaderState()
      ..pages = pages
      ..theme = theme;
  }
}

@Riverpod(keepAlive: true)
class SizeNotifier extends _$SizeNotifier {
  @override
  Size build() => const Size(0, 0);

  void setSize(Size size) => state = size;
}

@Riverpod(keepAlive: true)
class MediaQueryDataNotifier extends _$MediaQueryDataNotifier {
  @override
  MediaQueryData build() => const MediaQueryData();

  void setMediaQueryData(MediaQueryData mediaQueryData) {
    state = mediaQueryData;
  }
}

@riverpod
class ReaderThemeNotifier extends _$ReaderThemeNotifier {
  @override
  Future<ReaderTheme> build() async {
    final setting = await ref.watch(settingNotifierProvider.future);
    final backgroundColor = setting.backgroundColor;
    Color? fontColor;
    Color? variantFontColor;
    if (backgroundColor == Colors.black.value) {
      fontColor = Colors.white.withOpacity(0.75);
      variantFontColor = Colors.white.withOpacity(0.5);
    }
    final lineSpace = setting.lineSpace;
    final fontSize = setting.fontSize;
    // final book = ref.watch(bookNotifierProvider);
    // var index = book.index;
    // var cursor = book.cursor;
    // final length = book.chapters.length;
    // if (length <= index) {
    //   index = length - 1;
    //   cursor = 0;
    // }
    // if (cursor < 0) {
    //   cursor = 0;
    // }
    var theme = ReaderTheme();
    final mediaQueryData = ref.watch(mediaQueryDataNotifierProvider);
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
    // if (darkMode) {
    //   final scheme = Theme.of(context).colorScheme;
    //   theme = theme.copyWith(
    //     backgroundColor: scheme.background,
    //     footerStyle: theme.footerStyle.copyWith(color: scheme.onBackground),
    //     headerStyle: theme.headerStyle.copyWith(color: scheme.onBackground),
    //     pageStyle: theme.pageStyle.copyWith(color: scheme.onBackground),
    //   );
    // }
    return theme;
  }
}
