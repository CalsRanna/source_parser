import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/reader_state.dart';
import 'package:source_parser/view_model/app_theme_view_model.dart';

class ReaderHelperViewModel {
  final mediaQueryData = signal<MediaQueryData>(MediaQueryData());
  final readerSize = signal<Size>(Size.zero);
  final readerState = signal<ReaderState>(ReaderState());
  final themeViewModel = AppThemeViewModel();

  Future<void> initSignals() async {
    await themeViewModel.initSignals();
  }

  void updateMediaQueryData(MediaQueryData data) {
    mediaQueryData.value = data;
    _calculateReaderSize();
  }

  void updateReaderState(ReaderState state) {
    readerState.value = state;
  }

  Future<void> _calculateReaderSize() async {
    final theme = themeViewModel.currentTheme.value;
    final mediaQueryDataValue = mediaQueryData.value;

    final pagePaddingHorizontal =
        theme.contentPaddingLeft + theme.contentPaddingRight;
    final pagePaddingVertical =
        theme.contentPaddingTop + theme.contentPaddingBottom;
    var width = mediaQueryDataValue.size.width - pagePaddingHorizontal;
    final headerPaddingVertical =
        theme.headerPaddingBottom + theme.headerPaddingTop;
    final footerPaddingVertical =
        theme.footerPaddingBottom + theme.footerPaddingTop;
    var height = mediaQueryDataValue.size.height - pagePaddingVertical;
    height -= headerPaddingVertical;
    height -= (theme.headerFontSize * theme.headerHeight);
    height -= footerPaddingVertical;
    height -= (theme.footerFontSize * theme.footerHeight);

    readerSize.value = Size(width, height);
  }

  ReaderState get currentReaderState => readerState.value;

  Size get currentReaderSize => readerSize.value;
}
