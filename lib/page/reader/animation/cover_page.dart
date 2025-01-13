import 'package:flutter/material.dart';

/// 覆盖翻页动画
/// 
/// 实现类似真实书本的翻页效果：
/// - 向左滑动时：当前页向左滑出，露出下方的下一页
/// - 向右滑动时：上一页从左侧滑入，覆盖在当前页上方
class CoverPageAnimation {
  /// 动画控制器
  final AnimationController controller;

  /// 页面切换动画
  Animation<Offset>? _slideAnimation;
  Animation<Offset>? get slideAnimation => _slideAnimation;

  /// 拖动起始位置
  Offset? _dragStartPosition;

  /// 当前拖动距离
  double _dragDistance = 0.0;
  double get dragDistance => _dragDistance;

  /// 是否正在动画中
  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  /// 是否向前翻页（向左滑动）
  bool _isForward = false;
  bool get isForward => _isForward;
  set isForward(bool value) => _isForward = value;

  CoverPageAnimation({required this.controller});

  /// 初始化动画
  void initAnimation() {
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(controller);
    _dragStartPosition = null;
    _dragDistance = 0.0;
    _isAnimating = false;
  }

  /// 处理拖动开始
  void handleDragStart(DragStartDetails details) {
    _dragStartPosition = details.globalPosition;
  }

  /// 处理拖动更新
  void handleDragUpdate(DragUpdateDetails details, double screenWidth, {
    required bool isFirstPage,
    required bool isLastPage,
  }) {
    if (_dragStartPosition == null || _isAnimating) return;

    final delta = details.primaryDelta ?? 0;

    // 检查是否可以继续拖动
    if ((delta > 0 && isFirstPage) || (delta < 0 && isLastPage)) {
      return;
    }

    _dragDistance += delta;
    _isForward = _dragDistance < 0;

    double dragPercent = (_dragDistance / screenWidth).clamp(-1.0, 1.0);
    if (_isForward) {
      // 向左滑：当前页向左移动
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-1.0, 0.0),
      ).animate(AlwaysStoppedAnimation(-dragPercent));
    } else {
      // 向右滑：前一页从左边滑入
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(1.0, 0.0),
      ).animate(AlwaysStoppedAnimation(dragPercent));
    }
  }

  /// 处理拖动结束
  bool handleDragEnd(DragEndDetails details, double screenWidth) {
    if (_dragStartPosition == null) return false;
    _dragStartPosition = null;

    final dragPercentage = _dragDistance.abs() / screenWidth;
    final velocity = details.primaryVelocity ?? 0;

    bool shouldTurnPage = dragPercentage > 0.2 || velocity.abs() > 800;
    return shouldTurnPage;
  }

  /// 执行翻到下一页的动画
  void animateToNext(double screenWidth) {
    final currentOffset = -_dragDistance / screenWidth;
    final remainingDistance = 1.0 - currentOffset;

    _isAnimating = true;
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));

    controller.value = currentOffset;
    controller.duration = Duration(milliseconds: (300 * remainingDistance).toInt());
    controller.forward();
  }

  /// 执行翻到上一页的动画
  void animateToPrevious(double screenWidth) {
    final currentOffset = _dragDistance / screenWidth;
    final remainingDistance = 1.0 - currentOffset;

    _isAnimating = true;
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));

    controller.value = currentOffset;
    controller.duration = Duration(milliseconds: (300 * remainingDistance).toInt());
    controller.forward();
  }

  /// 重置位置
  void resetPosition(double screenWidth) {
    final currentOffset = _dragDistance.abs() / screenWidth;

    _isAnimating = true;
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: _isForward ? Offset(-1.0, 0.0) : Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));

    controller.value = currentOffset;
    final remainingDistance = 1.0 - currentOffset;
    controller.duration = Duration(milliseconds: (300 * remainingDistance).toInt());
    controller.forward();
  }

  /// 动画完成后的清理
  void cleanUp() {
    _isAnimating = false;
    _dragDistance = 0.0;
    controller.reset();
    initAnimation();
  }
}
