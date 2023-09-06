import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/page/home/component/explore.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/page/home/component/setting.dart';
import 'package:source_parser/page/home/component/shelf.dart';

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
        icon: const Icon(Icons.more_vert_outlined),
      ),
    ];
    final exploreActions = <Widget>[
      // IconButton(
      //   onPressed: () {},
      //   icon: const Icon(Icons.filter_alt_outlined),
      // ),
    ];
    final settingActions = <Widget>[
      Watcher((context, ref, child) {
        final darkMode = ref.watch(darkModeCreator);
        return IconButton(
          icon: Icon(
            darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          onPressed: () => triggerDarkMode(context),
        );
      }),
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
    final darkMode = ref.read(darkModeCreator);
    ref.set(darkModeCreator, !darkMode);
    var setting = await isar.settings.where().findFirst();
    setting ??= Setting();
    setting.darkMode = !darkMode;
    await isar.writeTxn(() async {
      isar.settings.put(setting!);
    });
  }

  void handleDestinationSelected(int index) {
    setState(() {
      _index = index;
    });
  }
}
