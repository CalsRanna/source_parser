import 'package:isar/isar.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/schema/theme.dart';

class AppSettingViewModel {
  final setting = signal<Setting?>(null);
  final loading = signal(false);
  final sources = signal<List<Source>>([]);

  Future<void> initSignals() async {
    loading.value = true;
    var currentSetting = await isar.settings.where().findFirst();
    if (currentSetting == null) {
      currentSetting = Setting();
      await isar.writeTxn(() async {
        await isar.settings.put(currentSetting!);
      });
    }
    await migrate(currentSetting);
    setting.value = currentSetting;
    await loadSources();
    loading.value = false;
  }

  Future<void> loadSources() async {
    final loadedSources = await isar.sources.where().findAll();
    sources.value = loadedSources;
  }

  Future<void> toggleDarkMode() async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    currentSetting.darkMode = !currentSetting.darkMode;
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> updateEInkMode(bool value) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    currentSetting.eInkMode = value;
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> updateTurningMode(int value) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    if (currentSetting.turningMode & value != 0) {
      currentSetting.turningMode -= value;
    } else {
      currentSetting.turningMode += value;
    }
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> updateTimeout(int value) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    currentSetting.timeout = value;
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> updateShelfMode(String mode) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    currentSetting.shelfMode = mode;
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> updateExploreSource(int source) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    currentSetting.exploreSource = source;
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> updateMaxConcurrent(double concurrent) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    currentSetting.maxConcurrent = concurrent;
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> updateCacheDuration(double duration) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    currentSetting.cacheDuration = duration;
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> updateSearchFilter(bool value) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    currentSetting.searchFilter = value;
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> selectTheme(Theme theme) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    if (currentSetting.themeId == theme.id) return;
    currentSetting.themeId = theme.id!;
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
    setting.value = currentSetting;
  }

  Future<void> migrate(Setting currentSetting) async {
    if (currentSetting.cacheDuration.isNaN) {
      currentSetting.cacheDuration = 4.0;
    }
    if (currentSetting.maxConcurrent.isNaN) {
      currentSetting.maxConcurrent = 16.0;
    }
    if (currentSetting.shelfMode.isEmpty) {
      currentSetting.shelfMode = 'list';
    }
    if (currentSetting.timeout.isNegative) {
      currentSetting.timeout = 30 * 1000;
    }
    if (currentSetting.turningMode.isNegative) {
      currentSetting.turningMode = 3;
    }
    await isar.writeTxn(() async {
      await isar.settings.put(currentSetting);
    });
  }
}
