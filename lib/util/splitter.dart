import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/component/reader/layout/chapter_layout_result.dart';
import 'package:source_parser/component/reader/layout/chapter_paginator.dart';
import 'package:source_parser/component/reader/layout/reader_render_config.dart';

/// A utility class that splits text content into pages for rendering in a book reader.
///
/// Uses [TextPainter.computeLineMetrics] for efficient single-pass page breaking:
/// 1. Layout the remaining text once with [TextPainter]
/// 2. Accumulate line heights from [computeLineMetrics] until exceeding page height
/// 3. Use [TextPainter.getPositionForOffset] to find the exact character break point
class Splitter {
  /// The size constraints for each page.
  final Size size;

  final ReaderRenderConfig renderConfig;

  /// Creates a new [Splitter] instance.
  ///
  /// [size] defines the available space for each page.
  /// [theme] provides the styling configuration for different text elements.
  Splitter({
    required this.size,
    required this.renderConfig,
  });

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
    return paginate(content).asPageTexts();
  }

  ChapterLayoutResult paginate(String content) {
    try {
      return ChapterPaginator(size: size, renderConfig: renderConfig).paginate(
        content,
      );
    } catch (error) {
      throw SplitterException('Failed to split content: ${error.toString()}');
    }
  }
}

/// Exception thrown when text splitting fails.
class SplitterException implements Exception {
  final String message;
  SplitterException(this.message);

  @override
  String toString() => message;
}
