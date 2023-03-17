import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'setting.g.dart';

@collection
@Name('settings')
class Setting {
  Id id = Isar.autoIncrement;
  @Name('color_seed')
  int colorSeed = Colors.blue.value;
  @Name('dark_mode')
  bool darkMode = false;
}
