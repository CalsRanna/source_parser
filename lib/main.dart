import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  isar = await Isar.open([
    BookSchema,
    SettingSchema,
    SourceSchema,
  ], directory: directory.path);
  runApp(CreatorGraph(
    observer: const CreatorObserver(),
    child: const SourceParser(),
  ));
}

class SourceParser extends StatefulWidget {
  const SourceParser({Key? key}) : super(key: key);

  @override
  State<SourceParser> createState() => _SourceParserState();
}

class _SourceParserState extends State<SourceParser> {
  @override
  void didChangeDependencies() {
    getSetting();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      final darkMode = ref.watch(darkModeCreator);

      return MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          brightness: darkMode ? Brightness.dark : Brightness.light,
          useMaterial3: true,
        ),
        title: '元夕',
      );
    });
  }

  Future<void> getSetting() async {
    final ref = context.ref;
    var setting = await isar.settings.where().findFirst();
    setting ??= Setting();
    if (setting.lineSpace.isNaN) {
      setting.lineSpace = 1.0 + 0.618 * 2;
    }
    await isar.writeTxn(() async {
      await isar.settings.put(setting!);
    });
    ref.set(darkModeCreator, setting.darkMode);
    ref.set(lineSpaceCreator, setting.lineSpace);
    ref.set(exploreSourceCreator, setting.exploreSource);
  }
}
