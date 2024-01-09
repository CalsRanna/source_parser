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
    messenger.hideCurrentSnackBar();
    final textPainter = TextPainter(
      text: TextSpan(text: message),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final width = textPainter.width + 36;
    messenger.showSnackBar(SnackBar(
      backgroundColor: primary,
      behavior: SnackBarBehavior.floating,
      content: Text(message, style: TextStyle(color: onPrimary)),
      duration: const Duration(seconds: 1),
      width: width,
    ));
  }
}
