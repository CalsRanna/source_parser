import 'package:flutter/foundation.dart';

class PageTurnController extends ChangeNotifier {
  int _currentIndex;
  int _pageCount;

  PageTurnController({int initialIndex = 0, int pageCount = 0})
      : _currentIndex = initialIndex,
        _pageCount = pageCount;

  int get currentIndex => _currentIndex;
  int get pageCount => _pageCount;

  /// 页面变更回调，View 层设置，通知 ViewModel 执行章节轮转等逻辑
  void Function(int flatIndex)? onPageChanged;

  /// View 层注册的动画执行器，Controller 调用 animate* 时委托给 View 执行
  void Function(bool forward)? onAnimateRequest;

  /// View 层注册的跳转执行器
  void Function(int index)? onJumpRequest;

  /// 更新总页数（章节轮转后 ViewModel 调用）
  void updatePageCount(int count) {
    _pageCount = count;
    notifyListeners();
  }

  /// 无动画跳转到指定页（章节轮转后 ViewModel 调用）
  void jumpToPage(int index) {
    if (onJumpRequest != null) {
      onJumpRequest!(index);
    } else {
      _currentIndex = index.clamp(0, _pageCount > 0 ? _pageCount - 1 : 0);
      notifyListeners();
    }
  }

  /// 带动画翻到下一页（ViewModel 的 nextPage() 调用）
  void animateToNext() {
    if (onAnimateRequest != null) {
      onAnimateRequest!(true);
    } else {
      // 无 View 绑定时直接跳转
      if (_currentIndex + 1 < _pageCount) {
        _currentIndex++;
        notifyListeners();
        onPageChanged?.call(_currentIndex);
      }
    }
  }

  /// 带动画翻到上一页（ViewModel 的 previousPage() 调用）
  void animateToPrevious() {
    if (onAnimateRequest != null) {
      onAnimateRequest!(false);
    } else {
      if (_currentIndex > 0) {
        _currentIndex--;
        notifyListeners();
        onPageChanged?.call(_currentIndex);
      }
    }
  }

  /// View 层在动画/拖拽完成后调用，更新当前索引并通知 ViewModel
  void confirmPageChange(int newIndex) {
    _currentIndex = newIndex.clamp(0, _pageCount > 0 ? _pageCount - 1 : 0);
    notifyListeners();
    onPageChanged?.call(_currentIndex);
  }

  /// View 层在无动画跳转完成后调用
  void confirmJump(int newIndex) {
    _currentIndex = newIndex.clamp(0, _pageCount > 0 ? _pageCount - 1 : 0);
    notifyListeners();
  }
}
