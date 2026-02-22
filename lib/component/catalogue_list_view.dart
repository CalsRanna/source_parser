import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

enum CatalogueScrollPosition { top, center }

class CatalogueListView extends StatefulWidget {
  final int itemCount;
  final int initialIndex;
  final String Function(int index) getTitle;
  final Future<bool> Function(int index)? isCached;
  final void Function(int index) onTap;
  final Future<void> Function()? onRefresh;
  final bool reversed;
  final CatalogueScrollPosition scrollPosition;
  final GlobalKey<CatalogueListViewState>? globalKey;

  const CatalogueListView({
    super.key,
    required this.itemCount,
    required this.initialIndex,
    required this.getTitle,
    this.isCached,
    required this.onTap,
    this.onRefresh,
    this.reversed = false,
    this.scrollPosition = CatalogueScrollPosition.center,
    this.globalKey,
  });

  @override
  State<CatalogueListView> createState() => CatalogueListViewState();
}

class CatalogueListViewState extends State<CatalogueListView> {
  final controller = ScrollController();
  static const double itemExtent = 56;

  void scrollToPosition(CatalogueScrollPosition position) {
    if (!controller.hasClients) return;
    final maxScrollExtent = controller.position.maxScrollExtent;
    final minScrollExtent = controller.position.minScrollExtent;
    var offset = position == CatalogueScrollPosition.top
        ? minScrollExtent
        : maxScrollExtent;
    controller.animateTo(
      offset,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToInitialIndex());
  }

  void _scrollToInitialIndex() {
    if (widget.itemCount == 0) return;
    if (!controller.hasClients) return;
    final maxScrollExtent = controller.position.maxScrollExtent;
    var offset = widget.initialIndex * itemExtent;
    if (widget.scrollPosition == CatalogueScrollPosition.center) {
      final height = MediaQuery.of(context).size.height;
      final padding = MediaQuery.of(context).padding;
      final listViewHeight = height - padding.vertical - kToolbarHeight;
      final halfHeight = listViewHeight / 2;
      offset = max(0, (offset - halfHeight));
    }
    offset = offset.clamp(0, maxScrollExtent);
    controller.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      controller: controller,
      itemBuilder: (_, index) => _buildItem(index),
      itemCount: widget.itemCount,
      itemExtent: itemExtent,
    );
    final child = widget.onRefresh != null
        ? EasyRefresh(onRefresh: widget.onRefresh, child: listView)
        : listView;
    return Scrollbar(controller: controller, child: child);
  }

  Widget _buildItem(int index) {
    final displayIndex =
        widget.reversed ? widget.itemCount - 1 - index : index;
    final isActive = displayIndex == widget.initialIndex;
    if (widget.isCached != null) {
      return FutureBuilder(
        future: widget.isCached!(displayIndex),
        builder: (_, snapshot) => _CatalogueTile(
          title: widget.getTitle(displayIndex),
          isActive: isActive,
          isCached: snapshot.data ?? false,
          onTap: () => widget.onTap(displayIndex),
        ),
      );
    }
    return _CatalogueTile(
      title: widget.getTitle(displayIndex),
      isActive: isActive,
      isCached: true,
      onTap: () => widget.onTap(displayIndex),
    );
  }
}

class _CatalogueTile extends StatelessWidget {
  final String title;
  final bool isActive;
  final bool isCached;
  final VoidCallback? onTap;

  const _CatalogueTile({
    required this.title,
    this.isActive = false,
    this.isCached = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor(context);
    final weight = _getFontWeight();
    final textStyle = TextStyle(color: color, fontWeight: weight);
    final text = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
    return ListTile(title: text, onTap: onTap);
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (isActive) return colorScheme.primary;
    if (isCached) return colorScheme.onSurface;
    return colorScheme.onSurface.withValues(alpha: 0.5);
  }

  FontWeight _getFontWeight() {
    if (isActive) return FontWeight.bold;
    return FontWeight.normal;
  }
}
