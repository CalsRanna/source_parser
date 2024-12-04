import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/model/reader_state.dart';
import 'package:source_parser/model/reader_theme.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/splitter.dart';

part 'reader.g.dart';

@riverpod
class ReaderStateNotifier extends _$ReaderStateNotifier {
  @override
  Future<ReaderState> build(Book book) async {
    var currentChapterPages = await _getCurrentChapterPages();
    return ReaderState()
      ..book = book
      ..currentChapterPages = currentChapterPages;
  }

  Future<List<TextSpan>> _getCurrentChapterPages() async {
    var setting = await ref.read(settingNotifierProvider.future);
    var timeout = Duration(milliseconds: setting.timeout);
    var source =
        await isar.sources.filter().idEqualTo(book.sourceId).findFirst();
    if (source == null) return [];
    var chapter = await Parser.getContent(
      name: book.name,
      source: source,
      timeout: timeout,
      title: book.chapters[book.index].name,
      url: book.chapters[book.index].url,
    );
    var theme = await ref.watch(readerThemeNotifierProvider.future);
    var size = await ref.watch(readerSizeNotifierProvider.future);
    return Splitter(size: size, theme: theme).split(chapter);
  }
}

@riverpod
class ReaderThemeNotifier extends _$ReaderThemeNotifier {
  @override
  Future<ReaderTheme> build() async {
    final provider = settingNotifierProvider;
    var setting = await ref.watch(provider.future);
    Color backgroundColor = Color(setting.backgroundColor);
    Color fontColor = Colors.black.withOpacity(0.75);
    Color variantFontColor = Colors.black.withOpacity(0.5);
    if (setting.darkMode) {
      backgroundColor = Colors.black;
      fontColor = Colors.white.withOpacity(0.75);
      variantFontColor = Colors.white.withOpacity(0.5);
    }
    final lineSpace = setting.lineSpace;
    final fontSize = setting.fontSize.toDouble();
    var theme = ReaderTheme();
    final mediaQueryData = ref.watch(mediaQueryDataNotifierProvider);
    final padding = mediaQueryData.padding;
    double bottom = 20;
    if (Platform.isAndroid) bottom = max(padding.bottom + 4, 16.0);
    final top = max(padding.top + 4, 16.0);
    theme = theme.copyWith(
      backgroundColor: backgroundColor,
      chapterStyle: theme.chapterStyle.copyWith(color: fontColor),
      footerPadding: theme.footerPadding.copyWith(bottom: bottom),
      footerStyle: theme.footerStyle.copyWith(color: variantFontColor),
      headerPadding: theme.headerPadding.copyWith(top: top),
      headerStyle: theme.headerStyle.copyWith(color: variantFontColor),
      pageStyle: theme.pageStyle.copyWith(
        color: fontColor,
        fontSize: fontSize,
        height: lineSpace,
      ),
    );
    print(theme.pageStyle);
    return theme;
  }
}

@riverpod
class ReaderSizeNotifier extends _$ReaderSizeNotifier {
  @override
  Future<Size> build() async {
    var mediaQueryData = ref.watch(mediaQueryDataNotifierProvider);
    var screenSize = mediaQueryData.size;
    var theme = await ref.watch(readerThemeNotifierProvider.future);
    var headerHeight = theme.headerStyle.fontSize! * theme.headerStyle.height!;
    var headerPadding = theme.headerPadding.vertical;
    var footerHeight = theme.footerStyle.fontSize! * theme.footerStyle.height!;
    var footerPadding = theme.footerPadding.vertical;
    var width = screenSize.width - theme.pagePadding.horizontal;
    var height = screenSize.height - theme.pagePadding.vertical;
    height -= headerHeight + headerPadding;
    height -= footerHeight + footerPadding;
    return Size(width, height);
  }
}

@Riverpod(keepAlive: true)
class MediaQueryDataNotifier extends _$MediaQueryDataNotifier {
  @override
  MediaQueryData build() => MediaQueryData();

  void updateSize(MediaQueryData data) {
    state = data;
  }
}
