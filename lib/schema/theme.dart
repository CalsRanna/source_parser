import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/util/color_extension.dart';

part 'theme.g.dart';

@collection
@Name('themes')
class Theme {
  Id? id;

  @Name('background_color')
  String backgroundColor = Colors.white.toHex()!;

  @Name('background_image')
  String backgroundImage = '';

  @Name('chapter_font_size')
  double chapterFontSize = 32;

  @Name('chapter_font_weight')
  int chapterFontWeight = 4;

  @Name('chapter_height')
  double chapterHeight = 1 + 0.618;

  @Name('chapter_letter_spacing')
  double chapterLetterSpacing = 0.618;

  @Name('chapter_word_spacing')
  double chapterWordSpacing = 0.618;

  @Name('content_color')
  String contentColor = Colors.black.withValues(alpha: 0.75).toHex()!;

  @Name('content_font_size')
  double contentFontSize = 18;

  @Name('content_font_weight')
  int contentFontWeight = 3;

  @Name('content_height')
  double contentHeight = 1.0 + 0.618 * 2;

  @Name('content_letter_spacing')
  double contentLetterSpacing = 0.618;

  @Name('content_word_spacing')
  double contentWordSpacing = 0.618;

  @Name('content_padding_bottom')
  double contentPaddingBottom = 0;

  @Name('content_padding_left')
  double contentPaddingLeft = 16;

  @Name('content_padding_right')
  double contentPaddingRight = 16;

  @Name('content_padding_top')
  double contentPaddingTop = 0;

  @Name('footer_color')
  String footerColor = Colors.black.withValues(alpha: 0.5).toHex()!;

  @Name('footer_font_size')
  double footerFontSize = 10;

  @Name('footer_font_weight')
  int footerFontWeight = 2;

  @Name('footer_height')
  double footerHeight = 1;

  @Name('footer_letter_spacing')
  double footerLetterSpacing = 0.618;

  @Name('footer_word_spacing')
  double footerWordSpacing = 0.618;

  @Name('footer_padding_bottom')
  double footerPaddingBottom = 16;

  @Name('footer_padding_left')
  double footerPaddingLeft = 16;

  @Name('footer_padding_right')
  double footerPaddingRight = 16;

  @Name('footer_padding_top')
  double footerPaddingTop = 4;

  @Name('header_color')
  String headerColor = Colors.black.withValues(alpha: 0.5).toHex()!;

  @Name('header_font_size')
  double headerFontSize = 10;

  @Name('header_font_weight')
  int headerFontWeight = 2;

  @Name('header_height')
  double headerHeight = 1;

  @Name('header_letter_spacing')
  double headerLetterSpacing = 0.618;

  @Name('header_word_spacing')
  double headerWordSpacing = 0.618;

  @Name('header_padding_bottom')
  double headerPaddingBottom = 4;

  @Name('header_padding_left')
  double headerPaddingLeft = 16;

  @Name('header_padding_right')
  double headerPaddingRight = 16;

  @Name('header_padding_top')
  double headerPaddingTop = 16;

  String name = '默认主题';

  Theme();

  Theme copyWith({
    String? backgroundColor,
    String? backgroundImage,
    double? chapterFontSize,
    int? chapterFontWeight,
    double? chapterHeight,
    double? chapterLetterSpacing,
    double? chapterWordSpacing,
    String? contentColor,
    double? contentFontSize,
    int? contentFontWeight,
    double? contentHeight,
    double? contentLetterSpacing,
    double? contentWordSpacing,
    double? contentPaddingBottom,
    double? contentPaddingLeft,
    double? contentPaddingRight,
    double? contentPaddingTop,
    String? footerColor,
    double? footerFontSize,
    int? footerFontWeight,
    double? footerHeight,
    double? footerLetterSpacing,
    double? footerWordSpacing,
    double? footerPaddingBottom,
    double? footerPaddingLeft,
    double? footerPaddingRight,
    double? footerPaddingTop,
    String? headerColor,
    double? headerFontSize,
    int? headerFontWeight,
    double? headerHeight,
    double? headerLetterSpacing,
    double? headerWordSpacing,
    double? headerPaddingBottom,
    double? headerPaddingLeft,
    double? headerPaddingRight,
    double? headerPaddingTop,
    String? name,
  }) {
    return Theme()
      ..id = id
      ..backgroundColor = backgroundColor ?? this.backgroundColor
      ..backgroundImage = backgroundImage ?? this.backgroundImage
      ..chapterFontSize = chapterFontSize ?? this.chapterFontSize
      ..chapterFontWeight = chapterFontWeight ?? this.chapterFontWeight
      ..chapterHeight = chapterHeight ?? this.chapterHeight
      ..chapterLetterSpacing = chapterLetterSpacing ?? this.chapterLetterSpacing
      ..chapterWordSpacing = chapterWordSpacing ?? this.chapterWordSpacing
      ..contentColor = contentColor ?? this.contentColor
      ..contentFontSize = contentFontSize ?? this.contentFontSize
      ..contentFontWeight = contentFontWeight ?? this.contentFontWeight
      ..contentHeight = contentHeight ?? this.contentHeight
      ..contentLetterSpacing = contentLetterSpacing ?? this.contentLetterSpacing
      ..contentWordSpacing = contentWordSpacing ?? this.contentWordSpacing
      ..contentPaddingBottom = contentPaddingBottom ?? this.contentPaddingBottom
      ..contentPaddingLeft = contentPaddingLeft ?? this.contentPaddingLeft
      ..contentPaddingRight = contentPaddingRight ?? this.contentPaddingRight
      ..contentPaddingTop = contentPaddingTop ?? this.contentPaddingTop
      ..footerColor = footerColor ?? this.footerColor
      ..footerFontSize = footerFontSize ?? this.footerFontSize
      ..footerFontWeight = footerFontWeight ?? this.footerFontWeight
      ..footerHeight = footerHeight ?? this.footerHeight
      ..footerLetterSpacing = footerLetterSpacing ?? this.footerLetterSpacing
      ..footerWordSpacing = footerWordSpacing ?? this.footerWordSpacing
      ..footerPaddingBottom = footerPaddingBottom ?? this.footerPaddingBottom
      ..footerPaddingLeft = footerPaddingLeft ?? this.footerPaddingLeft
      ..footerPaddingRight = footerPaddingRight ?? this.footerPaddingRight
      ..footerPaddingTop = footerPaddingTop ?? this.footerPaddingTop
      ..headerColor = headerColor ?? this.headerColor
      ..headerFontSize = headerFontSize ?? this.headerFontSize
      ..headerFontWeight = headerFontWeight ?? this.headerFontWeight
      ..headerHeight = headerHeight ?? this.headerHeight
      ..headerLetterSpacing = headerLetterSpacing ?? this.headerLetterSpacing
      ..headerWordSpacing = headerWordSpacing ?? this.headerWordSpacing
      ..headerPaddingBottom = headerPaddingBottom ?? this.headerPaddingBottom
      ..headerPaddingLeft = headerPaddingLeft ?? this.headerPaddingLeft
      ..headerPaddingRight = headerPaddingRight ?? this.headerPaddingRight
      ..headerPaddingTop = headerPaddingTop ?? this.headerPaddingTop
      ..name = name ?? this.name;
  }

  Map<String, dynamic> toJson() {
    return {
      'background_color': backgroundColor,
      'background_image': backgroundImage,
      'chapter_font_size': chapterFontSize,
      'chapter_font_weight': chapterFontWeight,
      'chapter_height': chapterHeight,
      'chapter_letter_spacing': chapterLetterSpacing,
      'chapter_word_spacing': chapterWordSpacing,
      'content_color': contentColor,
      'content_font_size': contentFontSize,
      'content_font_weight': contentFontWeight,
      'content_height': contentHeight,
      'content_letter_spacing': contentLetterSpacing,
      'content_word_spacing': contentWordSpacing,
      'content_padding_bottom': contentPaddingBottom,
      'content_padding_left': contentPaddingLeft,
      'content_padding_right': contentPaddingRight,
      'content_padding_top': contentPaddingTop,
      'footer_color': footerColor,
      'footer_font_size': footerFontSize,
      'footer_font_weight': footerFontWeight,
      'footer_height': footerHeight,
      'footer_letter_spacing': footerLetterSpacing,
      'footer_word_spacing': footerWordSpacing,
      'footer_padding_bottom': footerPaddingBottom,
      'footer_padding_left': footerPaddingLeft,
      'footer_padding_right': footerPaddingRight,
      'footer_padding_top': footerPaddingTop,
      'header_color': headerColor,
      'header_font_size': headerFontSize,
      'header_font_weight': headerFontWeight,
      'header_height': headerHeight,
      'header_letter_spacing': headerLetterSpacing,
      'header_word_spacing': headerWordSpacing,
      'header_padding_bottom': headerPaddingBottom,
      'header_padding_left': headerPaddingLeft,
      'header_padding_right': headerPaddingRight,
      'header_padding_top': headerPaddingTop,
      'name': name,
    };
  }
}
