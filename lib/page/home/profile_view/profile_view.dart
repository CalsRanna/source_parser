import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/home/profile_view/profile_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileViewState();
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

class _ProfileViewState extends State<ProfileView> {
  final viewModel = GetIt.instance.get<ProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      actions: [_DarkModeToggler()],
      centerTitle: true,
      title: Text('我的'),
    );
    var listView = Watch((_) {
      var source = _SettingTile(
        icon: HugeIcons.strokeRoundedSourceCodeCircle,
        onTap: () => handleTap(context, const SourceListRoute()),
        title: '书源管理',
      );
      var theme = _SettingTile(
        icon: HugeIcons.strokeRoundedTextFont,
        onTap: () => handleTap(context, const ReaderThemeRoute()),
        title: '阅读器主题',
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
      var setting = _SettingTile(
        icon: HugeIcons.strokeRoundedSettings01,
        onTap: () => handleTap(context, const SettingRoute()),
        title: '设置',
      );
      var developer = _SettingTile(
        icon: HugeIcons.strokeRoundedDeveloper,
        onTap: () => viewModel.navigateDeveloperPage(context),
        title: '开发者页面',
      );
      var about = _SettingTile(
        icon: HugeIcons.strokeRoundedInformationCircle,
        onTap: () => viewModel.navigateAboutPage(context),
        title: '关于元夕',
      );
      var children = [
        source,
        theme,
        layout,
        server,
        setting,
        if (viewModel.enableDeveloperMode.value) developer,
        about,
      ];
      return ListView(children: children);
    });
    return Scaffold(appBar: appBar, body: listView);
  }

  void handleTap(BuildContext context, PageRouteInfo route) {
    AutoRouter.of(context).push(route);
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

  Future<void> navigateDeveloperPage(BuildContext context) async {
    var enableDeveloperMode = await DeveloperRoute().push<bool>(context);
    if (enableDeveloperMode == false) {}
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
