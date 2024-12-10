import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/theme.dart';

part 'theme.g.dart';

@riverpod
class ThemesNotifier extends _$ThemesNotifier {
  @override
  Future<List<Theme>> build() async {
    var themes = await isar.themes.where().findAll();
    if (themes.isNotEmpty) return themes;
    var theme = Theme();
    await isar.writeTxn(() async {
      await isar.themes.put(theme);
    });
    return isar.themes.where().findAll();
  }

  Future<void> delete(Theme theme) async {
    var themes = await future;
    if (themes.length <= 1) throw Exception('不能删除最后一个主题');
    await isar.writeTxn(() async {
      await isar.themes.delete(theme.id!);
    });
    ref.invalidateSelf();
  }
}

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<Theme> build() async {
    final provider = settingNotifierProvider;
    var setting = await ref.watch(provider.future);
    var themeId = setting.themeId;
    var themes = await ref.watch(themesNotifierProvider.future);
    var theme = themes.where((theme) => theme.id == themeId).firstOrNull;
    return theme ?? Theme();
  }

  Future<void> updateTheme(Theme theme) async {
    await isar.writeTxn(() async {
      await isar.themes.put(theme);
    });
    ref.invalidateSelf();
  }
}
