import 'package:flutter/material.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_controller.dart';

class NonePageTurnView extends StatefulWidget {
  final PageTurnController controller;
  final Widget Function(int) pageBuilder;
  final void Function(TapUpDetails) onTapUp;

  const NonePageTurnView({
    super.key,
    required this.controller,
    required this.pageBuilder,
    required this.onTapUp,
  });

  @override
  State<NonePageTurnView> createState() => _NonePageTurnViewState();
}

class _NonePageTurnViewState extends State<NonePageTurnView> {
  @override
  void initState() {
    super.initState();
    _bindController();
    widget.controller.addListener(_onControllerChange);
  }

  void _bindController() {
    widget.controller.onAnimateRequest = _handleAnimateRequest;
    widget.controller.onJumpRequest = _handleJumpRequest;
  }

  @override
  void didUpdateWidget(covariant NonePageTurnView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChange);
      _bindController();
      widget.controller.addListener(_onControllerChange);
    }
  }

  @override
  void dispose() {
    widget.controller.onAnimateRequest = null;
    widget.controller.onJumpRequest = null;
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {});
  }

  void _handleAnimateRequest(bool forward) {
    // 无动画模式直接切换
    final targetIndex = forward
        ? widget.controller.currentIndex + 1
        : widget.controller.currentIndex - 1;
    if (targetIndex < 0 || targetIndex >= widget.controller.pageCount) return;
    widget.controller.confirmPageChange(targetIndex);
  }

  void _handleJumpRequest(int index) {
    widget.controller.confirmJump(index);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: widget.onTapUp,
      child: widget.pageBuilder(widget.controller.currentIndex),
    );
  }
}
