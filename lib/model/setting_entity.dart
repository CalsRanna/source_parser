class SettingEntity {
  int id = 1;
  double cacheDuration = 8.0;
  String colorSeed = '#FF63BBD0';
  bool darkMode = false;
  bool debugMode = false;
  bool eInkMode = false;
  int exploreSource = 0;
  double maxConcurrent = 16.0;
  bool searchFilter = false;
  String shelfMode = 'list';
  int themeId = 0;
  int timeout = 30 * 1000;
  int turningMode = 3;

  SettingEntity();

  factory SettingEntity.fromJson(Map<String, dynamic> json) {
    return SettingEntity()
      ..id = json['id'] as int? ?? 1
      ..cacheDuration = (json['cache_duration'] as num?)?.toDouble() ?? 8.0
      ..colorSeed = json['color_seed'] ?? '#FF63BBD0'
      ..darkMode = json['dark_mode'] == 1
      ..debugMode = json['debug_mode'] == 1
      ..eInkMode = json['e_ink_mode'] == 1
      ..exploreSource = json['explore_source'] as int? ?? 0
      ..maxConcurrent = (json['max_concurrent'] as num?)?.toDouble() ?? 16.0
      ..searchFilter = json['search_filter'] == 1
      ..shelfMode = json['shelf_mode'] ?? 'list'
      ..themeId = json['theme_id'] as int? ?? 0
      ..timeout = json['timeout'] as int? ?? 30 * 1000
      ..turningMode = json['turning_mode'] as int? ?? 3;
  }

  SettingEntity copyWith({
    int? id,
    double? cacheDuration,
    String? colorSeed,
    bool? darkMode,
    bool? debugMode,
    bool? eInkMode,
    int? exploreSource,
    double? maxConcurrent,
    bool? searchFilter,
    String? shelfMode,
    int? themeId,
    int? timeout,
    int? turningMode,
  }) {
    return SettingEntity()
      ..id = id ?? this.id
      ..cacheDuration = cacheDuration ?? this.cacheDuration
      ..colorSeed = colorSeed ?? this.colorSeed
      ..darkMode = darkMode ?? this.darkMode
      ..debugMode = debugMode ?? this.debugMode
      ..eInkMode = eInkMode ?? this.eInkMode
      ..exploreSource = exploreSource ?? this.exploreSource
      ..maxConcurrent = maxConcurrent ?? this.maxConcurrent
      ..searchFilter = searchFilter ?? this.searchFilter
      ..shelfMode = shelfMode ?? this.shelfMode
      ..themeId = themeId ?? this.themeId
      ..timeout = timeout ?? this.timeout
      ..turningMode = turningMode ?? this.turningMode;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cache_duration': cacheDuration,
      'color_seed': colorSeed,
      'dark_mode': darkMode ? 1 : 0,
      'debug_mode': debugMode ? 1 : 0,
      'e_ink_mode': eInkMode ? 1 : 0,
      'explore_source': exploreSource,
      'max_concurrent': maxConcurrent,
      'search_filter': searchFilter ? 1 : 0,
      'shelf_mode': shelfMode,
      'theme_id': themeId,
      'timeout': timeout,
      'turning_mode': turningMode,
    };
  }
}
