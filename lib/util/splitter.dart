import 'package:flutter/material.dart';
import 'package:source_parser/model/reader_theme.dart';

/// A utility class that splits text content into pages for rendering in a book reader.
///
/// The [Splitter] uses a binary search algorithm to find optimal page breaks while
/// ensuring that each page:
/// - Fits within the specified size constraints
/// - Starts with actual content (no leading newlines except for the first page)
/// - Is properly filled with newlines when it's the last page
class Splitter {
  /// The size constraints for each page.
  final Size size;

  /// The theme configuration for rendering text.
  final ReaderTheme theme;

  /// Text painter instance used for layout calculations.
  ///
  /// This is reused across layout operations for better performance.
  late final TextPainter _painter;

  /// Creates a new [Splitter] instance.
  ///
  /// [size] defines the available space for each page.
  /// [theme] provides the styling configuration for different text elements.
  Splitter({required this.size, required this.theme})
      : _painter = TextPainter(textDirection: TextDirection.ltr);

  /// Splits the given [content] into pages.
  ///
  /// Returns a list of [String]s, where each string represents a page of content.
  /// Each page is optimally filled while respecting the size constraints.
  ///
  /// The first page will be prefixed with a newline character to indicate it should
  /// display the chapter title. Other pages will never start with a newline.
  ///
  /// Throws a [SplitterException] if splitting fails.
  List<String> split(String content) {
    if (content.isEmpty) return [];
    List<String> pages = [];
    int cursor = 0;
    bool isFirstPage = true;

    try {
      while (cursor < content.length) {
        cursor = _skipLeadingNewlines(content, cursor, isFirstPage);
        if (cursor >= content.length) break;

        final page = _createPage(content, cursor, isFirstPage);
        if (page.end <= cursor) break; // Prevent infinite loop

        final pageContent = content.substring(cursor, page.end);
        pages.add(isFirstPage ? '\n$pageContent' : pageContent);

        cursor = page.end;
        isFirstPage = false;
      }
      return pages;
    } catch (error) {
      throw SplitterException('Failed to split content: ${error.toString()}');
    }
  }

  /// Builds a [TextSpan] from the given text, splitting it into paragraphs.
  ///
  /// If [withTitle] is true and there are paragraphs, the first paragraph will be
  /// styled as a chapter title.
  TextSpan _buildTextSpan(String text, {required bool withTitle}) {
    List<String> paragraphs = text.split('\n');
    List<InlineSpan> children = [];

    if (withTitle && paragraphs.isNotEmpty) {
      // Add spacing before title using newlines
      children.add(TextSpan(text: '\n', style: theme.chapterStyle));
      children.add(TextSpan(text: paragraphs.first, style: theme.chapterStyle));
      paragraphs.removeAt(0);
    }

    children.addAll(
        paragraphs.map((p) => TextSpan(text: '$p\n', style: theme.pageStyle)));

    return TextSpan(children: children);
  }

  /// Creates a single page of content starting from [start].
  ///
  /// Returns a [_Page] containing the page's ending position.
  _Page _createPage(String content, int start, bool isFirstPage) {
    final end = _findEnd(content, start, isFirstPage);
    return _Page(end);
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
      TextSpan span = _buildTextSpan(text, withTitle: isFirstPage);

      if (_layout(span)) {
        lastGoodEnd = mid;
        low = mid + 1;
      } else {
        high = mid;
      }
    }

    return lastGoodEnd;
  }

  /// Checks if the [TextSpan] can be painted properly in the available area.
  bool _layout(TextSpan span) {
    _painter.text = span;
    _painter.layout(maxWidth: size.width);
    return _painter.height <= size.height;
  }

  /// Skips leading newlines for non-first pages.
  ///
  /// Returns the new cursor position after skipping newlines.
  int _skipLeadingNewlines(String content, int cursor, bool isFirstPage) {
    if (isFirstPage) return cursor;

    while (cursor < content.length && content[cursor] == '\n') {
      cursor++;
    }
    return cursor;
  }
}

/// Exception thrown when text splitting fails.
class SplitterException implements Exception {
  final String message;
  SplitterException(this.message);

  @override
  String toString() => message;
}

/// Information about a created page.
class _Page {
  /// The ending position in the original content.
  final int end;

  _Page(this.end);
}
