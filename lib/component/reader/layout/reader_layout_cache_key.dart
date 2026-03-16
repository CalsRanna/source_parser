import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/component/reader/layout/reader_render_config.dart';
import 'package:source_parser/schema/theme.dart';

class ReaderLayoutCacheKey {
  final int chapterIndex;
  final int contentHash;
  final int contentLength;
  final Size contentSize;
  final ReaderRenderConfig renderConfig;
  final int themeSignature;

  const ReaderLayoutCacheKey({
    required this.chapterIndex,
    required this.contentHash,
    required this.contentLength,
    required this.contentSize,
    required this.renderConfig,
    required this.themeSignature,
  });

  factory ReaderLayoutCacheKey.fromContent({
    required int chapterIndex,
    required String content,
    required Size contentSize,
    required ReaderRenderConfig renderConfig,
  }) {
    return ReaderLayoutCacheKey(
      chapterIndex: chapterIndex,
      contentHash: content.hashCode,
      contentLength: content.length,
      contentSize: contentSize,
      renderConfig: renderConfig,
      themeSignature: _themeSignature(renderConfig.theme),
    );
  }

  static int _themeSignature(Theme theme) {
    return Object.hashAll([
      theme.chapterFontSize,
      theme.chapterFontWeight,
      theme.chapterHeight,
      theme.chapterLetterSpacing,
      theme.chapterWordSpacing,
      theme.contentFontSize,
      theme.contentFontWeight,
      theme.contentHeight,
      theme.contentLetterSpacing,
      theme.contentWordSpacing,
      theme.contentPaddingTop,
      theme.contentPaddingRight,
      theme.contentPaddingBottom,
      theme.contentPaddingLeft,
      theme.headerFontSize,
      theme.headerFontWeight,
      theme.headerHeight,
      theme.headerLetterSpacing,
      theme.headerWordSpacing,
      theme.headerPaddingTop,
      theme.headerPaddingRight,
      theme.headerPaddingBottom,
      theme.headerPaddingLeft,
      theme.footerFontSize,
      theme.footerFontWeight,
      theme.footerHeight,
      theme.footerLetterSpacing,
      theme.footerWordSpacing,
      theme.footerPaddingTop,
      theme.footerPaddingRight,
      theme.footerPaddingBottom,
      theme.footerPaddingLeft,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReaderLayoutCacheKey &&
        other.chapterIndex == chapterIndex &&
        other.contentHash == contentHash &&
        other.contentLength == contentLength &&
        other.contentSize == contentSize &&
        other.renderConfig.layout == renderConfig.layout &&
        other.themeSignature == themeSignature;
  }

  @override
  int get hashCode {
    return Object.hash(
      chapterIndex,
      contentHash,
      contentLength,
      contentSize,
      renderConfig.layout,
      themeSignature,
    );
  }
}
