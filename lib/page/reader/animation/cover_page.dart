import 'package:flutter/material.dart';

class CoverPageAnimation {
  final AnimationController controller;
  bool isForward = false;

  Animation<Offset>? _slideAnimation;
  double _dragDistance = 0.0;

  bool _isAnimating = false;
  Offset? _dragStartPosition;

  CoverPageAnimation({required this.controller});

  double get dragDistance => _dragDistance;
  bool get isAnimating => _isAnimating;

  Animation<Offset>? get slideAnimation => _slideAnimation;

  void cleanUp() {
    _isAnimating = false;
    _dragDistance = 0.0;
    controller.reset();
    initAnimation();
  }

  void forward(double screenWidth) {
    _isAnimating = true;
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    final currentOffset = -_dragDistance / screenWidth;
    final remainingDistance = 1.0 - currentOffset;
    var milliseconds = (300 * remainingDistance).toInt();
    controller.duration = Duration(milliseconds: milliseconds);
    controller.value = currentOffset;
  }

  bool handleDragEnd(DragEndDetails details, double screenWidth) {
    if (_dragStartPosition == null) return false;
    _dragStartPosition = null;
    final dragPercentage = _dragDistance.abs() / screenWidth;
    final velocity = details.primaryVelocity ?? 0;
    bool shouldTurnPage = dragPercentage > 1 / 3 || velocity.abs() > 800;
    return shouldTurnPage;
  }

  void handleDragStart(DragStartDetails details) {
    _dragStartPosition = details.globalPosition;
  }

  void handleDragUpdate(
    DragUpdateDetails details,
    double screenWidth, {
    required bool isFirstPage,
    required bool isLastPage,
  }) {
    if (_dragStartPosition == null || _isAnimating) return;
    final delta = details.primaryDelta ?? 0;
    if ((delta > 0 && isFirstPage) || (delta < 0 && isLastPage)) {
      return;
    }
    _dragDistance += delta;
    isForward = _dragDistance < 0;
    double dragPercent = (_dragDistance / screenWidth).clamp(-1.0, 1.0);
    if (isForward) {
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-1.0, 0.0),
      ).animate(AlwaysStoppedAnimation(-dragPercent));
    } else {
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(1.0, 0.0),
      ).animate(AlwaysStoppedAnimation(dragPercent));
    }
  }

  void initAnimation() {
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(controller);
    _dragStartPosition = null;
    _dragDistance = 0.0;
    _isAnimating = false;
  }

  void reset(double screenWidth) {
    _isAnimating = true;
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: isForward ? Offset(-1.0, 0.0) : Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    final currentOffset = _dragDistance.abs() / screenWidth;
    final remainingDistance = 1.0 - currentOffset;
    var milliseconds = (300 * remainingDistance).toInt();
    controller.duration = Duration(milliseconds: milliseconds);
    controller.value = currentOffset;
  }

  void reverse(double screenWidth) {
    _isAnimating = true;
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    final currentOffset = _dragDistance / screenWidth;
    final remainingDistance = 1.0 - currentOffset;
    var milliseconds = (300 * remainingDistance).toInt();
    controller.duration = Duration(milliseconds: milliseconds);
    controller.value = currentOffset;
  }
}
