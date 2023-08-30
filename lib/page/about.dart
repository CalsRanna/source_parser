import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final titleLarge = textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GestureDetector(
          // onTap: () => handleTap(context),
          child: Text('凤箫声动，玉壶光转，一夜鱼龙舞。', style: titleLarge),
        ),
      ),
    );
  }

  // void handleTap(BuildContext context) async {
  //   final message = Message.of(context);
  //   final ref = context.ref;
  //   final setting = await ref.read(settingEmitter);
  //   setState(() {
  //     count++;
  //   });
  //   if (count == 5 && !setting.debugMode) {
  //     setting.debugMode = !setting.debugMode;
  //     ref.emit(settingEmitter, setting.clone);
  //     message.show('开发者模式已打开');
  //   }
  // }
}
