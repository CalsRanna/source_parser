import 'package:flutter/material.dart';

class BorderedCard extends StatelessWidget {
  const BorderedCard({Key? key, this.title, required this.child})
      : super(key: key);

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var header = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title ?? '',
        style: const TextStyle(color: Colors.grey),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) header,
        Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.grey[200]!),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      ],
    );
  }
}
