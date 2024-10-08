import 'package:flutter/material.dart';

class RuleGroupLabel extends StatelessWidget {
  final String label;

  const RuleGroupLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final style = TextStyle(color: onSurfaceVariant, fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(label, style: style),
    );
  }
}
