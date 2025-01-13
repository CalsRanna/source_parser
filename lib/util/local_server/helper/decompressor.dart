import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/util/logger.dart';

class LocalServerDecompressor {
  String site = '';

  Future<String> decompress() async {
    await _initSiteDirectory();
    if (!await _shouldDecompress()) return site;
    await _cleanAndCreateSite();
    await _decompressDistZip();
    return site;
  }

  Future<void> _cleanAndCreateSite() async {
    final directory = Directory(site);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
    await directory.create(recursive: true);
  }

  Future<void> _decompressDistZip() async {
    final data = await rootBundle.load('asset/dist.zip');
    final bytes = data.buffer.asUint8List();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      if (!file.isFile) continue;
      final path = join(site, file.name);
      final target = Directory(dirname(path));
      if (!await target.exists()) await target.create(recursive: true);
      final fileBytes = file.content as List<int>;
      await File(path).writeAsBytes(fileBytes);
      logger.d('Decompress ${file.name} (${file.content.length} bytes)');
    }
  }

  Future<void> _initSiteDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    site = join(directory.path, 'site');
  }

  Future<bool> _shouldDecompress() async {
    final dir = Directory(site);
    if (!await dir.exists()) return true;
    return await dir.list().isEmpty;
  }
}
