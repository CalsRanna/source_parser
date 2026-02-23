import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

mixin PageTurnGestureMixin {
  double _dragDistance = 0.0;
  bool _isDragging = false;
  bool _isForward = false;

  bool get isDragging => _isDragging;
  bool get isForward => _isForward;

  /// 子类提供屏幕宽度
  double get screenWidth;

  /// 子类提供当前索引
  int get currentIndex;

  /// 子类提供总页数
  int get totalPageCount;

  /// 拖拽进度回调
  void onDragProgress(double progress);

  /// 拖拽确认翻页
  void onDragCommit(bool isForward);

  /// 拖拽取消（回弹）
  void onDragCancel(bool isForward);

  void handleDragStart(DragStartDetails details) {
    debugPrint('[GestureMixin] dragStart');
    _dragDistance = 0.0;
    _isDragging = false;
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    _dragDistance += delta;

    _isForward = _dragDistance < 0;

    // 边界检查
    if (_isForward && currentIndex >= totalPageCount - 1) {
      return;
    }
    if (!_isForward && currentIndex <= 0) {
      return;
    }

    _isDragging = true;
    final progress = (_dragDistance.abs() / screenWidth).clamp(0.0, 1.0);
    onDragProgress(progress);
  }

  void handleDragEnd(DragEndDetails details) {
    debugPrint('[GestureMixin] dragEnd: isDragging=$_isDragging, distance=$_dragDistance');
    if (!_isDragging) return;
    _isDragging = false;

    final dragPercentage = _dragDistance.abs() / screenWidth;
    final velocity = (details.primaryVelocity ?? 0).abs();
    final shouldCommit = dragPercentage > 1 / 3 || velocity > 800;
    debugPrint('[GestureMixin] dragEnd: pct=$dragPercentage, vel=$velocity, commit=$shouldCommit, forward=$_isForward');

    if (shouldCommit) {
      onDragCommit(_isForward);
    } else {
      onDragCancel(_isForward);
    }
  }
}
