import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/reader_theme.dart';
import 'package:source_parser/provider/reader.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/setting.dart';

class ReaderBackground extends ConsumerWidget {
  const ReaderBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var setting = _getSetting(ref);
    var theme = _getTheme(ref);
    var backgroundColor =
        setting.darkMode ? Colors.black : theme.backgroundColor;
    var body = _buildBody(theme);
    return Scaffold(backgroundColor: backgroundColor, body: body);
  }

  Widget _buildBody(ReaderTheme theme) {
    if (theme.backgroundImage.isEmpty) return const SizedBox();
    return Image.asset(
      theme.backgroundImage,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Setting _getSetting(WidgetRef ref) {
    var provider = settingNotifierProvider;
    var state = ref.watch(provider).valueOrNull;
    return state ?? Setting();
  }

  ReaderTheme _getTheme(WidgetRef ref) {
    var provider = readerThemeNotifierProvider;
    var state = ref.watch(provider).valueOrNull;
    return state ?? ReaderTheme();
  }
}
