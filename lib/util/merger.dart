import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/schema/theme.dart';

class Merger {
  final Theme theme;

  final TextStyle _chapterStyle;
  final TextStyle _contentStyle;

  Merger({required this.theme})
      : _chapterStyle = TextStyle(
          color: Color(theme.contentColor),
          decoration: TextDecoration.none,
          fontSize: theme.chapterFontSize,
          fontWeight: FontWeight.values[theme.chapterFontWeight],
          height: theme.chapterHeight,
          letterSpacing: theme.chapterLetterSpacing,
          wordSpacing: theme.chapterWordSpacing,
        ),
        _contentStyle = TextStyle(
          color: Color(theme.contentColor),
          decoration: TextDecoration.none,
          fontSize: theme.contentFontSize,
          fontWeight: FontWeight.values[theme.contentFontWeight],
          height: theme.contentHeight,
          letterSpacing: theme.contentLetterSpacing,
          wordSpacing: theme.contentWordSpacing,
        );

  TextSpan merge(String pageContent) {
    bool isFirstPage = pageContent.startsWith('\n');
    if (isFirstPage) {
      pageContent = pageContent.substring(1); // Remove the marker
    }
    List<String> paragraphs = pageContent.split('\n');
    List<InlineSpan> children = [];
    if (isFirstPage && paragraphs.isNotEmpty) {
      // Add spacing around title using newlines
      var paragraph = '\n${paragraphs.first}\n';
      children.add(TextSpan(text: paragraph, style: _chapterStyle));
      paragraphs.removeAt(0);
    }
    children.addAll(paragraphs.map(_toElement));
    return TextSpan(children: children);
  }

  TextSpan _toElement(String paragraph) {
    return TextSpan(text: '$paragraph\n', style: _contentStyle);
  }
}
