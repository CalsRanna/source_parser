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
  final Widget Function(int) pageBuilder;
  final void Function(TapUpDetails) onTapUp;
  final PageTurnMode mode;

  const ShaderPageTurnView({
    super.key,
    required this.shaderAsset,
    required this.controller,
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
    debugPrint('[ShaderPTView] initState, asset=${widget.shaderAsset}');
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
      debugPrint('[ShaderPTView] shader loaded OK');
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('[ShaderPTView] shader load FAILED: $e');
    }
  }

  @override
  void didUpdateWidget(covariant ShaderPageTurnView oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('[ShaderPTView] didUpdateWidget, shaderChanged=${oldWidget.shaderAsset != widget.shaderAsset}, controllerChanged=${oldWidget.controller != widget.controller}');
    if (oldWidget.shaderAsset != widget.shaderAsset) {
      _loadShader();
    }
    if (oldWidget.controller != widget.controller) {
      _bindController();
    }
  }

  @override
  void dispose() {
    debugPrint('[ShaderPTView] dispose');
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
    _startAnimation(forward, targetIndex);
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

    // 先 setState 渲染 target 到 Offstage，下一帧同步捕获并启动动画
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tryCaptureImagesSync();
      if (_currentImage != null && _targetImage != null) {
        _animationController.value = 0.0;
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
    setState(() {
      _progress = _animationController.value;
    });
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final targetIndex = _targetIndex;
      _cleanUpAnimation();
      if (targetIndex != null) {
        widget.controller.confirmPageChange(targetIndex);
      }
      setState(() {});
    } else if (status == AnimationStatus.dismissed) {
      _cleanUpAnimation();
      setState(() {});
    }
  }

  void _cleanUpAnimation() {
    _isAnimating = false;
    _targetIndex = null;
    _progress = 0.0;
    _currentImage?.dispose();
    _targetImage?.dispose();
    _currentImage = null;
    _targetImage = null;
  }

  // --- PageTurnGestureMixin callbacks ---

  @override
  void onDragProgress(double progress) {
    debugPrint('[ShaderPTView] onDragProgress: $progress, isAnimating=$_isAnimating, targetIndex=$_targetIndex');
    if (!_isAnimating && _targetIndex == null) {
      _animatingForward = isForward;
      _targetIndex = isForward ? currentIndex + 1 : currentIndex - 1;
      _isAnimating = true;

      // 先渲染 target 到 Offstage，下一帧再同步截图
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

    // 第二帧起尝试补截（首帧 PostFrameCallback 还没跑的情况）
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
    _animationController.value = _progress;
    _animationController.reverse();
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
      debugPrint('[ShaderPTView] Listener tap at ${event.position}');
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
    final isAnim = _isAnimating && _currentImage != null && _targetImage != null;
    debugPrint('[ShaderPTView] build: isAnimating=$_isAnimating, hasCurrentImg=${_currentImage != null}, hasTargetImg=${_targetImage != null}, hasShader=${_shader != null}, currentIdx=${widget.controller.currentIndex}, pageCount=${widget.controller.pageCount}');
    if (isAnim) {
      return _buildAnimatingView();
    }
    return _buildStaticView();
  }

  Widget _buildStaticView() {
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
        onHorizontalDragStart: handleDragStart,
        onHorizontalDragUpdate: handleDragUpdate,
        onHorizontalDragEnd: handleDragEnd,
        child: Stack(children: children),
      ),
    );
  }

  Widget _buildAnimatingView() {
    // 向后翻页时反转进度，让 shader 动画方向正确
    final effectiveProgress = _animatingForward ? _progress : 1.0 - _progress;

    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: handleDragStart,
        onHorizontalDragUpdate: handleDragUpdate,
        onHorizontalDragEnd: handleDragEnd,
        child: Stack(
          children: [
            // 将两个 RepaintBoundary 放在 CustomPaint 下面，
            // 保持 GlobalKey 有效并确保被绘制
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
                currentImage: _animatingForward ? _currentImage! : _targetImage!,
                nextImage: _animatingForward ? _targetImage! : _currentImage!,
                size: MediaQuery.of(context).size,
                mode: widget.mode,
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

  _ShaderPainter({
    required this.shader,
    required this.progress,
    required this.currentImage,
    required this.nextImage,
    required this.size,
    required this.mode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (shader == null) return;

    final s = shader!;
    int idx = 0;

    // uResolution (vec2)
    s.setFloat(idx++, this.size.width);
    s.setFloat(idx++, this.size.height);

    // uProgress (float)
    s.setFloat(idx++, progress);

    // page_curl.frag 额外参数
    if (mode == PageTurnMode.curl) {
      s.setFloat(idx++, this.size.width * 0.08);
      s.setFloat(idx++, this.size.width * 0.05);
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
        oldDelegate.nextImage != nextImage;
  }
}
