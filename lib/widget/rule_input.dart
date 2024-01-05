import 'package:flutter/material.dart';

class RuleInput extends StatefulWidget {
  const RuleInput({
    super.key,
    this.placeholder,
    this.text,
    required this.title,
    this.onChange,
  });

  final String? placeholder;
  final String? text;
  final String title;
  final void Function(String)? onChange;

  @override
  State<RuleInput> createState() => _RuleInputState();
}

class _RuleInputState extends State<RuleInput> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.placeholder,
            ),
            focusNode: FocusNode()..requestFocus(),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.text ?? '';
    controller.addListener(() {
      widget.onChange?.call(controller.text);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
