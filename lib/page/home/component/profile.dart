import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/schema/setting.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _SettingTile(
          icon: Icons.view_agenda_outlined,
          route: '/book-source',
          title: '书源管理',
        ),
        const _SettingTile(
          icon: Icons.format_color_text_outlined,
          route: '/reader-theme',
          title: '阅读主题',
        ),
        _SettingTile(
          icon: Icons.auto_stories_outlined,
          title: '翻页方式',
          onTap: showTurningModeBottomSheet,
        ),
        const _EInkModeTile(),
        const _SettingTile(
          icon: Icons.settings_outlined,
          route: '/setting/advanced',
          title: '设置',
        ),
        const _SettingTile(
          icon: Icons.info_outline_rounded,
          route: '/setting/about',
          title: '关于元夕',
        ),
      ],
    );
  }

  void confirmUpdateTurningMode(WidgetRef ref, int value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateTurningMode(value);
  }

  void showTurningModeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        const checked = Icon(Icons.check);
        return Consumer(builder: (context, ref, child) {
          final provider = ref.watch(settingNotifierProvider);
          final setting = switch (provider) {
            AsyncData(:final value) => value,
            _ => Setting(),
          };
          final turningMode = setting.turningMode;
          return ListView(
            children: [
              ListTile(
                title: const Text('滑动翻页'),
                trailing: turningMode & 1 != 0 ? checked : null,
                onTap: () => confirmUpdateTurningMode(ref, 1),
              ),
              ListTile(
                title: const Text('点击翻页'),
                trailing: turningMode & 2 != 0 ? checked : null,
                onTap: () => confirmUpdateTurningMode(ref, 2),
              ),
            ],
          );
        });
      },
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData? icon;

  final String? route;
  final String title;
  final void Function()? onTap;
  const _SettingTile({
    this.icon,
    this.route,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    var leading = icon != null ? Icon(icon, color: primary) : null;
    final trailing = Icon(
      Icons.arrow_forward_ios,
      color: onSurfaceVariant,
      size: 16,
    );
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: trailing,
      onTap: () => handleTap(context),
    );
  }

  void handleTap(BuildContext context) {
    if (route == null) {
      onTap?.call();
      return;
    }
    switch (route) {
      case '/book-source':
        const SourceListPageRoute().push(context);
        break;
      case '/reader-theme':
        const BookReaderThemePageRoute().push(context);
        break;
      case '/setting/advanced':
        const SettingPageRoute().push(context);
        break;
      case '/setting/about':
        const AboutPageRoute().push(context);
        break;
      default:
        break;
    }
  }
}

class _EInkModeTile extends StatelessWidget {
  const _EInkModeTile();

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) return const SizedBox();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    return ListTile(
      leading: Icon(Icons.chrome_reader_mode_outlined, color: primary),
      title: const Text('墨水屏模式'),
      trailing: Consumer(builder: (context, ref, child) {
        final provider = ref.watch(settingNotifierProvider);
        final eInkMode = switch (provider) {
          AsyncData(:final value) => value.eInkMode,
          _ => false,
        };
        return Switch(
          value: eInkMode,
          onChanged: (value) => updateEInkMode(ref, value),
        );
      }),
    );
  }

  void updateEInkMode(WidgetRef ref, bool value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateEInkMode(value);
  }
}
