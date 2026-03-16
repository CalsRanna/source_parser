import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/component/reader/layout/chapter_layout_result.dart';
import 'package:source_parser/component/reader/layout/reader_render_config.dart';
import 'package:source_parser/util/reader_text_style.dart';

class ReaderPageTextBuilder {
  final ReaderTextStyle _styles;

  ReaderPageTextBuilder({required ReaderRenderConfig renderConfig})
      : _styles = ReaderTextStyle(theme: renderConfig.theme);

  TextSpan buildTextSpan(String text, {required bool isFirstPage}) {
    return _styles.buildTextSpan(text, isFirstPage: isFirstPage);
  }

  TextSpan buildPageSpan(ChapterLayoutResult layout, int pageIndex) {
    final range = layout.pageRangeAt(pageIndex);
    return buildRange(layout.fullText, range);
  }

  TextSpan buildRange(String fullText, ReaderPageRange range) {
    return buildTextSpan(
      fullText.substring(range.start, range.end),
      isFirstPage: range.isFirstPage,
    );
  }
}
