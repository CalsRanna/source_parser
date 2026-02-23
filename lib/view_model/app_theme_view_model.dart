import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/theme_service.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class AppThemeViewModel {
  final themes = signal<List<Theme>>([]);
  final currentTheme = signal<Theme>(Theme());
  final loading = signal(false);
  final _themeService = ThemeService();

  bool _initialized = false;

  Future<void> initSignals() async {
    if (_initialized) return;
    loading.value = true;
    await _loadThemes();
    await _loadCurrentTheme();
    loading.value = false;
    _initialized = true;
  }

  Future<void> refresh() async {
    _initialized = false;
    await initSignals();
  }

  Future<void> _loadThemes() async {
    final loadedThemes = await _themeService.getThemes();
    if (loadedThemes.isNotEmpty) {
      themes.value = loadedThemes;
    } else {
      final theme = Theme();
      await _themeService.addTheme(theme);
      themes.value = await _themeService.getThemes();
    }
  }

  Future<void> _loadCurrentTheme() async {
    final themeId = await SharedPreferenceUtil.getThemeId();
    final theme =
        themes.value.where((theme) => theme.id == themeId).firstOrNull;
    currentTheme.value = theme ?? Theme();
  }

  Future<void> updateTheme(Theme theme) async {
    await _themeService.updateTheme(theme);
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
    await _themeService.destroyTheme(theme.id ?? 0);
    final updatedThemes = themes.value.where((t) => t.id != theme.id).toList();
    themes.value = updatedThemes;
    if (currentTheme.value.id == theme.id) {
      currentTheme.value = themes.value.first;
      await SharedPreferenceUtil.setThemeId(currentTheme.value.id ?? 0);
    }
  }

  Future<void> selectTheme(Theme theme) async {
    if (currentTheme.value.id == theme.id) return;
    await SharedPreferenceUtil.setThemeId(theme.id ?? 0);
    currentTheme.value = theme;
  }
}
