import 'package:flutter/material.dart';

class Message {
  final BuildContext context;

  Message.of(this.context);

  void show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
