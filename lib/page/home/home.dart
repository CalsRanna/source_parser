import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/page/home/component/explore.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/page/home/component/profile.dart';
import 'package:source_parser/page/home/component/shelf.dart';
import 'package:source_parser/schema/source.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    final titles = ['书架', '发现', '我的'];
    final shelfActions = [
      IconButton(
        onPressed: handlePressed,
        icon: const Icon(Icons.search),
      ),
      Consumer(builder: (context, ref, child) {
        final provider = ref.watch(settingNotifierProvider);
        final setting = switch (provider) {
          AsyncData(:final value) => value,
          _ => Setting(),
        };
        final mode = setting.shelfMode;
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
          onSelected: (value) => updateShelfMode(ref, value),
        );
      }),
    ];
    final exploreActions = <Widget>[
      IconButton(
        onPressed: handlePressed,
        icon: const Icon(Icons.search),
      ),
      Consumer(builder: (context, ref, child) {
        final provider = ref.watch(settingNotifierProvider);
        final setting = switch (provider) {
          AsyncData(:final value) => value,
          _ => Setting(),
        };
        final source = setting.exploreSource;
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
          onSelected: (value) => updateExploreSource(ref, value),
        );
      })
    ];
    final settingActions = <Widget>[
      Consumer(builder: (context, ref, child) {
        final provider = ref.watch(settingNotifierProvider);
        final setting = switch (provider) {
          AsyncData(:final value) => value,
          _ => Setting(),
        };
        final darkMode = setting.darkMode;
        return IconButton(
          icon: Icon(
            darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          onPressed: () => toggleDarkMode(ref),
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
      body: PageView(
        controller: controller,
        onPageChanged: handlePageChanged,
        children: const [ShelfView(), ExploreView(), ProfileView()],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _index,
        onDestinationSelected: handleDestinationSelected,
      ),
    );
  }

  void handlePageChanged(int page) {
    setState(() {
      _index = page;
    });
  }

  void handlePressed() {
    const SearchPageRoute().push(context);
  }

  void updateShelfMode(WidgetRef ref, String value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateShelfMode(value);
  }

  void updateExploreSource(WidgetRef ref, int value) async {
    final setting = await ref.read(settingNotifierProvider.future);
    if (setting.exploreSource == value) return;
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateExploreSource(value);
  }

  void toggleDarkMode(WidgetRef ref) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.toggleDarkMode();
  }

  void handleDestinationSelected(int index) {
    controller.jumpToPage(index);
    setState(() {
      _index = index;
    });
  }
}
