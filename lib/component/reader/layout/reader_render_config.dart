import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/component/reader/layout/reader_layout_config.dart';
import 'package:source_parser/schema/theme.dart';

class ReaderRenderConfig {
  final Theme theme;
  final ReaderLayoutConfig layout;

  ReaderRenderConfig({
    Theme? theme,
    ReaderLayoutConfig? layout,
  })  : theme = theme ?? Theme(),
        layout = layout ?? const ReaderLayoutConfig();

  Locale? get locale => layout.locale;
  TextDirection get textDirection => layout.textDirection;
  TextHeightBehavior? get textHeightBehavior => layout.textHeightBehavior;
  TextWidthBasis get textWidthBasis => layout.textWidthBasis;
  double get textScaleFactor => layout.textScaleFactor;
  TextScaler get textScaler => layout.textScaler;
}
