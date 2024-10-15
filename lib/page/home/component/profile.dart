import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/router/router.gr.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    const source = _SettingTile(
      icon: Icons.view_agenda_outlined,
      route: '/book-source',
      title: '书源管理',
    );
    const theme = _SettingTile(
      icon: Icons.format_color_text_outlined,
      route: '/reader-theme',
      title: '阅读主题',
    );
    const setting = _SettingTile(
      icon: Icons.settings_outlined,
      route: '/setting/advanced',
      title: '设置',
    );
    const about = _SettingTile(
      icon: Icons.info_outline_rounded,
      route: '/setting/about',
      title: '关于元夕',
    );
    return ListView(children: [source, theme, setting, about]);
  }
}

class _SettingTile extends StatelessWidget {
  final IconData? icon;
  final String? route;
  final String title;

  const _SettingTile({this.icon, this.route, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final leading = icon != null ? Icon(icon, color: primary) : null;
    final trailing = Icon(Icons.chevron_right_outlined);
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: trailing,
      onTap: () => handleTap(context),
    );
  }

  void handleTap(BuildContext context) {
    if (route == null) return;
    switch (route) {
      case '/book-source':
        AutoRouter.of(context).push(SourceListRoute());
        break;
      case '/reader-theme':
        AutoRouter.of(context).push(ReaderThemeRoute());
        break;
      case '/setting/advanced':
        AutoRouter.of(context).push(SettingRoute());
        break;
      case '/setting/about':
        AutoRouter.of(context).push(AboutRoute());
        break;
      default:
        break;
    }
  }
}
