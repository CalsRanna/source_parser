import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/util/message.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          ListTile(
            subtitle: const Text('网络请求缓存的有效时长，不影响缓存的封面和章节'),
            title: const Text('缓存时长'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(builder: (context, ref, child) {
                  final provider = ref.watch(settingNotifierProvider);
                  final setting = switch (provider) {
                    AsyncData(:final value) => value,
                    _ => Setting(),
                  };
                  final hour = setting.cacheDuration.floor();
                  return Text('$hour小时');
                }),
                const Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            ),
            onTap: () => showCacheSheet(context),
          ),
          ListTile(
            subtitle: const Text('搜索书籍和缓存章节内容时，最大并发请求数量'),
            title: const Text('最大线程数量'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(builder: (context, ref, child) {
                  final provider = ref.watch(settingNotifierProvider);
                  final setting = switch (provider) {
                    AsyncData(:final value) => value,
                    _ => Setting(),
                  };
                  final maxConcurrent = setting.maxConcurrent.floor();
                  return Text(maxConcurrent.toString());
                }),
                const Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            ),
            onTap: () => showConcurrentSheet(context),
          ),
          Consumer(builder: (context, ref, child) {
            final provider = ref.watch(settingNotifierProvider);
            final setting = switch (provider) {
              AsyncData(:final value) => value,
              _ => Setting(),
            };
            return SwitchListTile(
              subtitle: const Text('过滤书名或作者不包含关键字的搜索结果'),
              title: const Text('搜索过滤'),
              value: setting.searchFilter,
              onChanged: (value) => updateSearchFilter(ref, value),
            );
          }),
          ListTile(
            subtitle: const Text('网络请求最大等待时长，超时将取消请求'),
            title: const Text('请求超时'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(builder: (context, ref, child) {
                  final provider = ref.watch(settingNotifierProvider);
                  final setting = switch (provider) {
                    AsyncData(:final value) => value,
                    _ => Setting(),
                  };

                  final seconds =
                      Duration(milliseconds: setting.timeout).inSeconds;
                  return Text('$seconds秒');
                }),
                const Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            ),
            onTap: () => showTimeoutSheet(context),
          ),
          ListTile(
            title: const Text('清理缓存'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(builder: (context, ref, child) {
                  final provider = ref.watch(cacheSizeProvider);
                  final size = switch (provider) {
                    AsyncData(:final value) => value,
                    _ => '0 Bytes',
                  };
                  return Text(size);
                }),
                const Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            ),
            onTap: () => showClearCacheDialog(context),
          ),
        ],
      ),
    );
  }

  void cancelClear(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirmClear(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final message = Message.of(context);
    final notifier = ref.read(cacheSizeProvider.notifier);
    final succeed = await notifier.clear();
    navigator.pop();
    if (succeed) {
      message.show('已清空缓存');
    } else {
      message.show('清空缓存失败');
    }
  }

  void showCacheSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemBuilder: (context, index) {
          return Consumer(builder: (context, ref, child) {
            final duration = index * 4;
            var text = '$duration小时';
            if (duration == 0) text = '不缓存';
            if (duration == 24) text = '1天';
            return ListTile(
              title: Text(text, textAlign: TextAlign.center),
              onTap: () => updateCacheDuration(
                context,
                ref,
                duration.toDouble(),
              ),
            );
          });
        },
        itemCount: 7,
      ),
    );
  }

  void showClearCacheDialog(BuildContext context) async {
    showDialog(
      builder: (_) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => cancelClear(context),
              child: const Text('取消'),
            ),
            Consumer(builder: (context, ref, child) {
              return TextButton(
                onPressed: () => confirmClear(context, ref),
                child: const Text('确认'),
              );
            })
          ],
          content: const Text('确定清空所有已缓存的内容？'),
          title: const Text('清空缓存'),
        );
      },
      context: context,
    );
  }

  void showConcurrentSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemBuilder: (context, index) {
          final concurrent = (index + 1) * 4;
          return Consumer(builder: (context, ref, child) {
            return ListTile(
              title: Text('$concurrent', textAlign: TextAlign.center),
              onTap: () => updateMaxConcurrent(
                context,
                ref,
                concurrent.toDouble(),
              ),
            );
          });
        },
        itemCount: 4,
      ),
    );
  }

  void showTimeoutSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemBuilder: (context, index) {
          final timeout = (index + 1) * 15 * 1000;
          final seconds = Duration(milliseconds: timeout).inSeconds;
          return Consumer(builder: (context, ref, child) {
            return ListTile(
              title: Text('$seconds秒', textAlign: TextAlign.center),
              onTap: () => updateTimeout(context, ref, timeout),
            );
          });
        },
        itemCount: 4,
      ),
    );
  }

  void updateCacheDuration(
    BuildContext context,
    WidgetRef ref,
    double duration,
  ) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateCacheDuration(duration);
    Navigator.of(context).pop();
  }

  void updateMaxConcurrent(
      BuildContext context, WidgetRef ref, double concurrent) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateMaxConcurrent(concurrent);
    Navigator.of(context).pop();
  }

  void updateSearchFilter(WidgetRef ref, bool searchFilter) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateSearchFilter(searchFilter);
  }

  void updateTimeout(BuildContext context, WidgetRef ref, int timeout) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateTimeout(timeout);
    Navigator.of(context).pop();
  }
}
