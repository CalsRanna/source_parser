import 'package:flutter/material.dart';

class Message {
  final BuildContext context;

  Message.of(this.context);

  void show(String message) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(snackBar);
  }
}
