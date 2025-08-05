import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

@RoutePage()
class ReaderReplacementFormInputPage extends StatefulWidget {
  final String title;
  final String value;
  const ReaderReplacementFormInputPage({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  State<ReaderReplacementFormInputPage> createState() =>
      _ReaderReplacementFormInputPageState();
}

class _ReaderReplacementFormInputPageState
    extends State<ReaderReplacementFormInputPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(HugeIcons.strokeRoundedTick02),
            onPressed: () => Navigator.of(context).pop(controller.text),
          ),
        ],
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          decoration: InputDecoration.collapsed(hintText: '请输入'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
  }
}
