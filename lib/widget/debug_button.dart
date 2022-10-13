import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DebugButton extends StatelessWidget {
  const DebugButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.push('/book-source/debug');
      },
      icon: const Icon(Icons.bug_report_outlined),
    );
  }
}
