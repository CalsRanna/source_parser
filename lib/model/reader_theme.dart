import 'package:flutter/material.dart';

class ReaderTheme {
  Color backgroundColor = Colors.white;
  String backgroundImage = '';
  TextStyle chapterStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.0 + 0.618,
    letterSpacing: 0.618,
    wordSpacing: 0.618,
  );
  EdgeInsets footerPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );
  TextStyle footerStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 10,
    fontWeight: FontWeight.w300,
    height: 1,
    letterSpacing: 0.618,
    wordSpacing: 0.618,
  );
  EdgeInsets headerPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );
  TextStyle headerStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 10,
    fontWeight: FontWeight.w300,
    height: 1,
    letterSpacing: 0.618,
    wordSpacing: 0.618,
  );
  EdgeInsets pagePadding = const EdgeInsets.symmetric(
    horizontal: 16,
  );
  TextStyle pageStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.0 + 0.618 * 2,
    letterSpacing: 0.618,
    wordSpacing: 0.618,
  );
  TextDirection textDirection = TextDirection.ltr;

  ReaderTheme copyWith({
    Color? backgroundColor,
    String? backgroundImage,
    TextStyle? chapterStyle,
    EdgeInsets? footerPadding,
    TextStyle? footerStyle,
    EdgeInsets? headerPadding,
    TextStyle? headerStyle,
    EdgeInsets? pagePadding,
    TextStyle? pageStyle,
    TextDirection? textDirection,
  }) {
    return ReaderTheme()
      ..backgroundColor = backgroundColor ?? this.backgroundColor
      ..backgroundImage = backgroundImage ?? this.backgroundImage
      ..chapterStyle = chapterStyle ?? this.chapterStyle
      ..footerPadding = footerPadding ?? this.footerPadding
      ..footerStyle = footerStyle ?? this.footerStyle
      ..headerPadding = headerPadding ?? this.headerPadding
      ..headerStyle = headerStyle ?? this.headerStyle
      ..pagePadding = pagePadding ?? this.pagePadding
      ..pageStyle = pageStyle ?? this.pageStyle
      ..textDirection = textDirection ?? this.textDirection;
  }
}
