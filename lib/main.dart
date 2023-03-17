import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/model/setting.dart';
import 'package:source_parser/router/router.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('setting');
  runApp(CreatorGraph(child: const SourceParser()));
}

class SourceParser extends StatelessWidget {
  const SourceParser({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return EmitterWatcher<Setting>(
      emitter: settingEmitter,
      builder: (context, setting) => MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          colorSchemeSeed: Color(setting.colorSeed),
          brightness: setting.darkMode ? Brightness.dark : Brightness.light,
          useMaterial3: true,
        ),
        title: '元夕',
      ),
    );
  }
}
