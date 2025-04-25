import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/book_entity.dart';

class InformationDescriptionView extends StatefulWidget {
  final BookEntity book;

  const InformationDescriptionView({super.key, required this.book});

  @override
  State<InformationDescriptionView> createState() =>
      _InformationDescriptionViewState();
}

class _InformationDescriptionViewState
    extends State<InformationDescriptionView> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceTint = colorScheme.surfaceTint;
    var padding = Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildStack(),
    );
    return Card(
      color: surfaceTint.withValues(alpha: 0.05),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: padding,
    );
  }

  void handleTap() {
    setState(() {
      expanded = !expanded;
    });
  }

  Widget _buildDescription() {
    var description = widget.book.introduction;
    description = description
        .replaceAll(' ', '')
        .replaceAll(RegExp(r'\u2003'), '')
        .replaceAll(RegExp(r'\n+'), '\n\u2003\u2003')
        .trim();
    description = '\u2003\u2003$description';
    var text = Text(
      description,
      maxLines: expanded ? null : 4,
      overflow: expanded ? null : TextOverflow.ellipsis,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: handleTap,
      child: SizedBox(width: double.infinity, child: text),
    );
  }

  Widget _buildExpandIcon() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceTint = colorScheme.surfaceTint;
    var shapeDecoration = ShapeDecoration(
      color: surfaceTint.withValues(alpha: 0.1),
      shape: const StadiumBorder(),
    );
    var icon = Icon(
      HugeIcons.strokeRoundedArrowDown01,
      color: surfaceTint,
      size: 12,
    );
    return Container(
      decoration: shapeDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: icon,
    );
  }

  Widget _buildStack() {
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildTags(), _buildDescription()],
    );
    var expandIcon = _buildExpandIcon();
    var children = [
      column,
      if (!expanded) Positioned(bottom: 8, right: 0, child: expandIcon)
    ];
    return Stack(children: children);
  }

  Widget _buildTags() {
    var wrapChildren = [
      if (widget.book.words.isNotEmpty) _Tag(text: widget.book.words),
      if (widget.book.status.isNotEmpty) _Tag(text: widget.book.status),
    ];
    if (wrapChildren.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(children: wrapChildren),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceTint = colorScheme.surfaceTint;
    final textTheme = theme.textTheme;
    final labelMedium = textTheme.labelMedium;
    var shapeDecoration = ShapeDecoration(
      color: surfaceTint.withValues(alpha: 0.1),
      shape: const StadiumBorder(),
    );
    return Container(
      decoration: shapeDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(text, style: labelMedium),
    );
  }
}
