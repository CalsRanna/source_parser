import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/reader_text_style.dart';

/// A utility class that splits text content into pages for rendering in a book reader.
///
/// Uses [TextPainter.computeLineMetrics] for efficient single-pass page breaking:
/// 1. Layout the remaining text once with [TextPainter]
/// 2. Accumulate line heights from [computeLineMetrics] until exceeding page height
/// 3. Use [TextPainter.getPositionForOffset] to find the exact character break point
class Splitter {
  /// The size constraints for each page.
  final Size size;

  /// The theme configuration for rendering text.
  final Theme theme;

  late final ReaderTextStyle _styles;

  /// Text painter instance used for layout calculations.
  ///
  /// This is reused across layout operations for better performance.
  late final TextPainter _painter;

  /// Creates a new [Splitter] instance.
  ///
  /// [size] defines the available space for each page.
  /// [theme] provides the styling configuration for different text elements.
  Splitter({required this.size, required this.theme})
      : _styles = ReaderTextStyle(theme: theme),
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

  /// Finds the end index for a page starting from [start].
  ///
  /// Performs a single [TextPainter.layout] call and uses [computeLineMetrics]
  /// to determine how many lines fit within the page height.
  int _findEnd(String content, int start, bool isFirstPage) {
    String text = content.substring(start);
    _painter.text = _styles.buildTextSpan(text, isFirstPage: isFirstPage);
    _painter.layout(maxWidth: size.width);

    // If the remaining content fits in one page, return it all
    if (_painter.height <= size.height) {
      return content.length;
    }

    // Accumulate line heights to find how many lines fit
    var lines = _painter.computeLineMetrics();
    double accumulatedHeight = 0;
    int lastFittingLine = -1;

    for (var i = 0; i < lines.length; i++) {
      if (accumulatedHeight + lines[i].height > size.height) break;
      accumulatedHeight += lines[i].height;
      lastFittingLine = i;
    }

    if (lastFittingLine < 0) return start;
    if (lastFittingLine >= lines.length - 1) return content.length;

    // Get the character offset at the start of the first line that doesn't fit
    var position = _painter.getPositionForOffset(
      Offset(0, accumulatedHeight + 0.1),
    );

    var charOffset = position.offset;
    // Adjust for the extra leading newline added by buildTextSpan on first page
    if (isFirstPage) charOffset -= 1;
    if (charOffset <= 0) return start;

    return start + charOffset;
  }
}

/// Exception thrown when text splitting fails.
class SplitterException implements Exception {
  final String message;
  SplitterException(this.message);

  @override
  String toString() => message;
}
