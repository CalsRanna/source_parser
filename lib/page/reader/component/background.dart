import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/reader_theme.dart';
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
    Widget body = _buildBody();
    return Scaffold(backgroundColor: backgroundColor, body: body);
  }

  Widget _buildBody() {
    if (theme.backgroundImage.isEmpty) return const SizedBox();
    return Image.asset(
      theme.backgroundImage,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }
}
