import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/database/database.dart';
import 'package:source_parser/model/source.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/user.dart';

final cacheDirectoryEmitter = Emitter<String>((ref, emit) async {
  final folder = await getTemporaryDirectory();
  emit(folder.path);
}, name: 'cacheDirectoryEmitter');

final colorCreator = Creator<Color>((ref) {
  int? value = Hive.box('setting').get('theme');
  Color color = Colors.blue;
  if (value != null) {
    color = Color(value);
  }
  return color;
}, name: 'color');

final currentIndexCreator = Creator.value(
  0,
  keepAlive: true,
  name: 'currentIndexCreator',
);

final databaseEmitter = Emitter<AppDatabase>((ref, emit) async {
  final file = ref.watch(databaseFileEmitter.asyncData).data;
  if (file != null) {
    final database = await $FloorAppDatabase.databaseBuilder(file).build();
    emit(database);
  }
}, keepAlive: true, name: 'databaseEmitter');

final databaseFileEmitter = Emitter<String>((ref, emit) async {
  final folder = await getApplicationDocumentsDirectory();
  emit(path.join(folder.path, 'db'));
}, name: 'databaseFileEmitter');

final isarEmitter = Emitter<Isar>((ref, emit) async {
  final isar = await Isar.open([UserSchema, SettingSchema, SourceSchema]);
  emit(isar);
}, keepAlive: true, name: 'isarEmitter');

final debugModeCreator = Creator.value(
  false,
  keepAlive: true,
  name: 'debugModeCreator',
);

final darkModeCreator = Creator.value(false, name: 'darkModeCreator');
