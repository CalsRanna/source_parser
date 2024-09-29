import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/setting.dart';

class LoadingIndicator extends ConsumerWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    if (setting == null) return const CircularProgressIndicator();
    final eInkMode = setting.eInkMode;
    return eInkMode ? const Text('正在加载') : const CircularProgressIndicator();
  }
}
