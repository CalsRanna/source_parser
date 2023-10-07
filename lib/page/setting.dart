import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';

class AdvancedSettingPage extends StatelessWidget {
  const AdvancedSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyLarge = textTheme.bodyLarge;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    final colorScheme = theme.colorScheme;
    final onBackground = colorScheme.onBackground;
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('最大线程数量', style: bodyLarge),
                Watcher((context, ref, child) {
                  final maxConcurrent = ref.watch(maxConcurrentCreator);
                  final concurrent = maxConcurrent.floor();
                  return Text(concurrent.toString(), style: bodySmall);
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '搜索书籍和缓存章节内容时，最大并发请求数量',
              style: bodyMedium?.copyWith(color: onBackground.withOpacity(0.8)),
            ),
          ),
          Watcher((context, ref, child) {
            final maxConcurrent = ref.watch(maxConcurrentCreator);
            return Slider(
              divisions: 15,
              max: 16,
              min: 1,
              value: maxConcurrent,
              onChanged: (value) => updateMaxConcurrent(context, value),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('缓存有效时长', style: bodyLarge),
                Watcher((context, ref, child) {
                  final cacheDuration = ref.watch(cacheDurationCreator);
                  final hour = cacheDuration.floor();
                  return Text('$hour小时', style: bodySmall);
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '网络请求缓存的有效时长',
              style: bodyMedium?.copyWith(color: onBackground.withOpacity(0.8)),
            ),
          ),
          Watcher((context, ref, child) {
            final cacheDuration = ref.watch(cacheDurationCreator);
            return Slider(
              divisions: 24,
              max: 24,
              value: cacheDuration,
              onChanged: (value) => updateCacheDuration(context, value),
            );
          }),
        ],
      ),
    );
  }

  void updateCacheDuration(BuildContext context, double duration) async {
    final ref = context.ref;
    ref.set(cacheDurationCreator, duration);
    var setting = await isar.settings.where().findFirst();
    if (setting != null) {
      setting.cacheDuration = duration;
      await isar.writeTxn(() async {
        isar.settings.put(setting);
      });
    }
  }

  void updateMaxConcurrent(BuildContext context, double concurrent) async {
    final ref = context.ref;
    ref.set(maxConcurrentCreator, concurrent);
    var setting = await isar.settings.where().findFirst();
    if (setting != null) {
      setting.maxConcurrent = concurrent;
      await isar.writeTxn(() async {
        isar.settings.put(setting);
      });
    }
  }
}
