import 'package:flutter/material.dart';

class SourceImportAlertDialog extends StatelessWidget {
  final String message;
  final void Function(bool)? onConfirm;
  const SourceImportAlertDialog({
    super.key,
    required this.message,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final keepButton = TextButton(
      onPressed: () => onConfirm?.call(false),
      child: const Text('保持原有'),
    );
    final overrideButton = TextButton(
      onPressed: () => onConfirm?.call(true),
      child: const Text('直接覆盖'),
    );
    return AlertDialog(
      actions: [keepButton, overrideButton],
      title: Text(message),
    );
  }
}
