import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/reader_text_style.dart';

class Merger {
  final Theme theme;
  final ReaderTextStyle _styles;

  Merger({required this.theme}) : _styles = ReaderTextStyle(theme: theme);

  TextSpan merge(String pageContent, {bool isFirstPage = false}) {
    if (isFirstPage) {
      pageContent = pageContent.substring(1); // Remove the marker
    }
    return _styles.buildTextSpan(pageContent, isFirstPage: isFirstPage);
  }
}
