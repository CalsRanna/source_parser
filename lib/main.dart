import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/router/router.dart';

late Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  isar = await Isar.open([
    BookSchema,
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
      indicator: const Material(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
