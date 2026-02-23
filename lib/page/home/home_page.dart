import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view.dart';
import 'package:source_parser/page/home/explore_view/explore_view.dart';
import 'package:source_parser/page/home/profile_view/profile_view.dart';
import 'package:source_parser/page/home/home_view_model.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final viewModel = GetIt.instance.get<HomeViewModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var body = Watch(
      (_) => PageView(
        controller: viewModel.controller,
        onPageChanged: viewModel.changePage,
        children: [BookshelfView(), ExploreView(), ProfileView()],
      ),
    );
    final destinations = _buildDestinations(context);
    var bottomNavigationBar = Watch(
      (_) => NavigationBar(
        destinations: destinations,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: viewModel.index.value,
        onDestinationSelected: viewModel.selectDestination,
      ),
    );
    return Scaffold(body: body, bottomNavigationBar: bottomNavigationBar);
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
