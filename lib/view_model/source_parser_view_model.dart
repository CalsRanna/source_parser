import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/util/shared_preference_util.dart';
import 'package:source_parser/util/string_extension.dart';

class SourceParserViewModel {
  var isDarkMode = signal(false);
  var isEInkMode = signal(false);
  var colorSeed = signal('#FF63BBD0');

  Computed<ThemeData> get themeData {
    final pageTransitionsTheme = PageTransitionsTheme(
      builders: {TargetPlatform.android: NoAnimationPageTransitionBuilder()},
    );
    var themeData = ThemeData(
      brightness: isDarkMode.value ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colorSeed.value.toColor(),
      pageTransitionsTheme: isEInkMode.value ? pageTransitionsTheme : null,
      splashFactory: isEInkMode.value ? NoSplash.splashFactory : null,
      splashColor: isEInkMode.value ? Colors.transparent : null,
      useMaterial3: true,
    );
    return computed(() => themeData);
  }

  Future<void> initSignals() async {
    isDarkMode.value = await SharedPreferenceUtil.getDarkMode();
    isEInkMode.value = await SharedPreferenceUtil.getEInkMode();
    colorSeed.value = await SharedPreferenceUtil.getColorSeed();
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    SharedPreferenceUtil.setDarkMode(isDarkMode.value);
  }
}
