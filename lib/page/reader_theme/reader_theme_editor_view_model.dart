import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/theme_service.dart';
import 'package:source_parser/schema/theme.dart' as schema;
import 'package:source_parser/util/color_extension.dart';

class ReaderThemeEditorViewModel {
  final theme = signal(schema.Theme());

  void initSignals(schema.Theme theme) {
    this.theme.value = theme;
  }

  Future<void> storeTheme() async {
    var service = ThemeService();
    if (theme.value.id == 0) {
      await service.addTheme(theme.value);
    } else {
      await service.updateTheme(theme.value);
    }
  }

  void updateBackgroundColor(Color color) {
    theme.value = theme.value.copyWith(
      backgroundColor: color.toHex(),
    );
  }

  void updateBackgroundImage(String image) {
    theme.value = theme.value.copyWith(
      backgroundImage: image,
    );
  }

  void updateChapterFontSize(double value) {
    theme.value = theme.value.copyWith(
      chapterFontSize: value,
    );
  }

  void updateChapterFontWeight(double value) {
    theme.value = theme.value.copyWith(
      chapterFontWeight: value.toInt() - 1,
    );
  }

  void updateChapterHeight(double value) {
    theme.value = theme.value.copyWith(
      chapterHeight: value,
    );
  }

  void updateChapterLetterSpacing(double value) {
    theme.value = theme.value.copyWith(
      chapterLetterSpacing: value,
    );
  }

  void updateChapterWordSpacing(double value) {
    theme.value = theme.value.copyWith(
      chapterWordSpacing: value,
    );
  }

  void updateContentFontSize(double value) {
    theme.value = theme.value.copyWith(
      contentFontSize: value,
    );
  }

  void updateContentFontWeight(double value) {
    theme.value = theme.value.copyWith(
      contentFontWeight: value.toInt() - 1,
    );
  }

  void updateContentHeight(double value) {
    theme.value = theme.value.copyWith(
      contentHeight: value,
    );
  }

  void updateContentLetterSpacing(double value) {
    theme.value = theme.value.copyWith(
      contentLetterSpacing: value,
    );
  }

  void updateContentPaddingBottom(double value) {
    theme.value = theme.value.copyWith(
      contentPaddingBottom: value,
    );
  }

  void updateContentPaddingLeft(double value) {
    theme.value = theme.value.copyWith(
      contentPaddingLeft: value,
    );
  }

  void updateContentPaddingRight(double value) {
    theme.value = theme.value.copyWith(
      contentPaddingRight: value,
    );
  }

  void updateContentPaddingTop(double value) {
    theme.value = theme.value.copyWith(
      contentPaddingTop: value,
    );
  }

  void updateContentWordSpacing(double value) {
    theme.value = theme.value.copyWith(
      contentWordSpacing: value,
    );
  }

  void updateFooterFontSize(double value) {
    theme.value = theme.value.copyWith(
      footerFontSize: value,
    );
  }

  void updateFooterFontWeight(double value) {
    theme.value = theme.value.copyWith(
      footerFontWeight: value.toInt() - 1,
    );
  }

  void updateFooterHeight(double value) {
    theme.value = theme.value.copyWith(
      footerHeight: value,
    );
  }

  void updateFooterLetterSpacing(double value) {
    theme.value = theme.value.copyWith(
      footerLetterSpacing: value,
    );
  }

  void updateFooterPaddingBottom(double value) {
    theme.value = theme.value.copyWith(
      footerPaddingBottom: value,
    );
  }

  void updateFooterPaddingLeft(double value) {
    theme.value = theme.value.copyWith(
      footerPaddingLeft: value,
    );
  }

  void updateFooterPaddingRight(double value) {
    theme.value = theme.value.copyWith(
      footerPaddingRight: value,
    );
  }

  void updateFooterPaddingTop(double value) {
    theme.value = theme.value.copyWith(
      footerPaddingTop: value,
    );
  }

  void updateFooterWordSpacing(double value) {
    theme.value = theme.value.copyWith(
      footerWordSpacing: value,
    );
  }

  void updateHeaderFontSize(double value) {
    theme.value = theme.value.copyWith(
      headerFontSize: value,
    );
  }

  void updateHeaderFontWeight(double value) {
    theme.value = theme.value.copyWith(
      headerFontWeight: value.toInt() - 1,
    );
  }

  void updateHeaderHeight(double value) {
    theme.value = theme.value.copyWith(
      headerHeight: value,
    );
  }

  void updateHeaderLetterSpacing(double value) {
    theme.value = theme.value.copyWith(
      headerLetterSpacing: value,
    );
  }

  void updateHeaderPaddingBottom(double value) {
    theme.value = theme.value.copyWith(
      headerPaddingBottom: value,
    );
  }

  void updateHeaderPaddingLeft(double value) {
    theme.value = theme.value.copyWith(
      headerPaddingLeft: value,
    );
  }

  void updateHeaderPaddingRight(double value) {
    theme.value = theme.value.copyWith(
      headerPaddingRight: value,
    );
  }

  void updateHeaderPaddingTop(double value) {
    theme.value = theme.value.copyWith(
      headerPaddingTop: value,
    );
  }

  void updateHeaderWordSpacing(double value) {
    theme.value = theme.value.copyWith(
      headerWordSpacing: value,
    );
  }
}
