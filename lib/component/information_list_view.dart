import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/widget/book_cover.dart';

class InformationListView extends StatelessWidget {
  final String name;
  final String author;
  final String cover;
  final String? category;
  final String? status;
  final void Function()? onAuthorTap;
  final void Function()? onCoverLongPress;
  final String introduction;
  final List<Widget> children;
  final Widget bottomBar;

  const InformationListView({
    super.key,
    required this.name,
    required this.author,
    required this.cover,
    this.category,
    this.status,
    this.onAuthorTap,
    this.onCoverLongPress,
    required this.introduction,
    this.children = const [],
    required this.bottomBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [_buildAppBar(context), _buildList()]),
      bottomNavigationBar: bottomBar,
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    var metaView = _InformationHeader(
      name: name,
      author: author,
      cover: cover,
      category: category,
      status: status,
      onAuthorTap: onAuthorTap,
      onCoverLongPress: onCoverLongPress,
    );
    var flexibleSpaceBar = FlexibleSpaceBar(
      background: metaView,
      collapseMode: CollapseMode.pin,
    );
    return SliverAppBar(
      expandedHeight: 200,
      flexibleSpace: flexibleSpaceBar,
      pinned: true,
      stretch: true,
    );
  }

  SliverList _buildList() {
    var items = <Widget>[
      if (introduction.isNotEmpty)
        _InformationDescription(introduction: introduction),
      for (var i = 0; i < children.length; i++) ...[
        const SizedBox(height: 8),
        children[i],
      ],
    ];
    return SliverList(delegate: SliverChildListDelegate(items));
  }
}

class _InformationHeader extends StatelessWidget {
  final String name;
  final String author;
  final String cover;
  final String? category;
  final String? status;
  final void Function()? onAuthorTap;
  final void Function()? onCoverLongPress;

  const _InformationHeader({
    required this.name,
    required this.author,
    required this.cover,
    this.category,
    this.status,
    this.onAuthorTap,
    this.onCoverLongPress,
  });

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
      url: cover,
      width: double.infinity,
    );
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: bookCover,
    );
  }

  Widget _buildColorFilter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    return Container(color: primary.withValues(alpha: 0.25));
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
      children: [Text(author), if (onAuthorTap != null) icon],
    );
    var gestureDetector = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onAuthorTap,
      child: authorRow,
    );
    var columnChildren = [
      Text(name, style: nameTextStyle),
      gestureDetector,
      Text(_buildSpan(), style: spanTextStyle),
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
    var defaultTextStyle = DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.white, height: 1.6),
      child: column,
    );
    var coverWidget = GestureDetector(
      onLongPress: onCoverLongPress,
      child: BookCover(height: 120, url: cover, width: 90),
    );
    var rowChildren = [
      coverWidget,
      const SizedBox(width: 16),
      Expanded(child: defaultTextStyle),
    ];
    return Row(children: rowChildren);
  }

  String _buildSpan() {
    final spans = <String>[];
    if (category != null && category!.isNotEmpty) {
      spans.add(category!);
    }
    if (status != null && status!.isNotEmpty) {
      spans.add(status!);
    }
    return spans.join(' · ');
  }
}

class _InformationDescription extends StatefulWidget {
  final String introduction;

  const _InformationDescription({required this.introduction});

  @override
  State<_InformationDescription> createState() =>
      _InformationDescriptionState();
}

class _InformationDescriptionState extends State<_InformationDescription> {
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
    var description = widget.introduction;
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
      children: [_buildDescription()],
    );
    var expandIcon = _buildExpandIcon();
    var children = [
      column,
      if (!expanded) Positioned(bottom: 8, right: 0, child: expandIcon),
    ];
    return Stack(children: children);
  }
}
