import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/state/global.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('setting');
  runApp(CreatorGraph(child: const SourceParser()));
}

class SourceParser extends StatelessWidget {
  const SourceParser({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Watcher(
      (context, ref, _) => MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          colorSchemeSeed: ref.watch(colorCreator),
          brightness:
              ref.watch(darkModeCreator) ? Brightness.dark : Brightness.light,
          useMaterial3: true,
        ),
        title: '元夕',
      ),
    );
  }
}
