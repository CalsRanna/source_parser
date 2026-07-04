import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_controller.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_gesture_mixin.dart';
import 'package:source_parser/component/reader/reader_turning_mode.dart';

class ShaderPageTurnView extends StatefulWidget {
  final String shaderAsset;
  final PageTurnController controller;
  final bool gesturesEnabled;
  final VoidCallback onLongPress;
  final Widget Function(int) pageBuilder;
  final void Function(TapUpDetails) onTapUp;
  final PageTurnMode mode;

  const ShaderPageTurnView({
    super.key,
    required this.shaderAsset,
    required this.controller,
    required this.gesturesEnabled,
    required this.onLongPress,
    required this.pageBuilder,
    required this.onTapUp,
    required this.mode,
  });

  @override
  State<ShaderPageTurnView> createState() => _ShaderPageTurnViewState();
}

class _ShaderPageTurnViewState extends State<ShaderPageTurnView>
    with SingleTickerProviderStateMixin, PageTurnGestureMixin {
  late AnimationController _animationController;
  ui.FragmentShader? _shader;

  final _currentPageKey = GlobalKey();
  final _targetPageKey = GlobalKey();

  ui.Image? _currentImage;
  ui.Image? _targetImage;

  bool _isAnimating = false;
  bool _animatingForward = true;
  int? _targetIndex;
  double _progress = 0.0;

  // Curl mode: finger-following positions
  Offset? _curlTouchDown;
  Offset? _curlDragPos;
  Offset? _curlAnimStart;
  Offset? _curlAnimEnd;

  // 用于通过 Listener 检测点击（绕过手势竞争）
  Offset? _pointerDownPosition;
  double _maxPointerDisplacement = 0;

  @override
  double get screenWidth => MediaQuery.of(context).size.width;

  @override
  int get currentIndex => widget.controller.currentIndex;

  @override
  int get totalPageCount => widget.controller.pageCount;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.addListener(_onAnimationTick);
    _animationController.addStatusListener(_onAnimationStatus);
    _loadShader();
    _bindController();
  }

  void _bindController() {
    widget.controller.onAnimateRequest = _handleAnimateRequest;
    widget.controller.onJumpRequest = _handleJumpRequest;
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(widget.shaderAsset);
      _shader = program.fragmentShader();
      if (mounted) setState(() {});
    } catch (_) {}
  }

  @override
  void didUpdateWidget(covariant ShaderPageTurnView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shaderAsset != widget.shaderAsset) {
      _loadShader();
    }
    if (oldWidget.controller != widget.controller) {
      _bindController();
    }
    if (oldWidget.gesturesEnabled && !widget.gesturesEnabled && _isAnimating) {
      _animationController.stop();
      _cleanUpAnimation();
    }
  }

  @override
  void dispose() {
    widget.controller.onAnimateRequest = null;
    widget.controller.onJumpRequest = null;
    _animationController.dispose();
    _currentImage?.dispose();
    _targetImage?.dispose();
    _shader?.dispose();
    super.dispose();
  }

  // --- Controller callbacks ---

  void _handleAnimateRequest(bool forward) {
    if (_isAnimating) return;
    final targetIndex = forward ? currentIndex + 1 : currentIndex - 1;
    if (targetIndex < 0 || targetIndex >= widget.controller.pageCount) return;
    if (widget.mode == PageTurnMode.curl) {
      _startCurlAnimation(forward, targetIndex);
    } else {
      _startAnimation(forward, targetIndex);
    }
  }

  void _startCurlAnimation(bool forward, int targetIndex) {
    _animatingForward = forward;
    _targetIndex = targetIndex;
    _isAnimating = true;

    final size = MediaQuery.of(context).size;
    if (forward) {
      _curlTouchDown = Offset(size.width, size.height * 0.8);
      _curlDragPos = Offset(size.width, size.height * 0.8);
      _curlAnimStart = _curlDragPos;
      _curlAnimEnd = Offset(-size.width * 0.3, size.height * 0.5);
    } else {
      _curlTouchDown = Offset(0, size.height * 0.8);
      _curlDragPos = Offset(0, size.height * 0.8);
      _curlAnimStart = _curlDragPos;
      _curlAnimEnd = Offset(size.width * 1.3, size.height * 0.5);
    }

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tryCaptureImagesSync();
      if (_currentImage != null && _targetImage != null) {
        _animationController.removeStatusListener(_onAnimationStatus);
        _animationController.value = 0.0;
        _animationController.addStatusListener(_onAnimationStatus);
        _animationController.forward();
        setState(() {});
      } else {
        final target = _targetIndex;
        _cleanUpAnimation();
        if (target != null) {
          widget.controller.confirmPageChange(target);
        }
        setState(() {});
      }
    });
  }

  void _handleJumpRequest(int index) {
    if (_isAnimating) {
      _animationController.stop();
      _cleanUpAnimation();
    }
    widget.controller.confirmJump(index);
    setState(() {});
  }

  void _startAnimation(bool forward, int targetIndex) {
    _animatingForward = forward;
    _targetIndex = targetIndex;
    _isAnimating = true;
    _progress = 0.0;

    // 先 setState 渲染 target，下一帧同步捕获并启动动画
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tryCaptureImagesSync();
      if (_currentImage != null && _targetImage != null) {
        // 临时移除 status listener：直接设置 value=0.0 会使 status
        // 从 completed 变为 dismissed，误触 _onAnimationStatus(dismissed)
        // 导致 _cleanUpAnimation() 清理掉刚刚捕获的图片。
        _animationController.removeStatusListener(_onAnimationStatus);
        _animationController.value = 0.0;
        _animationController.addStatusListener(_onAnimationStatus);
        _animationController.forward();
        setState(() {});
      } else {
        // shader 或截图不可用，直接跳转
        final target = _targetIndex;
        _cleanUpAnimation();
        if (target != null) {
          widget.controller.confirmPageChange(target);
        }
        setState(() {});
      }
    });
  }

  // --- 同步截图 ---

  void _tryCaptureImagesSync() {
    _currentImage?.dispose();
    _targetImage?.dispose();
    _currentImage = _captureBoundarySync(_currentPageKey);
    _targetImage = _captureBoundarySync(_targetPageKey);
  }

  ui.Image? _captureBoundarySync(GlobalKey key) {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null || !boundary.hasSize) return null;
    try {
      final ratio = MediaQuery.of(context).devicePixelRatio;
      return boundary.toImageSync(pixelRatio: ratio);
    } catch (_) {
      return null;
    }
  }

  // --- Animation callbacks ---

  void _onAnimationTick() {
    if (widget.mode == PageTurnMode.curl && _curlAnimStart != null && _curlAnimEnd != null) {
      final t = _animationController.value;
      setState(() {
        _curlDragPos = Offset.lerp(_curlAnimStart, _curlAnimEnd, t);
        _progress = t;
      });
    } else {
      setState(() {
        _progress = _animationController.value;
      });
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final targetIndex = _targetIndex;
      if (targetIndex != null) {
        widget.controller.confirmPageChange(targetIndex);
      }
      // 延迟清理：章节切换时 rotateTo*Chapter 会在 PostFrameCallback 中
      // 调用 jumpToPage，如果在此处立即清理动画状态并 setState，会在
      // jumpToPage 之前显示一帧中间状态（错误的 currentIndex），导致闪烁。
      // 推迟到下一帧清理，让 jumpToPage 先执行。在此期间 shader 继续
      // 显示动画最后一帧（progress=1.0），视觉上无影响。
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _cleanUpAnimation();
        setState(() {});
      });
    } else if (status == AnimationStatus.dismissed) {
      _cleanUpAnimation();
      setState(() {});
    }
  }

  void _cleanUpAnimation() {
    _isAnimating = false;
    _targetIndex = null;
    _progress = 0.0;
    _curlTouchDown = null;
    _curlDragPos = null;
    _curlAnimStart = null;
    _curlAnimEnd = null;
    _currentImage?.dispose();
    _targetImage?.dispose();
    _currentImage = null;
    _targetImage = null;
  }

  // --- PageTurnGestureMixin callbacks ---

  @override
  void onDragProgress(double progress) {
    if (widget.mode == PageTurnMode.curl) {
      // Curl mode: use actual finger positions for natural following
      if (!_isAnimating && _targetIndex == null) {
        _animatingForward = isForward;
        _targetIndex = isForward ? currentIndex + 1 : currentIndex - 1;
        _isAnimating = true;
        _curlTouchDown = touchDownPosition ?? dragPosition;
        _curlDragPos = dragPosition;
        _curlAnimStart = null;
        _curlAnimEnd = null;
        _progress = progress;
        setState(() {});

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _tryCaptureImagesSync();
          setState(() {});
        });
        return;
      }

      // Update finger position each frame during drag
      _curlDragPos = dragPosition ?? _curlDragPos;
      _progress = progress;

      if (_currentImage == null || _targetImage == null) {
        _tryCaptureImagesSync();
      }

      setState(() {});
      return;
    }

    // Non-curl modes: progress-based
    if (!_isAnimating && _targetIndex == null) {
      _animatingForward = isForward;
      _targetIndex = isForward ? currentIndex + 1 : currentIndex - 1;
      _isAnimating = true;

      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _tryCaptureImagesSync();
        setState(() {
          _progress = progress;
        });
      });
      return;
    }

    if (_currentImage == null || _targetImage == null) {
      _tryCaptureImagesSync();
    }

    setState(() {
      _progress = progress;
    });
  }

  @override
  void onDragCommit(bool isForward) {
    if (_currentImage == null || _targetImage == null) {
      final targetIndex = _targetIndex;
      _cleanUpAnimation();
      if (targetIndex != null) {
        widget.controller.confirmPageChange(targetIndex);
      }
      setState(() {});
      return;
    }
    if (widget.mode == PageTurnMode.curl) {
      _startCurlAnimFromDrag(commit: true);
      return;
    }
    _animationController.value = _progress;
    _animationController.forward();
  }

  @override
  void onDragCancel(bool isForward) {
    if (_currentImage == null || _targetImage == null) {
      _cleanUpAnimation();
      setState(() {});
      return;
    }
    if (widget.mode == PageTurnMode.curl) {
      _startCurlAnimFromDrag(commit: false);
      return;
    }
    _animationController.value = _progress;
    _animationController.reverse();
  }

  void _startCurlAnimFromDrag({required bool commit}) {
    final size = MediaQuery.of(context).size;
    _curlAnimStart = _curlDragPos ?? _curlTouchDown;
    if (commit) {
      // Animate finger off-screen in the drag direction
      if (isForward) {
        _curlAnimEnd = Offset(-size.width * 0.3, _curlAnimStart!.dy);
      } else {
        _curlAnimEnd = Offset(size.width * 1.3, _curlAnimStart!.dy);
      }
    } else {
      // Snap back to touch-down position
      _curlAnimEnd = _curlTouchDown ?? _curlAnimStart;
    }
    _animationController.value = _progress;
    _animationController.forward();
  }

  // --- Pointer-based tap detection ---

  void _handlePointerDown(PointerDownEvent event) {
    _pointerDownPosition = event.position;
    _maxPointerDisplacement = 0;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_pointerDownPosition != null) {
      _maxPointerDisplacement = max(
        _maxPointerDisplacement,
        (event.position - _pointerDownPosition!).distance,
      );
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_pointerDownPosition != null && _maxPointerDisplacement < kTouchSlop) {
      widget.onTapUp(TapUpDetails(
        globalPosition: event.position,
        localPosition: event.localPosition,
        kind: PointerDeviceKind.touch,
      ));
    }
    _pointerDownPosition = null;
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    final isAnim =
        _isAnimating && _currentImage != null && _targetImage != null;
    if (isAnim) {
      return _buildAnimatingView();
    }
    return _buildStaticView();
  }

  Widget _buildStaticView() {
    if (!widget.gesturesEnabled) {
      return widget.pageBuilder(widget.controller.currentIndex);
    }
    Widget current = RepaintBoundary(
      key: _currentPageKey,
      child: widget.pageBuilder(widget.controller.currentIndex),
    );

    List<Widget> children = [];
    // 将 target 放在 current 下面，被 current 视觉遮盖，但仍会被绘制，
    // 这样 RepaintBoundary.toImageSync() 才能正常捕获
    if (_isAnimating && _targetIndex != null) {
      children.add(
        RepaintBoundary(
          key: _targetPageKey,
          child: widget.pageBuilder(_targetIndex!),
        ),
      );
    }
    children.add(current);

    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: widget.onLongPress,
        onHorizontalDragStart: handleDragStart,
        onHorizontalDragUpdate: handleDragUpdate,
        onHorizontalDragEnd: handleDragEnd,
        child: Stack(children: children),
      ),
    );
  }

  Widget _buildAnimatingView() {
    if (!widget.gesturesEnabled) {
      return widget.pageBuilder(widget.controller.currentIndex);
    }
    // 向后翻页时反转进度，让 shader 动画方向正确
    final effectiveProgress = _animatingForward ? _progress : 1.0 - _progress;

    final isCurl = widget.mode == PageTurnMode.curl;

    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: widget.onLongPress,
        onHorizontalDragStart: handleDragStart,
        onHorizontalDragUpdate: handleDragUpdate,
        onHorizontalDragEnd: handleDragEnd,
        child: Stack(
          children: [
            RepaintBoundary(
              key: _targetPageKey,
              child: widget.pageBuilder(_targetIndex!),
            ),
            RepaintBoundary(
              key: _currentPageKey,
              child: widget.pageBuilder(widget.controller.currentIndex),
            ),
            CustomPaint(
              painter: _ShaderPainter(
                shader: _shader,
                progress: effectiveProgress,
                currentImage:
                    _animatingForward ? _currentImage! : _targetImage!,
                nextImage:
                    _animatingForward ? _targetImage! : _currentImage!,
                size: MediaQuery.of(context).size,
                mode: widget.mode,
                mousePosition: isCurl ? _curlDragPos : null,
                touchDownPosition: isCurl ? _curlTouchDown : null,
              ),
              size: MediaQuery.of(context).size,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShaderPainter extends CustomPainter {
  final ui.FragmentShader? shader;
  final double progress;
  final ui.Image currentImage;
  final ui.Image nextImage;
  final Size size;
  final PageTurnMode mode;

  /// Curl mode: current finger position (if null, falls back to progress-based).
  final Offset? mousePosition;

  /// Curl mode: where the finger first touched down (for corner detection).
  final Offset? touchDownPosition;

  _ShaderPainter({
    required this.shader,
    required this.progress,
    required this.currentImage,
    required this.nextImage,
    required this.size,
    required this.mode,
    this.mousePosition,
    this.touchDownPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (shader == null) return;

    final s = shader!;
    int idx = 0;

    // uResolution (vec2) — always first
    s.setFloat(idx++, this.size.width);
    s.setFloat(idx++, this.size.height);

    if (mode == PageTurnMode.curl && mousePosition != null && touchDownPosition != null) {
      // Curl mode: pass finger positions as iMouse (vec4)
      // Clamp to page bounds like leaf does
      final mx = mousePosition!.dx.clamp(0.0, this.size.width);
      final my = mousePosition!.dy.clamp(0.0, this.size.height);
      final tdx = touchDownPosition!.dx.clamp(0.0, this.size.width);
      final tdy = touchDownPosition!.dy.clamp(0.0, this.size.height);
      s.setFloat(idx++, mx);
      s.setFloat(idx++, my);
      s.setFloat(idx++, tdx);
      s.setFloat(idx++, tdy);
    } else {
      // Non-curl modes: pass progress (float)
      s.setFloat(idx++, progress);

      // Legacy curl extra params (unused by new shader, kept for compatibility)
      if (mode == PageTurnMode.curl) {
        s.setFloat(idx++, this.size.width * 0.08);
        s.setFloat(idx++, this.size.width * 0.05);
      }
    }

    s.setImageSampler(0, currentImage);
    s.setImageSampler(1, nextImage);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, this.size.width, this.size.height),
      Paint()..shader = s,
    );
  }

  @override
  bool shouldRepaint(covariant _ShaderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.currentImage != currentImage ||
        oldDelegate.nextImage != nextImage ||
        oldDelegate.mousePosition != mousePosition ||
        oldDelegate.touchDownPosition != touchDownPosition;
  }
}
