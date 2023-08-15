import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/router/router.dart';

late Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  isar = await Isar.open([
    HistorySchema,
    SettingSchema,
    SourceSchema,
  ], directory: directory.path);
  runApp(CreatorGraph(child: const SourceParser()));
}

class SourceParser extends StatelessWidget {
  const SourceParser({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(useMaterial3: true),
      title: '元夕',
    );
  }
}
