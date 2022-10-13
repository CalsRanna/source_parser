import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../database/database.dart';

final cacheDirectoryCreator = Creator.value(
  'cache',
  keepAlive: true,
  name: 'cacheDirectory',
);

final colorCreator = Creator<Color>((ref) {
  int? value = Hive.box('setting').get('theme');
  Color color = Colors.blue;
  if (value != null) {
    color = Color(value);
  }
  return color;
}, keepAlive: true, name: 'color');

final databaseCreator = Creator<AppDatabase?>.value(
  null,
  keepAlive: true,
  name: 'database',
);

final databaseFileCreator = Creator.value(
  'db',
  keepAlive: true,
  name: 'databaseFile',
);
