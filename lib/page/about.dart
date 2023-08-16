import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/util/message.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GestureDetector(
          // onTap: () => handleTap(context),
          child: const Text('凤箫声动，玉壶光转，一夜鱼龙舞。'),
        ),
      ),
    );
  }

  void handleTap(BuildContext context) async {
    final message = Message.of(context);
    final ref = context.ref;
    final setting = await ref.read(settingEmitter);
    setState(() {
      count++;
    });
    if (count == 5 && !setting.debugMode) {
      setting.debugMode = !setting.debugMode;
      ref.emit(settingEmitter, setting.clone);
      message.show('开发者模式已打开');
    }
  }
}
