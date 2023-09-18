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
      final eInkMode = ref.watch(eInkModeCreator);
      final pageTransitionsTheme = PageTransitionsTheme(
        builders: {TargetPlatform.android: NoAnimationPageTransitionBuilder()},
      );
      return MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          brightness: darkMode ? Brightness.dark : Brightness.light,
          colorSchemeSeed: const Color(0xFF63BBD0),
          pageTransitionsTheme: eInkMode ? pageTransitionsTheme : null,
          splashFactory: eInkMode ? NoSplash.splashFactory : null,
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
    if (setting.backgroundColor.isNegative) {
      setting.backgroundColor = Colors.white.value;
    }
    if (setting.lineSpace.isNaN) {
      setting.lineSpace = 1.0 + 0.618 * 2;
    }
    if (setting.fontSize.isNegative) {
      setting.fontSize = 18;
    }
    if (setting.shelfMode.isEmpty) {
      setting.shelfMode = 'list';
    }
    if (setting.turningMode.isNegative) {
      setting.turningMode = 3;
    }
    await isar.writeTxn(() async {
      await isar.settings.put(setting!);
    });
    ref.set(backgroundColorCreator, setting.backgroundColor);
    ref.set(darkModeCreator, setting.darkMode);
    ref.set(eInkModeCreator, setting.eInkMode);
    ref.set(fontSizeCreator, setting.fontSize);
    ref.set(lineSpaceCreator, setting.lineSpace);
    ref.set(exploreSourceCreator, setting.exploreSource);
    ref.set(shelfModeCreator, setting.shelfMode);
    ref.set(turningModeCreator, setting.turningMode);
  }
}

class NoAnimationPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
