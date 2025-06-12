import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/router/router.gr.dart';

class DebugButton extends ConsumerWidget {
  const DebugButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => handlePressed(context, ref),
      icon: const Icon(HugeIcons.strokeRoundedCursorMagicSelection02),
    );
  }

  void handlePressed(BuildContext context, WidgetRef ref) {
    AutoRouter.of(context).push(SourceDebuggerRoute());
  }
}
