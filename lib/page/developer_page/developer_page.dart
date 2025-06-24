import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/developer_page/developer_view_model.dart';

@RoutePage()
class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  final viewModel = GetIt.instance.get<DeveloperViewModel>();

  @override
  Widget build(BuildContext context) {
    var developer = _buildDeveloperModeTile();
    var fileManager = _Tile(
      icon: HugeIcons.strokeRoundedFolderFileStorage,
      onTap: () => viewModel.navigateFileManagerPage(context),
      title: '文件管理',
    );
    var cloudReader = _Tile(
      icon: HugeIcons.strokeRoundedInternet,
      onTap: () => viewModel.navigateCloudReaderPage(context),
      title: '云阅读（New）',
    );
    var simpleCloudReader = _Tile(
      icon: HugeIcons.strokeRoundedInternet,
      onTap: () => viewModel.navigateSimpleCloudReaderPage(context),
      title: '云阅读',
    );
    var localDatabase = _Tile(
      icon: HugeIcons.strokeRoundedDatabase,
      onTap: () => viewModel.navigateDatabasePage(context),
      title: '本地数据库',
    );
    var cleanDatabase = _Tile(
      icon: HugeIcons.strokeRoundedDatabaseSetting,
      onTap: () => viewModel.cleanDatabase(context),
      title: '清理数据库',
    );
    var color = _Tile(
      icon: HugeIcons.strokeRoundedColors,
      onTap: () => viewModel.navigateColor(context),
      title: '颜色选择器',
    );
    var analysis = _Tile(
      icon: HugeIcons.strokeRoundedColors,
      onTap: () => viewModel.analyze(context),
      title: '分析书架',
    );
    var children = [
      developer,
      fileManager,
      cloudReader,
      simpleCloudReader,
      localDatabase,
      cleanDatabase,
      color,
      analysis,
    ];
    return Scaffold(
      appBar: AppBar(title: Text('开发者页面')),
      body: ListView(children: children),
    );
  }

  Widget _buildDeveloperModeTile() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final leading = Icon(
      HugeIcons.strokeRoundedPhoneDeveloperMode,
      color: primary,
    );
    return SwitchListTile(
      secondary: leading,
      title: Text('启用开发者模式'),
      value: true,
      onChanged: (value) => viewModel.disableDeveloperMode(context),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData? icon;
  final void Function()? onTap;
  final String title;

  const _Tile({this.icon, this.onTap, required this.title});

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
