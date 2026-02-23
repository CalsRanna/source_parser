import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/string_extension.dart';

/// A utility class that splits text content into pages for rendering in a book reader.
///
/// The [Splitter] uses a two-phase algorithm to find optimal page breaks:
/// 1. Estimate an upper bound using characters-per-page heuristic
/// 2. Binary search within the narrowed range for the exact break point
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

  /// Estimated maximum characters that can fit on a single page.
  late final int _estimatedCharsPerPage;

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
        _painter = TextPainter(textDirection: TextDirection.ltr) {
    // Estimate chars per page: (width / fontSize) * (height / lineHeight)
    var lineHeight = theme.contentFontSize * theme.contentHeight;
    var charsPerLine = (size.width / theme.contentFontSize).floor();
    var linesPerPage = (size.height / lineHeight).floor();
    _estimatedCharsPerPage = (charsPerLine * linesPerPage * 1.2).ceil();
  }

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

  /// Measures whether [text] fits within the page height.
  bool _fits(String text, bool isFirstPage) {
    _painter.text = _buildTextSpan(text, isFirstPage: isFirstPage);
    _painter.layout(maxWidth: size.width);
    return _painter.height <= size.height;
  }

  /// Finds the end index for a page starting from [start].
  ///
  /// Uses a two-phase approach:
  /// 1. Estimate upper bound using chars-per-page heuristic
  /// 2. Binary search within the narrowed range
  int _findEnd(String content, int start, bool isFirstPage) {
    // If the remaining content fits in one page, return it all
    if (_fits(content.substring(start), isFirstPage)) {
      return content.length;
    }

    // Phase 1: Narrow search range using estimate
    var estimate = start + _estimatedCharsPerPage;
    int low, high;
    if (estimate >= content.length) {
      low = start;
      high = content.length;
    } else if (_fits(content.substring(start, estimate), isFirstPage)) {
      // Estimate fits — double until overflow, then binary search the gap
      low = estimate;
      high = estimate;
      var step = _estimatedCharsPerPage ~/ 2;
      while (high < content.length &&
          _fits(content.substring(start, high), isFirstPage)) {
        low = high;
        high = (high + step).clamp(0, content.length);
      }
    } else {
      // Estimate doesn't fit — real end is between start and estimate
      low = start;
      high = estimate;
    }

    // Phase 2: Binary search in narrowed range
    int lastGoodEnd = low > start ? low : start;
    while (low < high) {
      int mid = low + ((high - low) >> 1);
      if (_fits(content.substring(start, mid), isFirstPage)) {
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
