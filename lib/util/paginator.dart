import 'package:flutter/material.dart';
import 'package:source_parser/util/theme.dart';

/// Paginator is a class used to paginate the content into different pages.
class Paginator {
  final Size size;
  final ReaderTheme theme;
  late TextPainter _painter;
  Size _size = Size.zero;

  /// Paginator is a class used to paginate the content into different pages.
  ///
  /// [size] is the available size of the content, and [theme] has some default styles.
  Paginator({required this.size, required this.theme}) {
    _painter = TextPainter();
    final width = size.width - theme.pagePadding.horizontal;
    final height = size.height -
        theme.headerPadding.vertical -
        theme.headerStyle.fontSize! * theme.headerStyle.height! -
        theme.pagePadding.vertical -
        theme.footerStyle.fontSize! * theme.footerStyle.height! -
        theme.footerPadding.vertical;
    _size = Size(width, height);
  }

  /// Paginate the content into different pages, each page is a [TextSpan].
  List<Widget> paginate(String content, {required String title}) {
    var remaining = content;
    List<Widget> pages = [];
    try {
      while (remaining.isNotEmpty) {
        String? chapter = pages.isEmpty ? title : null;
        final offset = _binarySearch(remaining, title: chapter);
        final fragment = remaining.substring(0, offset);
        pages.add(_build(fragment, title: chapter));
        remaining = remaining.substring(offset);
      }
      return pages;
    } catch (error) {
      throw PaginatorException(error.toString());
    }
  }

  // 给出一段文本，使用二分查找获得合适的长度
  // 二分查找的时间复杂度为 O(log n), 二分查找的空间复杂度为 O(1)
  int _binarySearch(String content, {String? title}) {
    int low = 0;
    int high = content.length;
    while (low < high) {
      int mid = low + ((high - low) >> 1); // 使用位运算来计算中间值
      String fragment = content.substring(0, mid + 1);
      final overflow = !_layout(fragment, title: title);
      if (!overflow) {
        // 如果没有溢出
        low = mid + 1; // 将低边界上移
      } else {
        high = mid; // 将高边界下移
      }
    }
    return low; // low将是刚好不会溢出的最大偏移量
  }

  /// Whether the text can be paint properly in the available area. If
  /// the return value is [true], means still in the available size,
  /// and [false] means not.
  bool _layout(String content, {String? title}) {
    var paragraphs = content.split('\n');
    var length = paragraphs.length;
    final width = _size.width;
    var height = _size.height;
    for (var i = 0; i < length; i++) {
      final paragraph = paragraphs[i];
      _painter.text = TextSpan(text: paragraph, style: theme.pageStyle);
      _painter.textDirection = theme.textDirection;
      _painter.layout(maxWidth: width);
      height -= _painter.size.height;
      if (i < length - 1) {
        height -= 8;
      }
    }
    if (title != null) {
      _painter.text = TextSpan(text: title, style: theme.chapterStyle);
      _painter.textDirection = theme.textDirection;
      _painter.layout(maxWidth: width);
      height -= _painter.size.height;
      height -= 8;
    }
    return height > 0;
    // List<InlineSpan> children = [];
    // for (var paragraph in paragraphs) {
    //   children.add(TextSpan(text: '$paragraph\n', style: theme.pageStyle));
    // }
    // if (title != null) {
    //   length += 1;
    //   children.insert(0, TextSpan(text: '$title\n', style: theme.chapterStyle));
    // }
    // _painter.text = TextSpan(children: children);
    // _painter.textDirection = theme.textDirection;
    // final width = size.width - theme.pagePadding.horizontal;
    // final height = size.height -
    //     theme.headerPadding.vertical -
    //     theme.pagePadding.vertical -
    //     theme.footerPadding.vertical -
    //     (length - 1) * 8;
    // print('paragraphs: $paragraphs');
    // _painter.layout(maxWidth: width);
    // print('view size: Size($width, $height), painter size: ${_painter.size}');
    // return _painter.size.height <= height;
  }
  // bool _layout(TextSpan text) {
  //   _painter.text = text;
  //   _painter.textDirection = theme.textDirection;
  //   List<PlaceholderDimensions> dimensions = [];
  //   var height = theme.pageStyle.fontSize! * theme.pageStyle.height!;
  //   var width = size.width - theme.pagePadding.horizontal;
  //   print(height);
  //   text.visitChildren((span) {
  //     if (span is WidgetSpan) {
  //       dimensions.add(PlaceholderDimensions(
  //         alignment: PlaceholderAlignment.middle,
  //         size: Size(width, 8),
  //       ));
  //     }
  //     return true;
  //   });
  //   _painter.setPlaceholderDimensions(dimensions);
  //   _painter.layout(maxWidth: width);
  //   height = size.height -
  //       theme.headerPadding.vertical -
  //       theme.pagePadding.vertical -
  //       theme.footerPadding.vertical;
  //   print('view size: Size($width, $height), painter size: ${_painter.size}');
  //   return _painter.size.height <= height;
  // }

  /// Build a [TextSpan] from the given text. Which will split into multi paragraphs.
  Widget _build(String content, {String? title}) {
    final paragraphs = content.split('\n').toList();
    List<Widget> children = [];
    const placeholder = SizedBox(height: 8, width: double.infinity);
    for (var i = 0; i < paragraphs.length; i++) {
      children.add(Text(paragraphs[i], style: theme.pageStyle));
      if (i < paragraphs.length - 1) {
        children.add(placeholder);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: theme.chapterPadding,
            child: Text(title, style: theme.chapterStyle),
          ),
        ...children,
      ],
    );
  }
  // TextSpan _build(String content, {String? title}) {
  //   final paragraphs = content.split('\n').toList();
  //   List<InlineSpan> children = [];
  //   var height = theme.pageStyle.fontSize! * theme.pageStyle.height!;
  //   Widget blank =
  //       Container(color: Colors.red, height: 8, width: double.infinity);
  //   var span = WidgetSpan(alignment: PlaceholderAlignment.middle, child: blank);
  //   for (var i = 0; i < paragraphs.length; i++) {
  //     children.add(
  //       TextSpan(
  //         text: paragraphs[i],
  //         style: theme.pageStyle,
  //       ),
  //     );
  //     if (i < paragraphs.length - 1) {
  //       children.add(span);
  //     }
  //   }
  //   if (title == null) return TextSpan(children: children);
  //   children.insertAll(0, [
  //     span,
  //     span,
  //     TextSpan(
  //       text: title,
  //       style: theme.chapterStyle.copyWith(backgroundColor: Colors.amber),
  //     ),
  //     span,
  //     span,
  //   ]);
  //   return TextSpan(children: children);
  // }
}

/// Paginator exception.
class PaginatorException implements Exception {
  PaginatorException(this.message);

  final String message;
}
