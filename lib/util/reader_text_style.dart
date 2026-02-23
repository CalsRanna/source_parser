import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/string_extension.dart';

/// Shared text styles and TextSpan building for the reader.
///
/// Used by both [Splitter] (for layout measurement) and [Merger] (for rendering)
/// to ensure consistent text styling.
class ReaderTextStyle {
  final TextStyle chapterStyle;
  final TextStyle contentStyle;

  ReaderTextStyle({required Theme theme})
      : chapterStyle = TextStyle(
          color: theme.contentColor.toColor(),
          decoration: TextDecoration.none,
          fontSize: theme.chapterFontSize,
          fontWeight: FontWeight.values[theme.chapterFontWeight],
          height: theme.chapterHeight,
          letterSpacing: theme.chapterLetterSpacing,
          wordSpacing: theme.chapterWordSpacing,
        ),
        contentStyle = TextStyle(
          color: theme.contentColor.toColor(),
          decoration: TextDecoration.none,
          fontSize: theme.contentFontSize,
          fontWeight: FontWeight.values[theme.contentFontWeight],
          height: theme.contentHeight,
          letterSpacing: theme.contentLetterSpacing,
          wordSpacing: theme.contentWordSpacing,
        );

  /// Builds a [TextSpan] from the given [text], splitting it into paragraphs.
  ///
  /// If [isFirstPage] is true and there are paragraphs, the first paragraph
  /// will be styled as a chapter title.
  TextSpan buildTextSpan(String text, {required bool isFirstPage}) {
    List<String> paragraphs = text.split('\n');
    List<TextSpan> children = [];
    if (isFirstPage && paragraphs.isNotEmpty) {
      var paragraph = '\n${paragraphs.first}\n';
      children.add(TextSpan(text: paragraph, style: chapterStyle));
      paragraphs.removeAt(0);
    }
    var lineBreaker = TextSpan(text: '\n', style: contentStyle);
    var textSpans =
        paragraphs.map((p) => TextSpan(text: p, style: contentStyle)).toList();
    for (var i = 0; i < textSpans.length; i++) {
      children.add(textSpans[i]);
      if (i < textSpans.length - 1) {
        children.add(lineBreaker);
      }
    }
    return TextSpan(children: children);
  }
}
