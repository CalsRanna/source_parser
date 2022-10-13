import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'database/database.dart';
import 'provider/global.dart';
import 'router/router.dart';
import 'state/global.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('setting');
  runApp(CreatorGraph(child: const ProviderScope(child: SourceParser())));
}

class SourceParser extends ConsumerStatefulWidget {
  const SourceParser({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<SourceParser> {
  @override
  void initState() {
    super.initState();
    _initCache();
    _initDatabase();
  }

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

  void _initCache() async {
    final folder = await getTemporaryDirectory();
    context.ref.set(cacheDirectoryCreator, folder.path);
  }

  void _initDatabase() async {
    final folder = await getApplicationDocumentsDirectory();
    final file = path.join(folder.path, 'db');
    final database = await $FloorAppDatabase.databaseBuilder(file).build();

    ref.read(globalState.notifier).initDatabase(database);
    context.ref.set(databaseCreator, database);
    context.ref.set(databaseFileCreator, file);
  }
}
