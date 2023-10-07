import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'setting.g.dart';

@collection
@Name('settings')
class Setting {
  Id id = Isar.autoIncrement;
  @Name('background_color')
  int backgroundColor = Colors.white.value;
  @Name('cache_duration')
  double cacheDuration = 6.0;
  @Name('color_seed')
  int colorSeed = Colors.blue.value;
  @Name('dark_mode')
  bool darkMode = false;
  @Name('debug_mode')
  bool debugMode = false;
  @Name('e_ink_mode')
  bool eInkMode = false;
  @Name('explore_source')
  int exploreSource = 0;
  @Name('font_size')
  int fontSize = 18;
  @Name('line_space')
  double lineSpace = 1.0 + 0.618 * 2;
  @Name('max_concurrent')
  double maxConcurrent = 16.0;
  @Name('shelf_mode')
  String shelfMode = 'list';
  @Name('turning_mode')
  int turningMode = 3;
}
