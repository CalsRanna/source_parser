import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/component/reader/layout/reader_render_config.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/string_extension.dart';

class ReaderViewport {
  final Size pageSize;
  final Size contentSize;
  final double headerHeight;
  final double footerHeight;

  const ReaderViewport({
    required this.pageSize,
    required this.contentSize,
    required this.headerHeight,
    required this.footerHeight,
  });
}

class ReaderViewportCalculator {
  const ReaderViewportCalculator._();

  static ReaderViewport calculate({
    required Size pageSize,
    required ReaderRenderConfig renderConfig,
  }) {
    final theme = renderConfig.theme;
    final headerHeight = _measureHeaderHeight(pageSize.width, renderConfig);
    final footerHeight = _measureFooterHeight(pageSize.width, renderConfig);
    final contentWidth =
        pageSize.width - theme.contentPaddingLeft - theme.contentPaddingRight;
    final contentHeight = pageSize.height -
        headerHeight -
        footerHeight -
        theme.contentPaddingTop -
        theme.contentPaddingBottom;

    return ReaderViewport(
      pageSize: pageSize,
      contentSize: Size(
        contentWidth.clamp(0.0, double.infinity),
        contentHeight.clamp(0.0, double.infinity),
      ),
      headerHeight: headerHeight,
      footerHeight: footerHeight,
    );
  }

  static double _measureFooterHeight(
    double width,
    ReaderRenderConfig renderConfig,
  ) {
    final theme = renderConfig.theme;
    final painter = TextPainter(
      locale: renderConfig.locale,
      text: TextSpan(text: '1/99 99.99%', style: _footerStyle(theme)),
      textDirection: renderConfig.textDirection,
      textHeightBehavior: renderConfig.textHeightBehavior,
      textScaler: renderConfig.textScaler,
      textWidthBasis: renderConfig.textWidthBasis,
      maxLines: 1,
    )..layout(
        maxWidth: width - theme.footerPaddingLeft - theme.footerPaddingRight,
      );
    return painter.height + theme.footerPaddingTop + theme.footerPaddingBottom;
  }

  static double _measureHeaderHeight(
    double width,
    ReaderRenderConfig renderConfig,
  ) {
    final theme = renderConfig.theme;
    final painter = TextPainter(
      locale: renderConfig.locale,
      text: TextSpan(text: '章节标题', style: _headerStyle(theme)),
      textDirection: renderConfig.textDirection,
      textHeightBehavior: renderConfig.textHeightBehavior,
      textScaler: renderConfig.textScaler,
      textWidthBasis: renderConfig.textWidthBasis,
      maxLines: 1,
    )..layout(
        maxWidth: width - theme.headerPaddingLeft - theme.headerPaddingRight,
      );
    return painter.height + theme.headerPaddingTop + theme.headerPaddingBottom;
  }

  static TextStyle _footerStyle(Theme theme) {
    return TextStyle(
      color: theme.footerColor.toColor(),
      decoration: TextDecoration.none,
      fontSize: theme.footerFontSize,
      fontWeight: FontWeight.values[theme.footerFontWeight],
      height: theme.footerHeight,
      letterSpacing: theme.footerLetterSpacing,
      wordSpacing: theme.footerWordSpacing,
    );
  }

  static TextStyle _headerStyle(Theme theme) {
    return TextStyle(
      color: theme.headerColor.toColor(),
      decoration: TextDecoration.none,
      fontSize: theme.headerFontSize,
      fontWeight: FontWeight.values[theme.headerFontWeight],
      height: theme.headerHeight,
      letterSpacing: theme.headerLetterSpacing,
      wordSpacing: theme.headerWordSpacing,
    );
  }
}
