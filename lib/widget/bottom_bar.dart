import 'package:creator/creator.dart';
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
    const items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_book_outlined),
        label: '书架',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.explore_outlined),
        label: '发现',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: '我的',
      ),
    ];

    return Watcher(
      (context, ref, _) => BottomNavigationBar(
        currentIndex: ref.watch(currentIndexCreator),
        items: items,
        onTap: (index) => handleTap(context, index),
      ),
    );
  }

  void handleTap(BuildContext context, int index) {
    context.ref.set(currentIndexCreator, index);
    context.go('/${routes[index]}');
  }
}
