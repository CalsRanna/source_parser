import 'package:flutter/material.dart';

class RuleGroupLabel extends StatelessWidget {
  final String label;
  const RuleGroupLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface.withOpacity(0.5);
    final style = theme.textTheme.labelMedium?.copyWith(color: onSurface);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(label, style: style),
    );
  }
}
