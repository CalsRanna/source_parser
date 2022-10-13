import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key? key, required this.text, this.onTap})
      : super(key: key);

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
