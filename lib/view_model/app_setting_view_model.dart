import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/setting_service.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/setting_entity.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/schema/theme.dart';

class AppSettingViewModel {
  final setting = signal<SettingEntity?>(null);
  final loading = signal(false);
  final sources = signal<List<SourceEntity>>([]);
  final _settingService = SettingService();
  final _sourceService = SourceService();

  Future<void> initSignals() async {
    loading.value = true;
    var currentSetting = await _settingService.getSetting();
    if (currentSetting == null) {
      currentSetting = SettingEntity();
      await _settingService.createSetting(currentSetting);
    }
    await migrate(currentSetting);
    setting.value = currentSetting;
    await loadSources();
    loading.value = false;
  }

  Future<void> loadSources() async {
    final loadedSources = await _sourceService.getAllSources();
    sources.value = loadedSources;
  }

  Future<void> toggleDarkMode() async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    final updatedSetting = currentSetting.copyWith(darkMode: !currentSetting.darkMode);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> updateEInkMode(bool value) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    final updatedSetting = currentSetting.copyWith(eInkMode: value);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> updateTurningMode(int value) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    int newMode;
    if (currentSetting.turningMode & value != 0) {
      newMode = currentSetting.turningMode - value;
    } else {
      newMode = currentSetting.turningMode + value;
    }
    final updatedSetting = currentSetting.copyWith(turningMode: newMode);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> updateTimeout(int value) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    final updatedSetting = currentSetting.copyWith(timeout: value);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> updateShelfMode(String mode) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    final updatedSetting = currentSetting.copyWith(shelfMode: mode);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> updateExploreSource(int source) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    final updatedSetting = currentSetting.copyWith(exploreSource: source);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> updateMaxConcurrent(double concurrent) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    final updatedSetting = currentSetting.copyWith(maxConcurrent: concurrent);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> updateCacheDuration(double duration) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    final updatedSetting = currentSetting.copyWith(cacheDuration: duration);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> updateSearchFilter(bool value) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    final updatedSetting = currentSetting.copyWith(searchFilter: value);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> selectTheme(Theme theme) async {
    final currentSetting = setting.value;
    if (currentSetting == null) return;
    if (currentSetting.themeId == (theme.id ?? 0)) return;
    final updatedSetting = currentSetting.copyWith(themeId: theme.id ?? 0);
    await _settingService.updateSetting(updatedSetting);
    setting.value = updatedSetting;
  }

  Future<void> migrate(SettingEntity currentSetting) async {
    var needsUpdate = false;
    var updatedSetting = currentSetting;

    if (currentSetting.cacheDuration.isNaN) {
      updatedSetting = updatedSetting.copyWith(cacheDuration: 4.0);
      needsUpdate = true;
    }
    if (currentSetting.maxConcurrent.isNaN) {
      updatedSetting = updatedSetting.copyWith(maxConcurrent: 16.0);
      needsUpdate = true;
    }
    if (currentSetting.shelfMode.isEmpty) {
      updatedSetting = updatedSetting.copyWith(shelfMode: 'list');
      needsUpdate = true;
    }
    if (currentSetting.timeout.isNegative) {
      updatedSetting = updatedSetting.copyWith(timeout: 30 * 1000);
      needsUpdate = true;
    }
    if (currentSetting.turningMode.isNegative) {
      updatedSetting = updatedSetting.copyWith(turningMode: 3);
      needsUpdate = true;
    }

    if (needsUpdate) {
      await _settingService.updateSetting(updatedSetting);
    }
  }
}
