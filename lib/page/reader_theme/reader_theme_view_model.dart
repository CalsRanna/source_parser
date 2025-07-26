import 'package:signals/signals.dart';
import 'package:source_parser/database/theme_service.dart';
import 'package:source_parser/schema/theme.dart';

class ReaderThemeViewModel {
  final themes = signal<List<Theme>>([]);

  Future<void> destroyTheme(Theme theme) async {
    if (themes.value.length == 1) return;
    await ThemeService().destroyTheme(theme.id!);
    themes.value = await ThemeService().getThemes();
  }

  Future<void> initSignal() async {
    themes.value = await ThemeService().getThemes();
  }
}
