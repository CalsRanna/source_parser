import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/theme/color_picker.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      actions: [_DarkModeToggler()],
      centerTitle: true,
      title: Text('我的'),
    );
    var source = _SettingTile(
      icon: HugeIcons.strokeRoundedSourceCodeCircle,
      onTap: () => handleTap(context, const SourceListRoute()),
      title: '书源管理',
    );
    var theme = _SettingTile(
      icon: HugeIcons.strokeRoundedTextFont,
      onTap: () => handleTap(context, const ReaderThemeRoute()),
      title: '主题',
    );
    var layout = _SettingTile(
      icon: HugeIcons.strokeRoundedSmartPhone01,
      onTap: () => handleTap(context, const ReaderLayoutRoute()),
      title: '功能布局',
    );
    var setting = _SettingTile(
      icon: HugeIcons.strokeRoundedSettings01,
      onTap: () => handleTap(context, const SettingRoute()),
      title: '设置',
    );
    var about = _SettingTile(
      icon: HugeIcons.strokeRoundedInformationCircle,
      onTap: () => handleTap(context, const AboutRoute()),
      title: '关于元夕',
    );
    var color = _SettingTile(
      icon: HugeIcons.strokeRoundedInformationCircle,
      onTap: () => navigateColor(context),
      title: 'color'.toUpperCase(),
    );
    var listView =
        ListView(children: [source, theme, layout, setting, about, color]);
    return Scaffold(appBar: appBar, body: listView);
  }

  void navigateColor(BuildContext context) {
    ColorPicker.pick(context);
  }

  void handleTap(BuildContext context, PageRouteInfo route) {
    AutoRouter.of(context).push(route);
  }
}

class _DarkModeToggler extends ConsumerWidget {
  const _DarkModeToggler();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final darkMode = setting?.darkMode ?? false;
    return IconButton(
      icon: _buildIcon(darkMode),
      onPressed: () => toggleDarkMode(ref),
    );
  }

  void toggleDarkMode(WidgetRef ref) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.toggleDarkMode();
  }

  Icon _buildIcon(bool darkMode) {
    var icon = HugeIcons.strokeRoundedMoon02;
    if (darkMode) icon = HugeIcons.strokeRoundedSun03;
    return Icon(icon);
  }
}

class _SettingTile extends StatelessWidget {
  final IconData? icon;
  final void Function()? onTap;
  final String title;

  const _SettingTile({this.icon, this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final leading = icon != null ? Icon(icon, color: primary) : null;
    final trailing = Icon(HugeIcons.strokeRoundedArrowRight01);
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
