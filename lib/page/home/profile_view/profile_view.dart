import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/service.dart';
import 'package:source_parser/page/theme/color_picker.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

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
    var server = _SettingTile(
      icon: HugeIcons.strokeRoundedCloudServer,
      onTap: () => handleTap(context, const LocalServerRoute()),
      title: '本地服务器',
    );
    var fileManager = _SettingTile(
      icon: HugeIcons.strokeRoundedFolderFileStorage,
      onTap: () => handleTap(context, const FileManagerRoute()),
      title: '文件管理',
    );
    var cloudReader = _SettingTile(
      icon: HugeIcons.strokeRoundedInternet,
      onTap: () => handleTap(context, const CloudReaderRoute()),
      title: '云阅读（New）',
    );
    var simpleCloudReader = _SettingTile(
      icon: HugeIcons.strokeRoundedInternet,
      onTap: () => handleTap(context, const SimpleCloudReaderRoute()),
      title: '云阅读',
    );
    var database = _SettingTile(
      icon: HugeIcons.strokeRoundedDatabaseSetting,
      onTap: () => cleanDatabase(context),
      title: '清理数据库',
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
      icon: HugeIcons.strokeRoundedColors,
      onTap: () => navigateColor(context),
      title: 'color'.toUpperCase(),
    );
    var children = [
      source,
      theme,
      layout,
      server,
      fileManager,
      cloudReader,
      simpleCloudReader,
      database,
      setting,
      about,
      if (kDebugMode) color,
    ];
    var listView = ListView(children: children);
    return Scaffold(appBar: appBar, body: listView);
  }

  Future<void> cleanDatabase(BuildContext context) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('book_sources').where('id', 0).delete();
    await laconic.table('books').where('id', 0).delete();
    // await laconic.table('books').where('source_id', 0).delete();
    await laconic.table('chapters').where('id', 0).delete();
    await laconic.table('chapters').where('book_id', 0).delete();
    await laconic.table('covers').where('id', 0).delete();
    await laconic.table('covers').where('book_id', 0).delete();
    await laconic.table('available_sources').where('id', 0).delete();
    await laconic.table('available_sources').where('book_id', 0).delete();
    await laconic.table('available_sources').where('source_id', 0).delete();
    if (!context.mounted) return;
    Message.of(context).show('数据库清理完成');
  }

  void handleTap(BuildContext context, PageRouteInfo route) {
    AutoRouter.of(context).push(route);
  }

  void navigateColor(BuildContext context) {
    ColorPicker.pick(context);
  }
}

class _DarkModeToggler extends StatelessWidget {
  final viewModel = GetIt.instance<SourceParserViewModel>();

  _DarkModeToggler();

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) => IconButton(
        icon: _buildIcon(viewModel.isDarkMode.value),
        onPressed: viewModel.toggleDarkMode,
      ),
    );
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
