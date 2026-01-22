import 'package:flutter/material.dart';
import 'package:source_parser/util/color_extension.dart';

class Theme {
  int? id;

  String backgroundColor = Colors.white.toHex()!;
  String backgroundImage = '';
  double chapterFontSize = 32;
  int chapterFontWeight = 4;
  double chapterHeight = 1 + 0.618;
  double chapterLetterSpacing = 0.618;
  double chapterWordSpacing = 0.618;
  String contentColor = Colors.black.withValues(alpha: 0.75).toHex()!;
  double contentFontSize = 18;
  int contentFontWeight = 3;
  double contentHeight = 1.0 + 0.618 * 2;
  double contentLetterSpacing = 0.618;
  double contentWordSpacing = 0.618;
  double contentPaddingBottom = 0;
  double contentPaddingLeft = 16;
  double contentPaddingRight = 16;
  double contentPaddingTop = 0;
  String footerColor = Colors.black.withValues(alpha: 0.5).toHex()!;
  double footerFontSize = 10;
  int footerFontWeight = 2;
  double footerHeight = 1;
  double footerLetterSpacing = 0.618;
  double footerWordSpacing = 0.618;
  double footerPaddingBottom = 16;
  double footerPaddingLeft = 16;
  double footerPaddingRight = 16;
  double footerPaddingTop = 4;
  String headerColor = Colors.black.withValues(alpha: 0.5).toHex()!;
  double headerFontSize = 10;
  int headerFontWeight = 2;
  double headerHeight = 1;
  double headerLetterSpacing = 0.618;
  double headerWordSpacing = 0.618;
  double headerPaddingBottom = 4;
  double headerPaddingLeft = 16;
  double headerPaddingRight = 16;
  double headerPaddingTop = 16;
  String name = '默认主题';

  Theme();

  Theme.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    backgroundColor = json['background_color'];
    backgroundImage = json['background_image'];
    chapterFontSize = json['chapter_font_size'];
    chapterFontWeight = json['chapter_font_weight'];
    chapterHeight = json['chapter_height'];
    chapterLetterSpacing = json['chapter_letter_spacing'];
    chapterWordSpacing = json['chapter_word_spacing'];
    contentColor = json['content_color'];
    contentFontSize = json['content_font_size'];
    contentFontWeight = json['content_font_weight'];
    contentHeight = json['content_height'];
    contentLetterSpacing = json['content_letter_spacing'];
    contentWordSpacing = json['content_word_spacing'];
    contentPaddingBottom = json['content_padding_bottom'];
    contentPaddingLeft = json['content_padding_left'];
    contentPaddingRight = json['content_padding_right'];
    contentPaddingTop = json['content_padding_top'];
    footerColor = json['footer_color'];
    footerFontSize = json['footer_font_size'];
    footerFontWeight = json['footer_font_weight'];
    footerHeight = json['footer_height'];
    footerLetterSpacing = json['footer_letter_spacing'];
    footerWordSpacing = json['footer_word_spacing'];
    footerPaddingBottom = json['footer_padding_bottom'];
    footerPaddingLeft = json['footer_padding_left'];
    footerPaddingRight = json['footer_padding_right'];
    footerPaddingTop = json['footer_padding_top'];
    headerColor = json['header_color'];
    headerFontSize = json['header_font_size'];
    headerFontWeight = json['header_font_weight'];
    headerHeight = json['header_height'];
    headerLetterSpacing = json['header_letter_spacing'];
    headerWordSpacing = json['header_word_spacing'];
    headerPaddingBottom = json['header_padding_bottom'];
    headerPaddingLeft = json['header_padding_left'];
    headerPaddingRight = json['header_padding_right'];
    headerPaddingTop = json['header_padding_top'];
    name = json['name'];
  }

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
