import 'dart:io';

import 'package:creator/creator.dart' hide AsyncData;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/util/message.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceVariant = colorScheme.surfaceVariant;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: surfaceVariant,
          elevation: 0,
          child: const Column(
            children: [
              SettingTile(
                icon: Icons.view_agenda_outlined,
                route: '/book-source',
                title: '书源管理',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: surfaceVariant,
          elevation: 0,
          child: Column(
            children: [
              const SettingTile(
                icon: Icons.format_color_text_outlined,
                route: '/reader-theme',
                title: '阅读主题',
              ),
              SettingTile(
                icon: Icons.auto_stories_outlined,
                title: '翻页方式',
                onTap: () => updateTurningMode(context),
              ),
              if (Platform.isAndroid)
                Watcher((context, ref, child) {
                  final eInkMode = ref.watch(eInkModeCreator);
                  return ListTile(
                    leading: Icon(
                      Icons.chrome_reader_mode_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('墨水屏模式'),
                    trailing: Switch(
                      value: eInkMode,
                      onChanged: (value) => updateEInkMode(context, value),
                    ),
                  );
                }),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: surfaceVariant,
          elevation: 0,
          child: const Column(
            children: [
              SettingTile(
                icon: Icons.settings_outlined,
                route: '/setting/advanced',
                title: '设置',
              ),
              SettingTile(
                icon: Icons.info_outline_rounded,
                route: '/setting/about',
                title: '关于元夕',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: surfaceVariant,
          elevation: 0,
          child: Column(
            children: [
              Consumer(builder: (context, ref, child) {
                final provider = ref.watch(cacheSizeProvider);
                final size = switch (provider) {
                  AsyncData(:final value) => value,
                  _ => '0 Bytes',
                };
                return SettingTile(
                  icon: Icons.file_download_outlined,
                  title: '缓存',
                  trailing: Text(size),
                  onTap: () => clearCache(context),
                );
              })
            ],
          ),
        ),
      ],
    );
  }

  void cancelClear(BuildContext context) {
    Navigator.of(context).pop();
  }

  void clearCache(BuildContext context) async {
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

  void confirmUpdateTurningMode(BuildContext context, int value) async {
    final ref = context.ref;
    var turningMode = ref.read(turningModeCreator);
    if (turningMode & value != 0) {
      turningMode = turningMode - value;
    } else {
      turningMode = turningMode + value;
    }
    ref.set(turningModeCreator, turningMode);
    final builder = isar.settings.where();
    var setting = await builder.findFirst();
    if (setting != null) {
      setting.turningMode = turningMode;
      await isar.writeTxn(() async {
        await isar.settings.put(setting);
      });
    }
  }

  void updateEInkMode(BuildContext context, bool value) async {
    context.ref.set(eInkModeCreator, value);
    final builder = isar.settings.where();
    var setting = await builder.findFirst();
    if (setting != null) {
      setting.eInkMode = value;
      await isar.writeTxn(() async {
        await isar.settings.put(setting);
      });
    }
  }

  void updateTurningMode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Watcher((context, ref, child) {
          final turningMode = ref.watch(turningModeCreator);
          const checked = Icon(Icons.check);
          return ListView(
            children: [
              ListTile(
                title: const Text('滑动翻页'),
                trailing: turningMode & 1 != 0 ? checked : null,
                onTap: () => confirmUpdateTurningMode(context, 1),
              ),
              ListTile(
                title: const Text('点击翻页'),
                trailing: turningMode & 2 != 0 ? checked : null,
                onTap: () => confirmUpdateTurningMode(context, 2),
              ),
            ],
          );
        });
      },
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData? icon;

  final String? route;
  final String title;
  final Widget? trailing;
  final void Function()? onTap;
  const SettingTile({
    super.key,
    this.icon,
    this.route,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    var leading = icon != null ? Icon(icon, color: primary) : null;
    final defaultTrailing = Icon(
      Icons.arrow_forward_ios,
      color: onSurfaceVariant,
      size: 16,
    );
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: trailing ?? defaultTrailing,
      onTap: () => handleTap(context),
    );
  }

  void handleTap(BuildContext context) {
    if (route != null) {
      context.push(route!);
    } else {
      onTap?.call();
    }
  }
}
