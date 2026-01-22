import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/database/service.dart';
import 'package:source_parser/di.dart';
import 'package:source_parser/page/source_parser/source_parser.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  DI.ensureInitialized();
  await DatabaseService.instance.ensureInitialized();
  runApp(ProviderScope(child: SourceParser()));
}
