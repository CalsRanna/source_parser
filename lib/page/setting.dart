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
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          ListTile(
            subtitle: const Text('搜索书籍和缓存章节内容时，最大并发请求数量'),
            title: const Text('最大线程数量'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Watcher((context, ref, child) {
                  final maxConcurrent = ref.watch(maxConcurrentCreator);
                  final concurrent = maxConcurrent.floor();
                  return Text(concurrent.toString());
                }),
                const Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            ),
            onTap: () => showConcurrentSheet(context),
          ),
          ListTile(
            subtitle: const Text('网络请求缓存的有效时长'),
            title: const Text('缓存时长'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Watcher((context, ref, child) {
                  final cacheDuration = ref.watch(cacheDurationCreator);
                  final hour = cacheDuration.floor();
                  return Text('$hour小时');
                }),
                const Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            ),
            onTap: () => showCacheSheet(context),
          ),
          ListTile(
            subtitle: const Text('网络请求最大等待时长，超时将取消请求'),
            title: const Text('请求超时'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Watcher((context, ref, child) {
                  final timeout = ref.watch(timeoutCreator);
                  final seconds = Duration(milliseconds: timeout).inSeconds;
                  return Text('$seconds秒');
                }),
                const Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            ),
            onTap: () => showTimeoutSheet(context),
          ),
        ],
      ),
    );
  }

  void showCacheSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text('$index小时'),
          onTap: () => updateCacheDuration(context, index.toDouble()),
        ),
        itemCount: 25,
      ),
    );
  }

  void showConcurrentSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text('${index + 1}'),
          onTap: () => updateMaxConcurrent(context, index + 1),
        ),
        itemCount: 16,
      ),
    );
  }

  void showTimeoutSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text('${(index + 1) * 15}秒'),
          onTap: () => updateTimeout(context, (index + 1) * 15 * 1000),
        ),
        itemCount: 4,
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
    if (!context.mounted) return;
    Navigator.of(context).pop();
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
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  void updateTimeout(BuildContext context, int timeout) async {
    final ref = context.ref;
    ref.set(timeoutCreator, timeout);
    var setting = await isar.settings.where().findFirst();
    if (setting != null) {
      setting.timeout = timeout;
      await isar.writeTxn(() async {
        isar.settings.put(setting);
      });
    }
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}
