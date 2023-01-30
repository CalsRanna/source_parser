import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'setting.g.dart';

@collection
@Name('settings')
class Setting {
  Id id = Isar.autoIncrement;
  @Name('color_value')
  int? colorValue;
  @ignore
  Color? get color => colorValue != null ? Color(colorValue!) : Colors.blue;
}
