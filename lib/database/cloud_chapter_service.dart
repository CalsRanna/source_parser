import 'dart:isolate';

import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/cloud_chapter_entity.dart';

class CloudChapterService {
  Future<List<CloudChapterEntity>> getChapters(String bookUrl) async {
    var laconic = DatabaseService.instance.laconic;
    var rows = await laconic
        .table('cloud_chapters')
        .where('book_url', bookUrl)
        .get();
    var chapters =
        rows.map((row) => CloudChapterEntity.fromDb(row.toMap())).toList();
    chapters.sort((a, b) => a.index.compareTo(b.index));
    return chapters;
  }

  Future<void> replaceChapters(
    String bookUrl,
    List<CloudChapterEntity> chapters,
  ) async {
    var dbPath = DatabaseService.instance.dbPath;
    var data = chapters.map((c) => c.toDb()).toList();
    await Isolate.run(
      () => _replaceChaptersInIsolate(dbPath, {bookUrl: data}),
    );
  }

  Future<void> replaceMultipleChapters(
    Map<String, List<CloudChapterEntity>> chaptersMap,
  ) async {
    if (chaptersMap.isEmpty) return;
    var dbPath = DatabaseService.instance.dbPath;
    var data = chaptersMap.map(
      (k, v) => MapEntry(k, v.map((c) => c.toDb()).toList()),
    );
    await Isolate.run(() => _replaceChaptersInIsolate(dbPath, data));
  }

  Future<void> deleteChapters(String bookUrl) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('cloud_chapters').where('book_url', bookUrl).delete();
  }

  Future<void> deleteMultipleChapters(List<String> bookUrls) async {
    if (bookUrls.isEmpty) return;
    var dbPath = DatabaseService.instance.dbPath;
    await Isolate.run(() => _deleteChaptersInIsolate(dbPath, bookUrls));
  }
}

Future<void> _replaceChaptersInIsolate(
  String dbPath,
  Map<String, List<Map<String, dynamic>>> chaptersMap,
) async {
  var laconic = openLaconic(dbPath);
  await laconic.transaction(() async {
    for (var entry in chaptersMap.entries) {
      await laconic
          .table('cloud_chapters')
          .where('book_url', entry.key)
          .delete();
      if (entry.value.isEmpty) continue;
      await laconic.table('cloud_chapters').insert(entry.value);
    }
  });
}

Future<void> _deleteChaptersInIsolate(
  String dbPath,
  List<String> bookUrls,
) async {
  var laconic = openLaconic(dbPath);
  await laconic.transaction(() async {
    for (var bookUrl in bookUrls) {
      await laconic
          .table('cloud_chapters')
          .where('book_url', bookUrl)
          .delete();
    }
  });
}
