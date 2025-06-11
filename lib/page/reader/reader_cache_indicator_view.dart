import 'package:flutter/material.dart';

class ReaderCacheIndicatorView extends StatelessWidget {
  final double progress;
  const ReaderCacheIndicatorView({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
    final primary = colorScheme.primary;
    final innerDecoration = BoxDecoration(color: primary);
    final innerContainer = AnimatedContainer(
      decoration: innerDecoration,
      duration: const Duration(milliseconds: 300),
      height: 160 * progress,
      width: 8,
    );
    final outerDecoration = ShapeDecoration(
      color: surfaceContainerHighest,
      shape: const StadiumBorder(),
    );
    var outerContainer = Container(
      alignment: Alignment.bottomCenter,
      decoration: outerDecoration,
      height: 160,
      width: 8,
      child: innerContainer,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: outerContainer,
    );
  }
}
