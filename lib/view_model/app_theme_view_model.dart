import 'package:isar/isar.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/view_model/app_setting_view_model.dart';

class AppThemeViewModel {
  final settingViewModel = AppSettingViewModel();
  final themes = signal<List<Theme>>([]);
  final currentTheme = signal<Theme>(Theme());
  final loading = signal(false);

  Future<void> initSignals() async {
    loading.value = true;
    await settingViewModel.initSignals();
    await _loadThemes();
    await _loadCurrentTheme();
    loading.value = false;
  }

  Future<void> _loadThemes() async {
    final loadedThemes = await isar.themes.where().findAll();
    if (loadedThemes.isNotEmpty) {
      themes.value = loadedThemes;
    } else {
      final theme = Theme();
      await isar.writeTxn(() async {
        await isar.themes.put(theme);
      });
      themes.value = await isar.themes.where().findAll();
    }
  }

  Future<void> _loadCurrentTheme() async {
    final setting = settingViewModel.setting.value;
    if (setting == null) return;
    final themeId = setting.themeId;
    final theme =
        themes.value.where((theme) => theme.id == themeId).firstOrNull;
    currentTheme.value = theme ?? Theme();
  }

  Future<void> updateTheme(Theme theme) async {
    await isar.writeTxn(() async {
      await isar.themes.put(theme);
    });
    final index = themes.value.indexWhere((t) => t.id == theme.id);
    if (index != -1) {
      final updatedThemes = [...themes.value];
      updatedThemes[index] = theme;
      themes.value = updatedThemes;
    }
    if (currentTheme.value.id == theme.id) {
      currentTheme.value = theme;
    }
  }

  Future<void> deleteTheme(Theme theme) async {
    if (themes.value.length <= 1) {
      throw Exception('不能删除最后一个主题');
    }
    await isar.writeTxn(() async {
      await isar.themes.delete(theme.id!);
    });
    final updatedThemes = themes.value.where((t) => t.id != theme.id).toList();
    themes.value = updatedThemes;
    if (currentTheme.value.id == theme.id) {
      currentTheme.value = themes.value.first;
      final setting = settingViewModel.setting.value;
      if (setting != null) {
        setting.themeId = currentTheme.value.id!;
        await isar.writeTxn(() async {
          await isar.settings.put(setting);
        });
        settingViewModel.setting.value = setting;
      }
    }
  }

  Future<void> selectTheme(Theme theme) async {
    if (currentTheme.value.id == theme.id) return;
    await settingViewModel.selectTheme(theme);
    currentTheme.value = theme;
  }
}
