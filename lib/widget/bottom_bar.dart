import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/global.dart';

class BottomBar extends ConsumerWidget {
  BottomBar({Key? key}) : super(key: key);

  final routes = ['shelf', 'explore', 'setting'];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(globalState);

    var items = const [
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

    return BottomNavigationBar(
      currentIndex: state.index,
      items: items,
      onTap: (index) => handleTap(context, ref, index),
    );
  }

  void handleTap(BuildContext context, WidgetRef ref, int index) {
    ref.read(globalState.notifier).updateIndex(index);
    context.go('/${routes[index]}');
  }
}
