import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/page/reader/component/page.dart';
import 'package:source_parser/provider/setting.dart';

class ReaderBackground extends ConsumerWidget {
  final ReaderTheme theme;
  const ReaderBackground({super.key, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = settingNotifierProvider;
    var setting = ref.watch(provider).valueOrNull;
    var darkMode = setting?.darkMode ?? false;
    var backgroundColor = darkMode ? Colors.black : theme.backgroundColor;
    Widget body = const SizedBox();
    if (theme.backgroundImage.isNotEmpty) {
      body = Image.asset(
        theme.backgroundImage,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }
    return Scaffold(backgroundColor: backgroundColor, body: body);
  }
}
