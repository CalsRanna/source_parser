import 'package:flutter/material.dart';

class ReaderLayoutConfig {
  final Locale? locale;
  final TextDirection textDirection;
  final TextHeightBehavior? textHeightBehavior;
  final TextWidthBasis textWidthBasis;
  final double textScaleFactor;

  const ReaderLayoutConfig({
    this.locale,
    this.textDirection = TextDirection.ltr,
    this.textHeightBehavior,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textScaleFactor = 1.0,
  });

  TextScaler get textScaler => TextScaler.linear(textScaleFactor);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReaderLayoutConfig &&
        other.locale == locale &&
        other.textDirection == textDirection &&
        other.textHeightBehavior == textHeightBehavior &&
        other.textWidthBasis == textWidthBasis &&
        other.textScaleFactor == textScaleFactor;
  }

  @override
  int get hashCode {
    return Object.hash(
      locale,
      textDirection,
      textHeightBehavior,
      textWidthBasis,
      textScaleFactor,
    );
  }
}
