import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:source_parser/state/global.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  final routes = ['shelf', 'explore', 'setting'];

  @override
  Widget build(BuildContext context) {
    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.menu_book_outlined),
        label: '书架',
      ),
      NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        label: '发现',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        label: '我的',
      ),
    ];

    return CreatorWatcher<int>(
      builder: (context, index) => NavigationBar(
        destinations: destinations,
        height: 56,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: index,
        onDestinationSelected: (value) => handleTap(context, value),
      ),
      creator: currentIndexCreator,
    );
  }

  void handleTap(BuildContext context, int index) {
    context.ref.set(currentIndexCreator, index);
    context.go('/${routes[index]}');
  }
}
