import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/router/router.dart';

class DebugButton extends ConsumerWidget {
  const DebugButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => handlePressed(context, ref),
      icon: const Icon(Icons.bug_report_outlined),
    );
  }

  void handlePressed(BuildContext context, WidgetRef ref) {
    const SourceDebuggerPageRoute().push(context);
  }
}
