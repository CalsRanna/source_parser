import 'package:flutter/material.dart';

class RuleInput extends StatelessWidget {
  const RuleInput({
    Key? key,
    this.placeholder,
    this.text,
    required this.title,
  }) : super(key: key);

  final String? placeholder;
  final String? text;
  final String title;

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);
    var controller = TextEditingController()..text = text ?? '';

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => handleTap(navigator, controller),
            icon: const Icon(Icons.check_outlined),
          )
        ],
        leading: BackButton(onPressed: () => handleTap(navigator, controller)),
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: placeholder,
            ),
            focusNode: FocusNode()..requestFocus(),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  void handleTap(NavigatorState navigator, TextEditingController controller) {
    navigator.pop(controller.text);
  }
}
