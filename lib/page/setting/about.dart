import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/state/global.dart';
import 'package:source_parser/widget/message.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() {
    return _AboutState();
  }
}

class _AboutState extends State<About> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GestureDetector(
          onTap: () => handleTap(context),
          child: const Text('凤箫声动，玉壶光转，一夜鱼龙舞。'),
        ),
      ),
    );
  }

  void handleTap(BuildContext context) {
    setState(() {
      count++;
    });
    if (count == 5 && !context.ref.read(debugModeCreator)) {
      Message.of(context).show('开发者模式已打开');
      context.ref.set(debugModeCreator, true);
    }
  }
}
