import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/message.dart';

@RoutePage()
class SourceServerPage extends StatefulWidget {
  const SourceServerPage({super.key});

  @override
  State<SourceServerPage> createState() => _SourceServerPageState();
}

class _SourceServerPageState extends State<SourceServerPage> {
  bool connected = false;
  bool running = false;
  HttpServer? server;
  @override
  Widget build(BuildContext context) {
    var children = [
      Text('本地服务器${running ? '已' : '未'}开启'),
      if (running)
        Text('请在电脑浏览器中打开 http://${server?.address.host}:${server?.port}'),
      Switch(value: running, onChanged: toggleServer)
    ];
    var column = Column(mainAxisSize: MainAxisSize.min, children: children);
    var scaffold = Scaffold(
      appBar: AppBar(title: const Text('本地服务器')),
      body: Center(child: column),
    );
    return PopScope(
      canPop: !running,
      onPopInvokedWithResult: (_, __) => handlePop(),
      child: scaffold,
    );
  }

  void handlePop() {
    if (!running) return;
    Message.of(context).show('请先关闭本地服务器');
  }

  @override
  void initState() {
    super.initState();
    _initConnection();
  }

  Future<void> toggleServer(bool value) async {
    // if (!connected) return;
    if (value) {
      server = await _SourceService().serve();
    } else {
      server?.close();
      server = null;
    }
    setState(() {
      running = value;
    });
  }

  Future<void> _initConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.wifi)) {
      setState(() {
        connected = true;
      });
    }
  }
}

class _SourceService {
  static const int _port = 8080;
  final _router = shelf_router.Router();

  _SourceService() {
    _setupRoutes();
  }

  Future<HttpServer> serve() async {
    var address = await NetworkInfo().getWifiIP() ?? 'localhost';
    var server = await shelf_io.serve(_handler().call, address, _port);
    logger.d('Listening on http://${server.address.host}:${server.port}');
    return server;
  }

  shelf.Middleware _corsMiddleware() {
    var corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Content-Type': 'application/json; charset=utf-8',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Max-Age': '1728000',
    };
    return shelf.createMiddleware(
      responseHandler: (shelf.Response response) {
        var headers = {...response.headers, ...corsHeaders};
        return response.change(headers: headers);
      },
    );
  }

  Future<shelf.Response> _destroy(shelf.Request request, String id) async {
    try {
      final success = await isar.writeTxn(() async {
        return await isar.sources.delete(int.parse(id));
      });
      if (!success) {
        return shelf.Response.notFound(
          jsonEncode({'error': 'Source not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return shelf.Response(
        204,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Failed to delete source: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  FutureOr<shelf.Response> Function(shelf.Request) _handler() {
    final handler = shelf.Pipeline()
        .addMiddleware(_logMiddleware())
        .addMiddleware(_corsMiddleware())
        .addHandler(_router.call);
    return handler;
  }

  Future<shelf.Response> _handleRoot(shelf.Request request) async {
    return shelf.Response.ok('Source Parser API Server');
  }

  Future<shelf.Response> _index(shelf.Request request) async {
    try {
      final sources = await isar.sources.where().findAll();
      return shelf.Response.ok(
        jsonEncode(sources),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch sources: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  shelf.Middleware _logMiddleware() {
    return shelf.createMiddleware(
      requestHandler: (shelf.Request request) {
        logger.d('Request: ${request.method} ${request.url}');
        return null;
      },
    );
  }

  void _setupRoutes() {
    // 根路由
    _router.get('/', _handleRoot);

    _router.get('/api/source', _index);
    _router.get('/api/source/<id>', _show);
    _router.post('/api/source', _store);
    _router.put('/api/source/<id>', _update);
    _router.delete('/api/source/<id>', _destroy);
  }

  Future<shelf.Response> _show(shelf.Request request, String id) async {
    try {
      final source = await isar.sources.get(int.parse(id));
      if (source == null) {
        return shelf.Response.notFound(
          jsonEncode({'error': 'Source not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return shelf.Response.ok(
        jsonEncode(source),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch source: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<shelf.Response> _store(shelf.Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final source = Source.fromJson(data);
      await isar.writeTxn(() async {
        await isar.sources.put(source);
      });
      return shelf.Response(
        201,
        body: jsonEncode(source),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Failed to create source: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<shelf.Response> _update(shelf.Request request, String id) async {
    try {
      final source = await isar.sources.get(int.parse(id));
      if (source == null) {
        return shelf.Response.notFound(
          jsonEncode({'error': 'Source not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      var newSource = Source.fromJson(data);
      await isar.writeTxn(() async {
        await isar.sources.put(newSource);
      });
      return shelf.Response.ok(
        jsonEncode(source),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Failed to update source: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
