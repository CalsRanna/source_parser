import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CacheManager {
  Future<String?> get(
    String url, {
    Directory? cacheFolder,
    bool permanent = true,
  }) async {
    var folder = cacheFolder ??= await getTemporaryDirectory();
    var uuid = const Uuid();
    var name = uuid.v5(Uuid.NAMESPACE_URL, url);
    if (!permanent) {
      final now = DateTime.now();
      final suffix = '${now.year}/${now.month}/${now.day}';
      name = uuid.v5(Uuid.NAMESPACE_URL, '$url@$suffix');
    }
    final file = File(path.join(folder.path, name));
    if (file.existsSync()) {
      return file.readAsStringSync();
    } else {
      return null;
    }
  }

  Future<void> set(
    String url,
    String content, {
    Directory? cacheFolder,
    Duration duration = const Duration(days: 1),
  }) async {
    var folder = cacheFolder ??= await getTemporaryDirectory();
    var uuid = const Uuid();
    var name = uuid.v5(Uuid.NAMESPACE_URL, url);
    if (duration.inDays == 1) {
      final now = DateTime.now();
      final suffix = '${now.year}/${now.month}/${now.day}';
      name = uuid.v5(Uuid.NAMESPACE_URL, '$url@$suffix');
    }
    final file = File(path.join(folder.path, name));
    await file.writeAsString(content);
  }
}

enum CacheDuration { day, week, month, year, permanent }
