import 'package:flutter/material.dart';
import 'package:source_parser/page/reader/reader.dart';
import 'package:source_parser/util/reader_controller.dart';

class ReaderScrollPhysics extends ScrollPhysics {
  final ReaderController controller;
  final List<ReaderViewTurningMode> modes;

  const ReaderScrollPhysics({
    required this.controller,
    required this.modes,
    super.parent,
  });

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // 修改边界处理逻辑
    if (controller.isLastPage && value > position.maxScrollExtent) {
      return value - position.maxScrollExtent;
    }
    if (controller.isFirstPage && value < position.minScrollExtent) {
      return value - position.minScrollExtent;
    }
    return 0.0;
  }

  @override
  ReaderScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ReaderScrollPhysics(
      controller: controller,
      modes: modes,
      parent: buildParent(ancestor),
    );
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    // 1. 首先检查是否允许滑动翻页
    if (!modes.contains(ReaderViewTurningMode.drag)) return false;

    // 2. 计算滑动方向 - 修正计算方式
    final isForward = position.pixels > 0;

    // 3. 在边界处阻止滑动
    if (isForward && controller.isLastPage) return false;
    if (!isForward && controller.isFirstPage) return false;

    return true;
  }
}
