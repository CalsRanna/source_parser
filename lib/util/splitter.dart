import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/string_extension.dart';

/// A utility class that splits text content into pages for rendering in a book reader.
///
/// The [Splitter] uses a binary search algorithm to find optimal page breaks while
/// ensuring that each page:
/// - Fits within the specified size constraints
/// - Is properly filled with newlines when it's the last page
class Splitter {
  /// The size constraints for each page.
  final Size size;

  /// The theme configuration for rendering text.
  final Theme theme;

  late final TextStyle _chapterStyle;
  late final TextStyle _contentStyle;

  /// Text painter instance used for layout calculations.
  ///
  /// This is reused across layout operations for better performance.
  late final TextPainter _painter;

  /// Creates a new [Splitter] instance.
  ///
  /// [size] defines the available space for each page.
  /// [theme] provides the styling configuration for different text elements.
  Splitter({required this.size, required this.theme})
      : _chapterStyle = TextStyle(
          color: theme.contentColor.toColor(),
          decoration: TextDecoration.none,
          fontSize: theme.chapterFontSize,
          fontWeight: FontWeight.values[theme.chapterFontWeight],
          height: theme.chapterHeight,
          letterSpacing: theme.chapterLetterSpacing,
          wordSpacing: theme.chapterWordSpacing,
        ),
        _contentStyle = TextStyle(
          color: theme.contentColor.toColor(),
          decoration: TextDecoration.none,
          fontSize: theme.contentFontSize,
          fontWeight: FontWeight.values[theme.contentFontWeight],
          height: theme.contentHeight,
          letterSpacing: theme.contentLetterSpacing,
          wordSpacing: theme.contentWordSpacing,
        ),
        _painter = TextPainter(textDirection: TextDirection.ltr);

  /// Splits the given [content] into pages.
  ///
  /// Returns a list of [String]s, where each string represents a page of content.
  /// Each page is optimally filled while respecting the size constraints.
  ///
  /// The first page will be prefixed with a newline character to indicate it should
  /// display the chapter title.
  ///
  /// Throws a [SplitterException] if splitting fails.
  List<String> split(String content) {
    if (content.isEmpty) return [];
    List<String> pages = [];
    int cursor = 0;
    bool isFirstPage = true;
    try {
      while (cursor < content.length) {
        if (cursor >= content.length) break;
        var end = _findEnd(content, cursor, isFirstPage);
        if (end <= cursor) break; // Prevent infinite loop
        final pageContent = content.substring(cursor, end);
        pages.add(isFirstPage ? '\n$pageContent' : pageContent);
        cursor = end;
        isFirstPage = false;
      }
      return pages;
    } catch (error) {
      throw SplitterException('Failed to split content: ${error.toString()}');
    }
  }

  /// Builds a [TextSpan] from the given text, splitting it into paragraphs.
  ///
  /// If [isFirstPage] is true and there are paragraphs, the first paragraph will be
  /// styled as a chapter title.
  TextSpan _buildTextSpan(String text, {required bool isFirstPage}) {
    List<String> paragraphs = text.split('\n');
    List<TextSpan> children = [];
    if (isFirstPage && paragraphs.isNotEmpty) {
      // Add spacing around title using newlines
      var paragraph = '\n${paragraphs.first}\n';
      children.add(TextSpan(text: paragraph, style: _chapterStyle));
      paragraphs.removeAt(0);
    }
    var lineBreaker = TextSpan(text: '\n', style: _contentStyle);
    var textSpans = paragraphs.map(_toElement).toList();
    for (var i = 0; i < textSpans.length; i++) {
      var textSpan = textSpans[i];
      children.add(textSpan);
      if (i < textSpans.length - 1) {
        children.add(lineBreaker);
      }
    }
    return TextSpan(children: children);
  }

  /// Finds the end index for a page starting from [start].
  ///
  /// Uses binary search to find the maximum amount of text that can fit on a page
  /// while respecting the size constraints.
  int _findEnd(String content, int start, bool isFirstPage) {
    int low = start;
    int high = content.length;
    int lastGoodEnd = start;
    while (low < high) {
      int mid = low + ((high - low) >> 1);
      String text = content.substring(start, mid);
      _painter.text = _buildTextSpan(text, isFirstPage: isFirstPage);
      _painter.layout(maxWidth: size.width);
      if (_painter.height <= size.height) {
        lastGoodEnd = mid;
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return lastGoodEnd;
  }

  TextSpan _toElement(String paragraph) {
    return TextSpan(text: paragraph, style: _contentStyle);
  }
}

/// Exception thrown when text splitting fails.
class SplitterException implements Exception {
  final String message;
  SplitterException(this.message);

  @override
  String toString() => message;
}
