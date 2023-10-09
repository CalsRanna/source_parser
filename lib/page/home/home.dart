import 'dart:convert';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/explore.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/model/explore.dart';
import 'package:source_parser/page/home/component/explore.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/page/home/component/setting.dart';
import 'package:source_parser/page/home/component/shelf.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';

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
        onPressed: handlePressed,
        icon: const Icon(Icons.search),
      ),
      Watcher((context, ref, child) {
        final mode = ref.watch(shelfModeCreator);
        return PopupMenuButton(
          icon: const Icon(Icons.more_vert_outlined),
          itemBuilder: (_) {
            return [
              PopupMenuItem(
                value: mode == 'list' ? 'grid' : 'list',
                child: Text(mode == 'list' ? '网格模式' : '列表模式'),
              )
            ];
          },
          onSelected: updateShelfMode,
        );
      }),
    ];
    final exploreActions = <Widget>[
      IconButton(
        onPressed: handlePressed,
        icon: const Icon(Icons.search),
      ),
      Watcher((_, ref, child) {
        final source = ref.watch(exploreSourceCreator);
        return PopupMenuButton(
          icon: const Icon(Icons.tune_outlined),
          initialValue: source,
          itemBuilder: (_) {
            final builder = isar.sources.filter();
            final sources = builder.exploreEnabledEqualTo(true).findAllSync();
            return sources.map((source) {
              return PopupMenuItem(
                value: source.id,
                child: Text(source.name),
              );
            }).toList();
          },
          onSelected: updateExploreSource,
        );
      }),
    ];
    final settingActions = <Widget>[
      Watcher((context, ref, child) {
        final darkMode = ref.watch(darkModeCreator);
        return IconButton(
          icon: Icon(
            darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          onPressed: triggerDarkMode,
        );
      }),
    ];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.local_library_outlined),
        selectedIcon: Icon(Icons.local_library, color: primary),
        label: '书架',
      ),
      NavigationDestination(
        icon: const Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore, color: primary),
        label: '发现',
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person, color: primary),
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
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _index,
        onDestinationSelected: handleDestinationSelected,
      ),
    );
  }

  void handlePressed() {
    context.push('/search');
  }

  void updateShelfMode(String value) async {
    context.ref.set(shelfModeCreator, value);
    final builder = isar.settings.where();
    var setting = await builder.findFirst();
    if (setting != null) {
      setting.shelfMode = value;
      await isar.writeTxn(() async {
        await isar.settings.put(setting);
      });
    }
  }

  void updateExploreSource(int value) async {
    final ref = context.ref;
    if (ref.read(exploreSourceCreator) != value) {
      ref.set(exploreLoadingCreator, true);
      ref.set(exploreBooksCreator, <ExploreResult>[]);
      ref.set(exploreSourceCreator, value);
      final source = await isar.sources.filter().idEqualTo(value).findFirst();
      if (source != null) {
        final json = jsonDecode(source.exploreJson);
        final titles = json.map((item) {
          return item['title'];
        }).toList();
        List<ExploreResult> results = [];
        final duration = ref.read(cacheDurationCreator);
        final stream = await Parser.getExplore(
          source,
          Duration(hours: duration.floor()),
        );
        stream.listen((result) {
          results.add(result);
          results.sort((a, b) {
            final indexOfA = titles.indexOf(a.title);
            final indexOfB = titles.indexOf(b.title);
            return indexOfA.compareTo(indexOfB);
          });
          ref.set(exploreBooksCreator, results);
        });
        ref.set(exploreLoadingCreator, false);
      }
      final builder = isar.settings.where();
      var setting = await builder.findFirst();
      if (setting != null) {
        setting.exploreSource = value;
        await isar.writeTxn(() async {
          await isar.settings.put(setting);
        });
      }
    }
  }

  void triggerDarkMode() async {
    final ref = context.ref;
    final darkMode = ref.read(darkModeCreator);
    ref.set(darkModeCreator, !darkMode);
    var setting = await isar.settings.where().findFirst();
    if (setting != null) {
      setting.darkMode = !darkMode;
      await isar.writeTxn(() async {
        isar.settings.put(setting);
      });
    }
  }

  void handleDestinationSelected(int index) {
    setState(() {
      _index = index;
    });
  }
}
