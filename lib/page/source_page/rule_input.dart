import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RuleInputPage extends StatefulWidget {
  final void Function(String)? onChange;
  final String? placeholder;
  final String? text;
  final String title;

  const RuleInputPage({
    super.key,
    this.onChange,
    this.placeholder,
    this.text,
    required this.title,
  });

  @override
  State<RuleInputPage> createState() => _RuleInputPageState();
}

class _RuleInputPageState extends State<RuleInputPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      border: InputBorder.none,
      hintText: widget.placeholder,
    );
    final textField = TextField(
      controller: controller,
      decoration: decoration,
      focusNode: focusNode,
      maxLines: null,
    );
    const edgeInsets = EdgeInsets.symmetric(horizontal: 16);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(padding: edgeInsets, child: textField),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.text ?? '';
    controller.addListener(() {
      widget.onChange?.call(controller.text);
    });
    focusNode.requestFocus();
  }
}
