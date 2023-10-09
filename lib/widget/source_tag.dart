import 'package:flutter/material.dart';

class SourceTag extends StatelessWidget {
  const SourceTag(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) {
      return const SizedBox();
    }
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final onPrimary = colorScheme.onPrimary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: primary.withOpacity(0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(label, style: TextStyle(fontSize: 12, color: onPrimary)),
    );
  }
}
