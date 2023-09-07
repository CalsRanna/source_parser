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
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert_outlined),
      ),
    ];
    final padding = MediaQuery.of(context).padding;
    final exploreActions = <Widget>[
      Watcher((_, ref, child) {
        final source = ref.watch(exploreSourceCreator);
        return PopupMenuButton(
          icon: const Icon(Icons.filter_alt_outlined),
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
          offset: Offset(0, padding.top + 8),
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

  void handlePressed() {
    context.push('/search');
  }

  void updateExploreSource(int value) async {
    final ref = context.ref;
    if (ref.read(exploreSourceCreator) != value) {
      ref.set(exploreSourceCreator, value);
      final source = await isar.sources.filter().idEqualTo(value).findFirst();
      if (source != null) {
        final exploreRule = jsonDecode(source.exploreJson);
        List<ExploreResult> results = [];
        for (var rule in exploreRule) {
          final layout = rule['layout'] ?? '';
          final title = rule['title'] ?? '';
          final exploreUrl = rule['exploreUrl'] ?? '';
          final books = await Parser.getExplore(exploreUrl, rule, source);
          results.add(
            ExploreResult(layout: layout, title: title, books: books),
          );
        }
        ref.set(exploreBooksCreator, results);
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
