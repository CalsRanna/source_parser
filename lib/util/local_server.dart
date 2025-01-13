import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/logger.dart';

class LocalSourceService {
  static const int _port = 8080;
  final _router = Router();

  // 存储vendor文件的目录路径
  String? _vendorDir;

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

  Middleware _corsMiddleware() {
    var corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Max-Age': '1728000',
    };
    return createMiddleware(
      responseHandler: (Response response) {
        var headers = {...response.headers, ...corsHeaders};
        return response.change(headers: headers);
      },
    );
  }

  Future<Response> _destroy(Request request, String id) async {
    try {
      final success = await isar.writeTxn(() async {
        return await isar.sources.delete(int.parse(id));
      });
      if (!success) {
        return Response.notFound(
          jsonEncode({'error': 'Source not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response(
        204,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to delete source: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  FutureOr<Response> Function(Request) _handler() {
    final handler = Pipeline()
        .addMiddleware(_logMiddleware())
        .addMiddleware(_corsMiddleware())
        .addHandler(_router.call);
    return handler;
  }

  Future<Response> _handleStaticFiles(Request request) async {
    await _prepareVendorFiles();

    if (_vendorDir == null) {
      return Response.internalServerError(
        body: 'Failed to prepare vendor files',
      );
    }

    final staticHandler = createStaticHandler(
      _vendorDir!,
      defaultDocument: 'index.html',
      listDirectories: false,
      useHeaderBytesForContentType: true,
    );

    return staticHandler(request);
  }

  Future<Response> _index(Request request) async {
    try {
      final sources = await isar.sources.where().findAll();
      return Response.ok(
        jsonEncode(sources),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch sources: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Middleware _logMiddleware() {
    return createMiddleware(
      requestHandler: (Request request) {
        var message = 'Request: ${request.method} ${request.url}';
        logger.d(message);
        return null;
      },
    );
  }

  // 准备静态文件目录
  Future<void> _prepareVendorFiles() async {
    if (_vendorDir != null) return;

    // 使用应用文档目录
    final appDir = await getApplicationDocumentsDirectory();
    _vendorDir = join(appDir.path, 'vendor_files');

    // 获取当前应用版本
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    // 检查版本文件
    final versionFile = File(join(_vendorDir!, '.version'));
    bool needsExtract = true;

    if (await versionFile.exists()) {
      final savedVersion = await versionFile.readAsString();
      if (savedVersion == currentVersion) {
        // 版本匹配，检查文件是否存在
        final dir = Directory(_vendorDir!);
        if (await dir.exists()) {
          final files = await dir.list().length;
          if (files > 1) {
            // 大于1是因为还有.version文件
            logger.d(
                'Using existing vendor files (version $currentVersion) in: $_vendorDir');
            return;
          }
        }
      } else {
        logger.d(
            'Version mismatch: saved=$savedVersion, current=$currentVersion');
      }
    }

    // 需要解压文件
    final dir = Directory(_vendorDir!);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await dir.create(recursive: true);

    try {
      // 加载zip文件
      final data = await rootBundle.load('asset/dist.zip');
      final bytes = data.buffer.asUint8List();

      // 解压文件
      final archive = ZipDecoder().decodeBytes(bytes);

      logger.d(
          'Archive entries: ${archive.files.map((f) => '${f.name} (${f.isFile ? "file" : "dir"})').join(", ")}');

      // 解压每个文件
      for (final file in archive) {
        final filename = file.name;

        // 跳过目录项
        if (file.isFile) {
          final targetPath = join(_vendorDir!, filename);
          final targetDir = Directory(dirname(targetPath));

          // 确保目标目录存在
          if (!await targetDir.exists()) {
            await targetDir.create(recursive: true);
            logger.d('Created directory: ${targetDir.path}');
          }

          // 解压文件
          final fileBytes = file.content as List<int>;
          await File(targetPath).writeAsBytes(fileBytes);

          if (filename == 'index.html') {
            // 检查index.html的内容
            final content = String.fromCharCodes(fileBytes);
            logger.d(
                'index.html content (first 200 chars): ${content.substring(0, min(200, content.length))}');
          }

          logger.d(
              'Extracted: $filename (${file.content.length} bytes) to $targetPath');
        }
      }

      // 保存版本号
      await versionFile.writeAsString(currentVersion);
      logger.d('Saved version file: $currentVersion');

      // 验证解压的文件
      final extractedFiles = await Directory(_vendorDir!)
          .list(recursive: true)
          .where((entity) => entity is File)
          .map((entity) => entity.path)
          .toList();
      logger.d('Files in vendor directory: $extractedFiles');

      // 特别检查index.html
      final indexFile = File(join(_vendorDir!, 'index.html'));
      if (await indexFile.exists()) {
        final stat = await indexFile.stat();
        logger.d('index.html size: ${stat.size} bytes');
        if (stat.size > 0) {
          final content = await indexFile.readAsString();
          logger.d(
              'index.html exists and starts with: ${content.substring(0, min(200, content.length))}');
        } else {
          logger.e('index.html exists but is empty!');
        }
      } else {
        logger.e('index.html does not exist in extracted files!');
      }
    } catch (e, stackTrace) {
      logger.e('Failed to extract dist.zip');
      logger.e(e);
      logger.e(stackTrace);
      rethrow;
    }
  }

  void _setupRoutes() {
    // API 路由 - 需要先定义具体路由
    _router.get('/api/source', _index);
    _router.get('/api/source/<id>', _show);
    _router.post('/api/source', _store);
    _router.put('/api/source/<id>', _update);
    _router.delete('/api/source/<id>', _destroy);

    // 静态文件路由 - 放在最后作为默认匹配
    _router.get('/<ignored|.*>', _handleStaticFiles);
  }

  Future<Response> _show(Request request, String id) async {
    try {
      final source = await isar.sources.get(int.parse(id));
      if (source == null) {
        return Response.notFound(
          jsonEncode({'error': 'Source not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode(source),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch source: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> _store(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final source = Source.fromJson(data);
      await isar.writeTxn(() async {
        await isar.sources.put(source);
      });
      return Response(
        201,
        body: jsonEncode(source),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to create source: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> _update(Request request, String id) async {
    try {
      final source = await isar.sources.get(int.parse(id));
      if (source == null) {
        return Response.notFound(
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
      return Response.ok(
        jsonEncode(source),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to update source: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
