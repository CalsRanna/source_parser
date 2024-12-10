import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/provider/theme.dart';
import 'package:source_parser/schema/theme.dart';

class ReaderBackground extends ConsumerWidget {
  final Theme? customTheme;
  const ReaderBackground({super.key, this.customTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = _assembleTheme(ref);
    var container = _buildContainer(theme.backgroundColor);
    var image = _buildImage(theme.backgroundImage);
    return Stack(children: [container, image]);
  }

  Theme _assembleTheme(WidgetRef ref) {
    if (customTheme != null) return customTheme!;
    var state = ref.watch(themeNotifierProvider).valueOrNull;
    var currentTheme = state ?? Theme();
    int backgroundColor = currentTheme.backgroundColor;
    int contentColor = currentTheme.contentColor;
    int footerColor = currentTheme.footerColor;
    int headerColor = currentTheme.headerColor;
    var setting = ref.watch(settingNotifierProvider).valueOrNull;
    if (setting?.darkMode == true) {
      backgroundColor = Colors.black.value;
      contentColor = Colors.white.withOpacity(0.75).value;
      footerColor = Colors.white.withOpacity(0.5).value;
      headerColor = Colors.white.withOpacity(0.5).value;
    }
    return currentTheme.copyWith(
      backgroundColor: backgroundColor,
      contentColor: contentColor,
      footerColor: footerColor,
      headerColor: headerColor,
    );
  }

  Widget _buildContainer(int backgroundColorValue) {
    return Container(
      color: Color(backgroundColorValue),
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _buildImage(String backgroundImage) {
    if (backgroundImage.isEmpty) return const SizedBox();
    return Image.asset(
      backgroundImage,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }
}
