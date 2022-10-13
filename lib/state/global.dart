import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../database/database.dart';

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
