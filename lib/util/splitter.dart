import 'package:flutter/material.dart';
import 'package:source_parser/page/reader/component/page.dart';

/// A utility class for splitting content into pages for a reader application.
///
/// This class takes into account the available size and theme settings to
/// determine how to split the content optimally for display.
class Splitter {
  /// The available size for content display.
  final Size size;

  /// The theme containing style information for the reader.
  final ReaderTheme theme;

  /// The text painter used for finding the optimal layout.
  late TextPainter _painter;

  /// Creates a new [Splitter] instance.
  ///
  /// [size] defines the available area for content display.
  /// [theme] provides style information for rendering the content.
  Splitter({required this.size, required this.theme}) {
    final strutStyle = StrutStyle(
      fontSize: theme.pageStyle.fontSize,
      forceStrutHeight: true,
      height: theme.pageStyle.height,
    );
    _painter = TextPainter(
      strutStyle: strutStyle,
      textDirection: theme.textDirection,
    );
  }

  /// Splits the given [content] into pages.
  ///
  /// Returns a list of [TextSpan]s, where each [TextSpan] represents a page of content.
  /// Throws a [SplitterException] if splitting fails.
  List<TextSpan> split(String content) {
    if (content.isEmpty) return [];
    List<TextSpan> pages = [];
    int cursor = 0;
    bool isFirstPage = true;
    try {
      while (cursor < content.length) {
        final span = _createPageSpan(content, cursor, isFirstPage);
        pages.add(span);
        cursor += span.toPlainText().length;
        isFirstPage = false;
      }
      return pages;
    } catch (error) {
      throw SplitterException('Failed to split content: ${error.toString()}');
    }
  }

  /// Builds a [TextSpan] from the given text, splitting it into paragraphs.
  TextSpan _buildTextSpan(String text, {required bool withTitle}) {
    List<String> paragraphs = text.split('\n');
    List<InlineSpan> children = [];
    if (withTitle && paragraphs.isNotEmpty) {
      final span = TextSpan(text: paragraphs.first, style: theme.headerStyle);
      children.add(span);
      paragraphs.removeAt(0);
    }
    final spans = paragraphs.map(
      (p) => TextSpan(text: '$p\n', style: theme.pageStyle),
    );
    children.addAll(spans);
    return TextSpan(children: children);
  }

  /// Creates a [TextSpan] for a single page starting from [start].
  TextSpan _createPageSpan(String content, int start, bool isFirstPage) {
    int end = _findEnd(content, start, isFirstPage);
    String text = content.substring(start, end);
    TextSpan result = _buildTextSpan(text, withTitle: isFirstPage);
    if (end == content.length) result = _fillLastPageSpan(result, isFirstPage);
    return result;
  }

  /// Fills the last page [TextSpan] with newlines to make it full.
  TextSpan _fillLastPageSpan(TextSpan span, bool isFirstPage) {
    List<InlineSpan> children = List<InlineSpan>.from(span.children ?? [span]);
    while (_layout(TextSpan(children: children))) {
      children.add(TextSpan(text: '\n', style: theme.pageStyle));
    }
    children.removeLast();
    return TextSpan(children: children);
  }

  /// Finds the end index for a page starting from [start].
  ///
  /// Uses binary search to find the maximum amount of text that can fit on a page.
  int _findEnd(String content, int start, bool isFirstPage) {
    int low = start;
    int high = content.length;
    while (low < high) {
      int mid = low + ((high - low) >> 1);
      String text = content.substring(start, mid);
      if (text.startsWith('\n')) {
        start++;
        text = text.substring(1);
      }
      TextSpan span = _buildTextSpan(text, withTitle: isFirstPage);
      if (_layout(span)) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low - 1;
  }

  /// Checks if the [TextSpan] can be painted properly in the available area.
  bool _layout(TextSpan span) {
    _painter.text = span;
    _painter.layout(maxWidth: size.width);
    return _painter.size.height <= size.height;
  }
}

/// Exception thrown when the [Splitter] encounters an error.
class SplitterException implements Exception {
  /// The error message describing the exception.
  final String message;

  /// Creates a new [SplitterException] with the given [message].
  SplitterException(this.message);

  @override
  String toString() => 'SplitterException: $message';
}
