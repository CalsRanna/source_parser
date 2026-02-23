import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/config/config.dart';
import 'package:source_parser/database/service.dart';
import 'package:source_parser/di.dart';
import 'package:source_parser/page/source_parser/source_parser.dart';
import 'package:source_parser/view_model/app_theme_view_model.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  SignalsObserver.instance = null;
  DI.ensureInitialized();
  await DatabaseService.instance.ensureInitialized();
  await Config.load();
  await GetIt.instance.get<AppThemeViewModel>().initSignals();
  runApp(SourceParser());
}
