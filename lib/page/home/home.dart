import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/page/home/component/explore.dart';
import 'package:source_parser/page/home/component/profile.dart';
import 'package:source_parser/page/home/component/shelf.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
    var data = darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined;
    return Icon(data);
  }
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    final searchButton = IconButton(
      onPressed: handlePressed,
      icon: const Icon(Icons.search),
    );
    final shelfActions = [searchButton, _ShelfModeSelector()];
    final exploreActions = <Widget>[searchButton, _SourceSelector()];
    final settingActions = <Widget>[_DarkModeToggler()];
    final action = [shelfActions, exploreActions, settingActions][_index];
    final title = Text(['书架', '发现', '我的'].elementAt(_index));
    const children = [ShelfView(), ExploreView(), ProfileView()];
    final body = PageView(
      controller: controller,
      onPageChanged: handlePageChanged,
      children: children,
    );
    final destinations = _getDestinations(context);
    final navigationBar = NavigationBar(
      destinations: destinations,
      height: 64,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: _index,
      onDestinationSelected: handleDestinationSelected,
    );
    return Scaffold(
      appBar: AppBar(actions: action, centerTitle: true, title: title),
      body: body,
      bottomNavigationBar: navigationBar,
    );
  }

  void handleDestinationSelected(int index) {
    controller.jumpToPage(index);
    setState(() {
      _index = index;
    });
  }

  void handlePageChanged(int page) {
    setState(() {
      _index = page;
    });
  }

  void handlePressed() {
    AutoRouter.of(context).push(SearchRoute());
  }

  void toggleDarkMode(WidgetRef ref) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.toggleDarkMode();
  }

  void updateExploreSource(WidgetRef ref, int value) async {
    final setting = await ref.read(settingNotifierProvider.future);
    if (setting.exploreSource == value) return;
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateExploreSource(value);
  }

  void updateShelfMode(WidgetRef ref, String value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateShelfMode(value);
  }

  List<NavigationDestination> _getDestinations(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final shelf = NavigationDestination(
      icon: const Icon(Icons.local_library_outlined),
      selectedIcon: Icon(Icons.local_library, color: primary),
      label: '书架',
    );
    final explorer = NavigationDestination(
      icon: const Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore, color: primary),
      label: '发现',
    );
    final profile = NavigationDestination(
      icon: const Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person, color: primary),
      label: '我的',
    );
    return [shelf, explorer, profile];
  }
}

class _ShelfModeSelector extends ConsumerWidget {
  const _ShelfModeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final shelfMode = setting?.shelfMode ?? 'list';
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert_outlined),
      itemBuilder: (_) => _itemBuilder(shelfMode),
      offset: Offset(0, 8),
      onSelected: (value) => updateShelfMode(ref, value),
      position: PopupMenuPosition.under,
    );
  }

  void updateShelfMode(WidgetRef ref, String value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateShelfMode(value);
  }

  List<PopupMenuEntry> _itemBuilder(String shelfMode) {
    final value = shelfMode == 'list' ? 'grid' : 'list';
    final text = Text(shelfMode == 'list' ? '网格模式' : '列表模式');
    return [PopupMenuItem(value: value, child: text)];
  }
}

class _SourceSelector extends ConsumerWidget {
  const _SourceSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final source = setting?.exploreSource ?? 0;
    return PopupMenuButton(
      icon: const Icon(Icons.tune_outlined),
      initialValue: source,
      itemBuilder: (_) => _itemBuilder(),
      offset: Offset(0, 8),
      onSelected: (value) => updateExploreSource(ref, value),
      position: PopupMenuPosition.under,
    );
  }

  void updateExploreSource(WidgetRef ref, int source) async {
    final setting = await ref.read(settingNotifierProvider.future);
    if (setting.exploreSource == source) return;
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateExploreSource(source);
  }

  List<PopupMenuEntry> _itemBuilder() {
    final builder = isar.sources.filter();
    final sources = builder.exploreEnabledEqualTo(true).findAllSync();
    return sources.map((source) {
      return PopupMenuItem(value: source.id, child: Text(source.name));
    }).toList();
  }
}
