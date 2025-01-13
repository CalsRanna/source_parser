import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/util/local_server/local_server.dart';
import 'package:source_parser/util/message.dart';

@RoutePage()
class LocalServerPage extends ConsumerStatefulWidget {
  const LocalServerPage({super.key});

  @override
  ConsumerState<LocalServerPage> createState() => _SourceServerPageState();
}

class _SourceServerPageState extends ConsumerState<LocalServerPage>
    with TickerProviderStateMixin {
  bool connected = false;
  bool running = false;
  int seconds = 0;
  HttpServer? server;
  Timer? timer;

  late Animation<Color?> _colorAnimation;
  late AnimationController _rotationController;
  late Animation<double> _sizeAnimation;
  late AnimationController _styleController;

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      actions: [Switch(value: running, onChanged: toggleServer)],
      title: const Text('本地服务器'),
    );
    var padding = Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(builder: _layoutBuilder),
    );
    var scaffold = Scaffold(appBar: appBar, body: Center(child: padding));
    return PopScope(
      canPop: !running,
      onPopInvokedWithResult: (_, __) => handlePop(),
      child: scaffold,
    );
  }

  @override
  void didChangeDependencies() {
    var colorScheme = Theme.of(context).colorScheme;
    var sizeTween = Tween<double>(begin: 0, end: 32);
    var sizeAnimation = CurvedAnimation(
      curve: Curves.easeOut,
      parent: _styleController,
    );
    _sizeAnimation = sizeTween.animate(sizeAnimation);
    var colorTween = ColorTween(begin: Colors.white, end: colorScheme.primary);
    var colorAnimation = CurvedAnimation(
      curve: Curves.easeOut,
      parent: _styleController,
    );
    _colorAnimation = colorTween.animate(colorAnimation);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _styleController.dispose();
    super.dispose();
  }

  void handlePop() {
    if (!running) return;
    Message.of(context).show('请先关闭本地服务器');
  }

  @override
  void initState() {
    super.initState();
    _listenConnection();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _styleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> startServer() async {
    server = await LocalSource().serving();
    setState(() {});
    if (timer != null) return;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        seconds++;
      });
    });
  }

  Future<void> stopServer() async {
    server?.close();
    server = null;
    setState(() {});
    timer?.cancel();
    timer = null;
    seconds = 0;
    setState(() {});
  }

  Future<void> toggleServer(bool value) async {
    if (!connected) return;
    setState(() {
      running = value;
    });
    if (value) {
      await startServer();
      _styleController.forward();
      _rotationController.repeat();
    } else {
      await stopServer();
      await _styleController.reverse();
      _rotationController.stop();
    }
  }

  Widget _buildAnimatedBuilder(double size) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (_, __) => _rotationBuilder(size),
    );
  }

  Widget _buildServingStatus() {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var textTheme = theme.textTheme;
    var style = textTheme.headlineSmall?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.2),
    );
    var address = Text(
      '${server?.address.address}:${server?.port}',
      style: style,
    );
    var duration = Text(
      Duration(seconds: seconds).toString().split('.').first.padLeft(8, '0'),
      style: style?.copyWith(fontSize: textTheme.titleSmall?.fontSize),
    );
    var available = Text(
      '未连接到WiFi网络',
      style: style,
      textAlign: TextAlign.center,
    );
    var placeholder = Text(
      '打开本地服务器后\n即可通过局域网电脑访问',
      style: style,
      textAlign: TextAlign.center,
    );
    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [address, const SizedBox(height: 8), duration],
    );
    if (!running) child = placeholder;
    if (!connected) child = available;
    return Center(child: child);
  }

  Widget _layoutBuilder(BuildContext context, BoxConstraints constraints) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var boxDecoration = BoxDecoration(
      border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      shape: BoxShape.circle,
    );
    var servingStatus = _buildServingStatus();
    var circle = Container(
      decoration: boxDecoration,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: servingStatus,
    );
    final size = constraints.maxWidth;
    var children = [
      AspectRatio(aspectRatio: 1, child: circle),
      _buildAnimatedBuilder(size),
    ];
    return Stack(children: children);
  }

  Future<void> _listenConnection() async {
    var connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((result) {
      connected = result.contains(ConnectivityResult.wifi);
      setState(() {});
    });
    var result = await connectivity.checkConnectivity();
    connected = result.contains(ConnectivityResult.wifi);
    setState(() {});
  }

  Widget _rotationBuilder(double size) {
    final value = _rotationController.value;
    final angle = value * 2 * pi;
    final radius = (size - 32) / 2;
    final center = size / 2;
    final x = center + radius * cos(angle);
    final y = center + radius * sin(angle);
    return AnimatedBuilder(
      animation: _styleController,
      builder: (_, __) => _styleBuilder(x, y),
    );
  }

  Widget _styleBuilder(double x, double y) {
    var boxDecoration = BoxDecoration(
      color: _colorAnimation.value,
      shape: BoxShape.circle,
    );
    var container = Container(
      decoration: boxDecoration,
      width: _sizeAnimation.value,
      height: _sizeAnimation.value,
    );
    return Positioned(
      left: x - _sizeAnimation.value / 2,
      top: y - _sizeAnimation.value / 2,
      child: container,
    );
  }
}
