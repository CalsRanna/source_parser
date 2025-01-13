import 'dart:io';
import 'dart:math';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:source_parser/util/local_server/controller/controller.dart';
import 'package:source_parser/util/logger.dart';

class LocalServerStaticController with LocalServerController {
  LocalServerStaticController._();

  static LocalServerStaticController? _instance;

  static LocalServerStaticController get instance =>
      _instance ??= LocalServerStaticController._();

  String? _vendorDir;

  Future<Response> handleStaticFiles(Request request) async {
    await _prepareVendorFiles();
    if (_vendorDir == null) return response(null, statusCode: 500);
    final staticHandler = createStaticHandler(
      _vendorDir!,
      defaultDocument: 'index.html',
      listDirectories: false,
      useHeaderBytesForContentType: true,
    );
    return staticHandler(request);
  }

  Future<void> _prepareVendorFiles() async {
    if (_vendorDir != null) return;
    final appDir = await getApplicationDocumentsDirectory();
    _vendorDir = join(appDir.path, 'vendor_files');
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final versionFile = File(join(_vendorDir!, '.version'));
    if (await versionFile.exists()) {
      final savedVersion = await versionFile.readAsString();
      logger.d('Local server static files version: $savedVersion');
      if (savedVersion == currentVersion) {
        final dir = Directory(_vendorDir!);
        if (await dir.exists()) {
          final files = await dir.list().length;
          if (files > 1) return;
        }
      }
    }
    final dir = Directory(_vendorDir!);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await dir.create(recursive: true);
    try {
      final data = await rootBundle.load('asset/dist.zip');
      final bytes = data.buffer.asUint8List();
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final targetPath = join(_vendorDir!, filename);
          final targetDir = Directory(dirname(targetPath));
          if (!await targetDir.exists()) {
            await targetDir.create(recursive: true);
          }
          final fileBytes = file.content as List<int>;
          await File(targetPath).writeAsBytes(fileBytes);
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
}
