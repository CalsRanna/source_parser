import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/util/shared_preference_util.dart';
import 'package:source_parser/util/string_extension.dart';

class NoAnimationPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class SourceParserViewModel {
  var isDarkMode = signal(false);
  var isEInkMode = signal(false);
  var colorSeed = signal('#FF63BBD0');
  var screenSize = signal(Size.zero);
  var viewPadding = signal(EdgeInsets.zero);

  Computed<ThemeData> get themeData {
    var actionIconThemeData = ActionIconThemeData(
      backButtonIconBuilder: (_) => Icon(HugeIcons.strokeRoundedArrowLeft01),
    );
    var pageTransitionsTheme = PageTransitionsTheme(
      builders: {TargetPlatform.android: NoAnimationPageTransitionBuilder()},
    );
    var themeData = ThemeData(
      actionIconTheme: actionIconThemeData,
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

  void updateScreenSize(Size size) {
    screenSize.value = size;
  }

  void updateViewPadding(EdgeInsets padding) {
    viewPadding.value = padding;
  }
}
