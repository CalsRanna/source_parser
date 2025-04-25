import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/widget/loading.dart';

class InformationCatalogueView extends StatelessWidget {
  final BookEntity book;
  final List<ChapterEntity> chapters;
  final bool loading;
  final void Function()? onTap;

  const InformationCatalogueView({
    super.key,
    required this.book,
    required this.chapters,
    this.loading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var surfaceTint = colorScheme.surfaceTint;
    var padding = Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildRow(),
    );
    var card = Card(
      color: surfaceTint.withValues(alpha: 0.05),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: padding,
    );
    return GestureDetector(onTap: onTap, child: card);
  }

  Row _buildRow() {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    var indicator = SizedBox(
      height: 24,
      width: 24,
      child: const LoadingIndicator(),
    );
    var text = Text('共${chapters.length}章', textAlign: TextAlign.right);
    var icon = Icon(HugeIcons.strokeRoundedArrowRight01);
    var children = [
      const Text('目录', style: boldTextStyle),
      const Spacer(),
      if (loading && chapters.isEmpty) indicator,
      if (!loading || chapters.isNotEmpty) ...[text, icon]
    ];
    return Row(children: children);
  }
}
