import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/cache.dart';

class CacheIndicator extends ConsumerWidget {
  const CacheIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
    final primary = colorScheme.primary;
    final progress = ref.watch(cacheProgressNotifierProvider);
    final innerDecoration = ShapeDecoration(
      color: primary,
      shape: const StadiumBorder(),
    );
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
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: shapeDecoration,
      height: 160,
      width: 8,
      child: innerContainer,
    );
  }
}
