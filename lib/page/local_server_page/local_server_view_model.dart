import 'dart:async';
import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:source_parser/page/local_server_page/controller/source_controller.dart';
import 'package:source_parser/page/local_server_page/controller/static_controller.dart';
import 'package:source_parser/page/local_server_page/helper/decompressor.dart';
import 'package:source_parser/page/local_server_page/middleware/cors_middleware.dart';
import 'package:source_parser/page/local_server_page/middleware/log_middleware.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/message.dart';

class LocalSourceViewModel {
  static const int _port = 8080;
  final _router = Router();
  String site = '';

  LocalSourceViewModel() {
    _setupRoutes();
  }

  Future<HttpServer> serving() async {
    try {
      site = await LocalServerDecompressor().decompress();
    } catch (e) {
      Message.snackBar('解压失败');
    }
    var address = await NetworkInfo().getWifiIP() ?? 'localhost';
    var server = await serve(_handler().call, address, _port);
    logger.d('Serving at http://${server.address.host}:${server.port}');
    return server;
  }

  FutureOr<Response> Function(Request) _handler() {
    final handler = Pipeline()
        .addMiddleware(LocalServerLogMiddleware.instance.middleware)
        .addMiddleware(LocalServerCorsMiddleware.instance.middleware)
        .addHandler(_router.call);
    return handler;
  }

  void _setupRoutes() {
    var sourceController = LocalServerSourceController.instance;
    _router.get('/api/source', sourceController.index);
    _router.get('/api/source/<id>', sourceController.show);
    _router.post('/api/source', sourceController.store);
    _router.put('/api/source/<id>', sourceController.update);
    _router.delete('/api/source/<id>', sourceController.destroy);

    var staticController = LocalServerStaticController.instance;
    var route = '/<ignored|.*>';
    _router.get(route, (request) => staticController.handle(request, site));
    _router.options(route, (request) => Response.ok(''));
  }
}
