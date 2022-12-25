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
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: ref.watch(colorCreator),
        ),
        title: '元夕',
      ),
    );
  }
}
