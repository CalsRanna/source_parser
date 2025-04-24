import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/service.dart';
import 'package:source_parser/injector.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/schema/available_source.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/layout.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  final directory = await getApplicationDocumentsDirectory();
  isar = await Isar.open([
    AvailableSourceSchema,
    BookSchema,
    LayoutSchema,
    SettingSchema,
    SourceSchema,
    ThemeSchema,
  ], directory: directory.path);
  Injector.ensureInitialized();
  await DatabaseService.instance.ensureInitialized();
  runApp(ProviderScope(child: SourceParser()));
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

class SourceParser extends StatefulWidget {
  const SourceParser({super.key});

  @override
  State<SourceParser> createState() => _SourceParserState();
}

class _SourceParserState extends State<SourceParser> {
  final viewModel = GetIt.instance<SourceParserViewModel>();

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) => MaterialApp.router(
        routerConfig: routerConfig,
        theme: viewModel.themeData.value,
        title: '元夕',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }
}
