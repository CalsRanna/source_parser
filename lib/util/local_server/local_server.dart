import 'dart:async';
import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:source_parser/util/local_server/controller/source_controller.dart';
import 'package:source_parser/util/local_server/controller/static_controller.dart';
import 'package:source_parser/util/local_server/middleware/cors_middleware.dart';
import 'package:source_parser/util/local_server/middleware/log_middleware.dart';
import 'package:source_parser/util/logger.dart';

class LocalSourceService {
  static const int _port = 8080;
  final _router = Router();

  LocalSourceService() {
    _setupRoutes();
  }

  Future<HttpServer> serving() async {
    var address = await NetworkInfo().getWifiIP() ?? 'localhost';
    var server = await serve(_handler().call, address, _port);
    var log = 'Serving at http://${server.address.host}:${server.port}';
    logger.d(log);
    return server;
  }

  FutureOr<Response> Function(Request) _handler() {
    final handler = Pipeline()
        .addMiddleware(LogMiddleware.instance.middleware)
        .addMiddleware(CorsMiddleware.instance.middleware)
        .addHandler(_router.call);
    return handler;
  }

  void _setupRoutes() {
    // API 路由 - 需要先定义具体路由
    var sourceController = LocalServerSourceController.instance;
    _router.get('/api/source', sourceController.index);
    _router.get('/api/source/<id>', sourceController.show);
    _router.post('/api/source', sourceController.store);
    _router.put('/api/source/<id>', sourceController.update);
    _router.delete('/api/source/<id>', sourceController.destroy);

    // 静态文件路由 - 放在最后作为默认匹配
    var staticController = LocalServerStaticController.instance;
    _router.get('/<ignored|.*>', staticController.handleStaticFiles);
  }
}
