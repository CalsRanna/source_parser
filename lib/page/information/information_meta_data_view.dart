import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/widget/book_cover.dart';

class InformationMetaDataView extends StatelessWidget {
  final BookEntity book;

  const InformationMetaDataView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    var metaData = _buildMetaData(context);
    var children = [
      _buildImageFilter(),
      _buildColorFilter(context),
      Positioned(bottom: 16, left: 16, right: 16, child: metaData),
    ];
    return Stack(children: children);
  }

  Widget _buildImageFilter() {
    var bookCover = BookCover(
      height: double.infinity,
      url: book.cover,
      width: double.infinity,
    );
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: bookCover,
    );
  }

  Widget _buildMetaData(BuildContext context) {
    const nameTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
    const icon = Icon(
      HugeIcons.strokeRoundedArrowRight01,
      color: Colors.white,
      size: 14,
    );
    var spanTextStyle = TextStyle(color: Colors.white.withValues(alpha: 0.85));
    var authorRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text(book.author), icon],
    );
    var gestureDetector = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => searchSameAuthor(context),
      child: authorRow,
    );
    var columnChildren = [
      Text(book.name, style: nameTextStyle),
      gestureDetector,
      Text(_buildSpan(book), style: spanTextStyle),
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
    var defaultTextStyle = DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.white, height: 1.6),
      child: column,
    );
    var rowChildren = [
      GestureDetector(
        onLongPress: () => handleLongPress(context),
        child: BookCover(height: 120, url: book.cover, width: 90),
      ),
      const SizedBox(width: 16),
      Expanded(child: defaultTextStyle)
    ];
    return Row(children: rowChildren);
  }

  void handleLongPress(BuildContext context) {
    HapticFeedback.heavyImpact();
    CoverSelectorRoute(book: book).push(context);
  }

  void searchSameAuthor(BuildContext context) {
    SearchRoute(credential: book.author).push(context);
  }

  String _buildSpan(BookEntity book) {
    final spans = <String>[];
    if (book.category.isNotEmpty) {
      spans.add(book.category);
    }
    if (book.status.isNotEmpty) {
      spans.add(book.status);
    }
    return spans.join(' · ');
  }

  Widget _buildColorFilter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    return Container(color: primary.withValues(alpha: 0.25));
  }
}
