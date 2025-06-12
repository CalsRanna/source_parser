import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

@RoutePage()
class AvailableSourceFormPage extends StatefulWidget {
  const AvailableSourceFormPage({super.key});

  @override
  State<AvailableSourceFormPage> createState() =>
      _AvailableSourceFormPageState();
}

class _AvailableSourceFormPageState extends State<AvailableSourceFormPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var button = IconButton(
      onPressed: handlePressed,
      icon: const Icon(HugeIcons.strokeRoundedTick02),
    );
    final decoration = InputDecoration(
      border: InputBorder.none,
      hintText: '请输入可解析的地址，通常用于搜索功能不可用的书源',
    );
    final textField = TextField(
      controller: controller,
      decoration: decoration,
      focusNode: focusNode,
      maxLines: null,
    );
    const edgeInsets = EdgeInsets.symmetric(horizontal: 16);
    return Scaffold(
      appBar: AppBar(actions: [button], title: Text('书源地址')),
      body: SingleChildScrollView(padding: edgeInsets, child: textField),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void handlePressed() {
    Navigator.of(context).pop(controller.text);
  }

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }
}
