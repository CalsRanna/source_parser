import 'package:flutter/material.dart';

class Message {
  final BuildContext context;

  Message.of(this.context);

  void show(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
