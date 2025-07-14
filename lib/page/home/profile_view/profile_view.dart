import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/home/profile_view/profile_dark_mode_switch.dart';
import 'package:source_parser/page/home/profile_view/profile_setting_list_tile.dart';
import 'package:source_parser/page/home/profile_view/profile_view_model.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';
import 'package:source_parser/router/router.gr.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final viewModel = GetIt.instance.get<ProfileViewModel>();
  final sourceParserViewModel = GetIt.instance.get<SourceParserViewModel>();

  @override
  Widget build(BuildContext context) {
    var darkModeSwitch = Watch(
      (_) => ProfileDarkModeSwitch(
        darkMode: sourceParserViewModel.isDarkMode.value,
        onModeChanged: sourceParserViewModel.toggleDarkMode,
      ),
    );
    var appBar = AppBar(
      actions: [darkModeSwitch],
      centerTitle: true,
      title: Text('我的'),
    );
    var listView = Watch((_) {
      var source = ProfileSettingListTile(
        icon: HugeIcons.strokeRoundedSourceCodeCircle,
        onTap: () => handleTap(context, const SourceRoute()),
        title: '书源管理',
      );
      var theme = ProfileSettingListTile(
        icon: HugeIcons.strokeRoundedTextFont,
        onTap: () => handleTap(context, const ReaderThemeRoute()),
        title: '阅读器主题',
      );
      var layout = ProfileSettingListTile(
        icon: HugeIcons.strokeRoundedSmartPhone01,
        onTap: () => handleTap(context, const ReaderLayoutRoute()),
        title: '功能布局',
      );
      var server = ProfileSettingListTile(
        icon: HugeIcons.strokeRoundedCloudServer,
        onTap: () => handleTap(context, const LocalServerRoute()),
        title: '本地服务器',
      );
      var setting = ProfileSettingListTile(
        icon: HugeIcons.strokeRoundedSettings01,
        onTap: () => handleTap(context, const SettingRoute()),
        title: '设置',
      );
      var developer = ProfileSettingListTile(
        icon: HugeIcons.strokeRoundedDeveloper,
        onTap: () => viewModel.navigateDeveloperPage(context),
        title: '开发者页面',
      );
      var about = ProfileSettingListTile(
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
