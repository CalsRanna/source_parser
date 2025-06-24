import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/database/service.dart';
import 'package:source_parser/di.dart';
import 'package:source_parser/page/source_parser/source_parser.dart';
import 'package:source_parser/schema/available_source.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/layout.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/schema/theme.dart';

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
  DI.ensureInitialized();
  await DatabaseService.instance.ensureInitialized();
  runApp(ProviderScope(child: SourceParser()));
}
