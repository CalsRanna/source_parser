import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/setting.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final provider = ref.watch(settingNotifierProvider);
      final eInkMode = switch (provider) {
        AsyncData(:final value) => value.eInkMode,
        _ => false,
      };
      return eInkMode ? const Text('正在加载') : const CircularProgressIndicator();
    });
  }
}
