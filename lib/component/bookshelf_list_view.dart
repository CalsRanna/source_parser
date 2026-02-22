import 'package:flutter/material.dart';
import 'package:source_parser/widget/book_cover.dart';

class BookshelfListView extends StatelessWidget {
  final int itemCount;
  final String mode;
  final String Function(int index) getName;
  final String Function(int index) getCover;
  final String? Function(int index) getSubtitle;
  final String? Function(int index)? getTrailing;
  final void Function(int index) onTap;
  final void Function(int index)? onLongPress;
  final Widget? emptyWidget;

  const BookshelfListView({
    super.key,
    required this.itemCount,
    this.mode = 'list',
    required this.getName,
    required this.getCover,
    required this.getSubtitle,
    this.getTrailing,
    required this.onTap,
    this.onLongPress,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return emptyWidget ?? const Center(child: Text('空空如也'));
    }
    return switch (mode) {
      'list' => _buildListView(),
      _ => _buildGridView(context),
    };
  }

  Widget _buildListView() {
    return ListView.builder(
      itemBuilder: (context, index) => _BookshelfListTile(
        name: getName(index),
        cover: getCover(index),
        subtitle: getSubtitle(index),
        trailing: getTrailing?.call(index),
        onTap: () => onTap(index),
        onLongPress: onLongPress != null ? () => onLongPress!(index) : null,
      ),
      itemCount: itemCount,
      itemExtent: 72,
    );
  }

  Widget _buildGridView(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final coverWidth = (size.width - 96) / 3;
    final coverHeight = coverWidth * 4 / 3;
    const labelHeight = (8 + 14 * 1.2 * 2 + 12 * 1.2);
    var delegate = SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: coverWidth / (coverHeight + labelHeight),
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 32,
    );
    return GridView.builder(
      itemBuilder: (context, index) {
        final size = MediaQuery.sizeOf(context);
        final coverWidth = (size.width - 96) / 3;
        final coverHeight = coverWidth * 4 / 3;
        return _BookshelfGridTile(
          name: getName(index),
          cover: getCover(index),
          subtitle: getSubtitle(index),
          coverHeight: coverHeight,
          coverWidth: coverWidth,
          onTap: () => onTap(index),
          onLongPress:
              onLongPress != null ? () => onLongPress!(index) : null,
        );
      },
      itemCount: itemCount,
      gridDelegate: delegate,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _BookshelfListTile extends StatelessWidget {
  final String name;
  final String cover;
  final String? subtitle;
  final String? trailing;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const _BookshelfListTile({
    required this.name,
    required this.cover,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    var title = Text(
      name,
      style: bodyMedium?.copyWith(fontWeight: FontWeight.w500),
    );
    var subtitleWidget = Text(
      subtitle ?? '',
      style: bodySmall?.copyWith(color: onSurface.withValues(alpha: 0.5)),
    );
    var trailingWidget = Text(
      trailing ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: bodySmall?.copyWith(color: onSurface.withValues(alpha: 0.5)),
    );
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [title, subtitleWidget, trailingWidget],
    );
    var children = [
      BookCover(url: cover, height: 64, width: 48),
      const SizedBox(width: 16),
      Expanded(child: SizedBox(height: 64, child: column)),
    ];
    var padding = Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(children: children),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      onTap: onTap,
      child: padding,
    );
  }
}

class _BookshelfGridTile extends StatelessWidget {
  final String name;
  final String cover;
  final String? subtitle;
  final double coverHeight;
  final double coverWidth;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const _BookshelfGridTile({
    required this.name,
    required this.cover,
    this.subtitle,
    required this.coverHeight,
    required this.coverWidth,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    const textStyle = TextStyle(fontSize: 14, height: 1.2);
    var title = Text(
      name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
    var subtitleStyle = TextStyle(
      fontSize: 12,
      height: 1.2,
      color: onSurface.withValues(alpha: 0.5),
    );
    var children = [
      BookCover(url: cover, height: coverHeight, width: coverWidth),
      const SizedBox(height: 8),
      title,
      Text(subtitle ?? '', style: subtitleStyle),
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      onTap: onTap,
      child: column,
    );
  }
}
