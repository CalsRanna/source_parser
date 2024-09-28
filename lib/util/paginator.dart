import 'package:flutter/material.dart';
import 'package:source_parser/widget/reader.dart';

/// Paginator is a class used to paginate the content into different pages.
class Paginator {
  final Size size;
  final String text;
  final ReaderTheme theme;
  late TextPainter _painter;

  /// Paginator is a class used to paginate the content into different pages.
  ///
  /// [size] is the available size of the content, and [theme] has some default styles.
  Paginator({required this.size, required this.text, required this.theme}) {
    _painter = TextPainter(
      strutStyle: StrutStyle(
        fontSize: theme.pageStyle.fontSize,
        forceStrutHeight: true,
        height: theme.pageStyle.height,
      ),
    );
  }

  /// Paginate the content into different pages, each page is a [TextSpan].
  List<String> paginate(String content) {
    var offset = 0;
    List<String> pages = [];
    try {
      while (offset < content.length - 1) {
        var end = content.length - 1;
        var from = offset;
        var to = (from + end) ~/ 2;
        var page = content.substring(offset);
        while (end - from > 1) {
          // 如果新的一页以换行符开始，删除这个换行符
          if (page.startsWith('\n')) {
            offset += 1;
          }
          if (_layout(page, offset)) {
            from = to;
          } else {
            end = to;
          }
          to = (from + end) ~/ 2;
        }
        if (to == content.length - 1) {
          // substring不包含end，所以当需要截取后面所有字符串时，end应设为null
          var page = content.substring(offset);
          // 最后一页填充换行符以撑满整个屏幕
          while (_layout('$page\n', offset)) {
            page += '\n';
          }
          pages.add(page);
        } else {
          var page = content.substring(offset, to);
          // 如果最后一次分页溢出，则减少一个字符，因为计算到后面已经在相邻位置进行截取了。
          if (!_layout(page, offset)) {
            to--;
            page = content.substring(offset, to);
          }
          pages.add(page);
        }
        offset = to;
      }
      return pages;
    } catch (error) {
      throw PaginationException(error.toString());
    }
  }

  // TextSpan _paginate(String content, {bool start = false}) {
  //   var end = content.length - 1;
  //   var from = offset;
  //   var to = (from + end) ~/ 2;
  //   var page = content.substring(offset);
  //   final span = _build(text, start: start);
  //   while (end - from > 1) {
  //     // 如果新的一页以换行符开始，删除这个换行符
  //     if (page.startsWith('\n')) {
  //       offset += 1;
  //     }
  //     if (_layout(page, offset)) {
  //       from = to;
  //     } else {
  //       end = to;
  //     }
  //     to = (from + end) ~/ 2;
  //   }
  // }

  /// Whether the text can be paint properly in the available area. If
  /// the return value is [true], means still in the available size,
  /// and [false] means not.
  bool _layout(String text, int offset) {
    try {
      final direction = theme.textDirection;
      final span = _build(text, offset);
      _painter.text = span;
      _painter.textDirection = direction;
      _painter.layout(maxWidth: size.width);
      return _painter.size.height <= size.height;
    } on Exception catch (error) {
      throw PaginationException(error.toString());
    }
  }

  /// Build a [TextSpan] from the given text. Which will split into multi paragraphs.
  TextSpan _build(String text, int offset) {
    try {
      final paragraphs = text.split('\n');
      List<InlineSpan> children = [];
      if (offset == 0) {
        final chapterTitle = paragraphs.first;
        children.add(TextSpan(text: chapterTitle, style: theme.headerStyle));
        // children.add(
        //   const WidgetSpan(child: SizedBox(height: 8, width: double.infinity)),
        // );
        paragraphs.remove(chapterTitle);
      }
      for (var i = 0; i < paragraphs.length; i++) {
        children.add(TextSpan(text: paragraphs[i], style: theme.pageStyle));
        // if (i < paragraphs.length - 1) {
        //   children.add(
        //     const WidgetSpan(
        //         child: SizedBox(height: 8, width: double.infinity)),
        //   );
        // }
      }
      return TextSpan(children: children);
    } catch (error) {
      throw PaginationException(error.toString());
    }
  }
}

/// Pagination exception.
class PaginationException implements Exception {
  PaginationException(this.message);

  final String message;
}
