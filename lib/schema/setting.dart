import 'package:isar/isar.dart';

part 'setting.g.dart';

@collection
@Name('settings')
class Setting {
  Id id = Isar.autoIncrement;
  @Name('cache_duration')
  double cacheDuration = 8.0;
  @Name('color_seed')
  String colorSeed = '#FF63BBD0';
  @Name('dark_mode')
  bool darkMode = false;
  @Name('debug_mode')
  bool debugMode = false;
  @Name('e_ink_mode')
  bool eInkMode = false;
  @Name('explore_source')
  int exploreSource = 0;
  @Name('max_concurrent')
  double maxConcurrent = 16.0;
  @Name('search_filter')
  bool searchFilter = false;
  @Name('shelf_mode')
  String shelfMode = 'list';
  @Name('theme_id')
  int themeId = 0;
  @Name('timeout')
  int timeout = 30 * 1000;
  @Name('turning_mode')
  int turningMode = 3;
}
