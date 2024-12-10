import 'package:flutter/material.dart' hide Theme;
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
}

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<Theme> build() async {
    final provider = settingNotifierProvider;
    var setting = await ref.watch(provider.future);
    var themeId = setting.themeId;
    var theme = await isar.themes.where().idEqualTo(themeId).findFirst();
    theme ??= Theme();
    Color backgroundColor = Color(theme.backgroundColor);
    Color contentColor = Color(theme.contentColor);
    Color footerColor = Color(theme.footerColor);
    Color headerColor = Color(theme.headerColor);
    if (setting.darkMode) {
      backgroundColor = Colors.black;
      contentColor = Colors.white.withOpacity(0.75);
      footerColor = Colors.white.withOpacity(0.5);
      headerColor = Colors.white.withOpacity(0.5);
    }
    return theme.copyWith(
      backgroundColor: backgroundColor.value,
      contentColor: contentColor.value,
      footerColor: footerColor.value,
      headerColor: headerColor.value,
    );
  }
}
