import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

class HomeViewModel {
  final controller = PageController();
  final index = signal(0);

  void changePage(int page) {
    index.value = page;
  }

  void dispose() {
    controller.dispose();
  }

  void selectDestination(int index) {
    controller.jumpToPage(index);
    this.index.value = index;
  }
}
