import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/model/setting.dart';
import 'package:source_parser/page/home/widget/explore.dart';
import 'package:source_parser/page/home/widget/setting.dart';
import 'package:source_parser/page/home/widget/shelf.dart';
import 'package:source_parser/state/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final titles = ['书架', '发现', '我的'];
    final shelfActions = [
      IconButton(
        onPressed: () => handlePressed(context),
        icon: const Icon(Icons.search),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
      ),
    ];
    final exploreActions = [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.filter_alt_outlined),
      ),
    ];
    final settingActions = [
      EmitterWatcher<Setting>(
        builder: (context, setting) => IconButton(
          icon: Icon(setting.darkMode
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined),
          onPressed: () => triggerDarkMode(context),
        ),
        emitter: settingEmitter,
      ),
      IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
    ];
    final destinations = [
      const NavigationDestination(
        icon: Icon(Icons.menu_book_outlined),
        label: '书架',
      ),
      const NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        label: '发现',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        label: '我的',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [shelfActions, exploreActions, settingActions][_index],
        centerTitle: true,
        title: Text(titles[_index]),
      ),
      body: const [ShelfView(), ExploreView(), SettingView()][_index],
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        height: 56,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _index,
        onDestinationSelected: handleDestinationSelected,
      ),
    );
  }

  void handlePressed(BuildContext context) {
    context.push('/search');
  }

  void triggerDarkMode(BuildContext context) async {
    final ref = context.ref;
    final isar = await ref.read(isarEmitter);
    await isar.writeTxn(() async {
      var setting = await isar.settings.where().findFirst() ?? Setting();
      setting.darkMode = !setting.darkMode;
      isar.settings.put(setting);
      ref.emit(settingEmitter, setting);
    });
  }

  void handleDestinationSelected(int index) {
    setState(() {
      _index = index;
    });
  }
}
