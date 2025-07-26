import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/router/router.gr.dart';

class DebugButton extends StatelessWidget {
  const DebugButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => handlePressed(context),
      icon: const Icon(HugeIcons.strokeRoundedCursorMagicSelection02),
    );
  }

  void handlePressed(BuildContext context) {
    AutoRouter.of(context).push(SourceDebuggerRoute());
  }
}
