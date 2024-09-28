import 'package:flutter/material.dart';

class Message {
  final BuildContext context;

  Message.of(this.context);

  void show(String message) {
    if (!context.mounted) return;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final onPrimary = colorScheme.onPrimary;
    final messenger = ScaffoldMessenger.of(context);
    final snackBar = SnackBar(
      backgroundColor: primary,
      behavior: SnackBarBehavior.floating,
      content: Text(message, style: TextStyle(color: onPrimary)),
      duration: const Duration(seconds: 1),
    );
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(snackBar);
  }
}
