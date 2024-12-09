import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/cache.dart';

class ReaderCacheIndicator extends ConsumerWidget {
  const ReaderCacheIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
    final primary = colorScheme.primary;
    final progress = ref.watch(cacheProgressNotifierProvider);
    final innerDecoration = BoxDecoration(color: primary);
    final innerContainer = AnimatedContainer(
      decoration: innerDecoration,
      duration: const Duration(milliseconds: 300),
      height: 160 * progress.progress,
      width: 8,
    );
    final shapeDecoration = ShapeDecoration(
      color: surfaceContainerHighest,
      shape: const StadiumBorder(),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: shapeDecoration,
        height: 160,
        width: 8,
        child: innerContainer,
      ),
    );
  }
}

class ReaderCacheSheet extends StatelessWidget {
  final void Function(int)? onCached;
  const ReaderCacheSheet({super.key, this.onCached});

  @override
  Widget build(BuildContext context) {
    var edgeInsets = MediaQuery.of(context).padding;
    var children = [
      TextButton(onPressed: () => handleTap(context, 50), child: Text('50章')),
      TextButton(onPressed: () => handleTap(context, 100), child: Text('100章')),
      TextButton(onPressed: () => handleTap(context, 200), child: Text('200章')),
      TextButton(onPressed: () => handleTap(context, 0), child: Text('全部章节')),
    ];
    return GridView.count(
      childAspectRatio: 4,
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      padding: EdgeInsets.fromLTRB(16, 0, 16, edgeInsets.bottom + 16),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: children,
    );
  }

  void handleTap(BuildContext context, int count) {
    onCached?.call(count);
    Navigator.of(context).pop();
  }
}
