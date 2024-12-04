import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/home/component/bookshelf.dart';
import 'package:source_parser/page/home/component/explore.dart';
import 'package:source_parser/page/home/component/profile.dart';
import 'package:source_parser/provider/reader.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final controller = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var container = ProviderScope.containerOf(context);
      var provider = mediaQueryDataNotifierProvider;
      var notifier = container.read(provider.notifier);
      notifier.updateSize(MediaQuery.of(context));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = PageView(
      controller: controller,
      onPageChanged: handlePageChanged,
      children: [BookshelfView(), ExploreView(), ProfileView()],
    );
    final destinations = _buildDestinations(context);
    final navigationBar = NavigationBar(
      destinations: destinations,
      height: 64,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: _index,
      onDestinationSelected: handleDestinationSelected,
    );
    return Scaffold(body: body, bottomNavigationBar: navigationBar);
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

  List<NavigationDestination> _buildDestinations(BuildContext context) {
    final shelf = NavigationDestination(
      icon: const Icon(HugeIcons.strokeRoundedBookOpen02),
      label: '书架',
    );
    final explorer = NavigationDestination(
      icon: const Icon(HugeIcons.strokeRoundedDiscoverCircle),
      label: '发现',
    );
    final profile = NavigationDestination(
      icon: const Icon(HugeIcons.strokeRoundedUser),
      label: '我的',
    );
    return [shelf, explorer, profile];
  }
}
