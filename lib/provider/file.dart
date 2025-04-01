import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file.g.dart';

@riverpod
class Files extends _$Files {
  @override
  Future<List<FileSystemEntity>> build(String? directory) async {
    if (directory == null) {
      var cacheDirectory = await path_provider.getApplicationCacheDirectory();
      var tmpPath = cacheDirectory.parent.parent.path;
      var tmpDirectory = Directory(tmpPath);
      var files = tmpDirectory.listSync();
      return files.whereType<Directory>().toList();
    } else {
      var a = Directory(directory);
      return a.listSync();
    }
  }
}
