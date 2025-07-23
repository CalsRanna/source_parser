import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/page/local_server_page/local_server_view_model.dart';
import 'package:source_parser/util/dialog_util.dart';

@RoutePage()
class LocalServerPage extends ConsumerStatefulWidget {
  const LocalServerPage({super.key});

  @override
  ConsumerState<LocalServerPage> createState() => _SourceServerPageState();
}

class _SourceServerPageState extends ConsumerState<LocalServerPage> {
  bool connected = false;
  bool running = false;
  HttpServer? server;

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      actions: [Switch(value: running, onChanged: toggleServer)],
      title: const Text('本地服务器'),
    );
    var padding = Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildServingStatus(),
    );
    var scaffold = Scaffold(appBar: appBar, body: Center(child: padding));
    return PopScope(
      canPop: !running,
      onPopInvokedWithResult: (_, __) => handlePop(),
      child: scaffold,
    );
  }

  void handlePop() {
    if (!running) return;
    DialogUtil.snackBar('请先关闭本地服务器');
  }

  @override
  void initState() {
    super.initState();
    _listenConnection();
  }

  Future<void> startServer() async {
    server = await LocalSourceViewModel().serving();
    setState(() {});
  }

  Future<void> stopServer() async {
    server?.close();
    server = null;
    setState(() {});
  }

  Future<void> toggleServer(bool value) async {
    if (!connected) return;
    setState(() {
      running = value;
    });
    if (value) {
      await startServer();
    } else {
      await stopServer();
    }
  }

  Widget _buildServingStatus() {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var textTheme = theme.textTheme;
    var style = textTheme.headlineSmall?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.2),
    );
    var address = Text(
      'Serving at http://${server?.address.host}:${server?.port}',
      style: style,
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
    Widget child = address;
    if (!running) child = placeholder;
    if (!connected) child = available;
    return Center(child: child);
  }

  Future<void> _listenConnection() async {
    var connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((result) {
      connected = result.contains(ConnectivityResult.wifi);
      connected |= result.contains(ConnectivityResult.ethernet);
      setState(() {});
    });
    var result = await connectivity.checkConnectivity();
    connected = result.contains(ConnectivityResult.wifi);
    connected |= result.contains(ConnectivityResult.ethernet);
    setState(() {});
  }
}
