import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/layout.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/logger.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  final directory = await getApplicationDocumentsDirectory();
  isar = await Isar.open([
    BookSchema,
    ReaderLayoutSchema,
    SettingSchema,
    SourceSchema,
  ], directory: directory.path);
  runApp(ProviderScope(child: SourceParser()));
}

class DefaultObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    var name = provider.name ?? provider.runtimeType;
    logger.d('$name changed from $previousValue to $newValue');
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

class SourceParser extends ConsumerStatefulWidget {
  const SourceParser({super.key});

  @override
  ConsumerState<SourceParser> createState() => _SourceParserState();
}

class _SourceParserState extends ConsumerState<SourceParser> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingNotifierProvider).valueOrNull;
    final setting = state ?? Setting();
    final darkMode = setting.darkMode;
    final eInkMode = setting.eInkMode;
    final pageTransitionsTheme = PageTransitionsTheme(
      builders: {TargetPlatform.android: NoAnimationPageTransitionBuilder()},
    );
    var themeData = ThemeData(
      brightness: darkMode ? Brightness.dark : Brightness.light,
      colorSchemeSeed: const Color(0xFF63BBD0),
      pageTransitionsTheme: eInkMode ? pageTransitionsTheme : null,
      splashFactory: eInkMode ? NoSplash.splashFactory : null,
      splashColor: eInkMode ? Colors.transparent : null,
      useMaterial3: true,
    );
    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: themeData,
      title: '元夕',
    );
  }

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.migrate();
  }
}
