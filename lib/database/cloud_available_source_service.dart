import 'dart:isolate';

import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/cloud_available_source_entity.dart';

class CloudAvailableSourceService {
  Future<List<CloudAvailableSourceEntity>> getSources(String bookUrl) async {
    var laconic = DatabaseService.instance.laconic;
    var rows = await laconic
        .table('cloud_available_sources')
        .where('book_url', bookUrl)
        .get();
    return rows
        .map((row) => CloudAvailableSourceEntity.fromDb(row.toMap()))
        .toList();
  }

  Future<void> replaceSources(
    String bookUrl,
    List<CloudAvailableSourceEntity> sources,
  ) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic
        .table('cloud_available_sources')
        .where('book_url', bookUrl)
        .delete();
    if (sources.isEmpty) return;
    var data = sources.map((source) {
      var json = source.toDb();
      json.remove('id');
      return json;
    }).toList();
    await laconic.table('cloud_available_sources').insert(data);
  }

  Future<void> deleteSources(String bookUrl) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic
        .table('cloud_available_sources')
        .where('book_url', bookUrl)
        .delete();
  }

  Future<void> deleteMultipleSources(List<String> bookUrls) async {
    if (bookUrls.isEmpty) return;
    var dbPath = DatabaseService.instance.dbPath;
    await Isolate.run(() => _deleteSourcesInIsolate(dbPath, bookUrls));
  }
}

Future<void> _deleteSourcesInIsolate(
  String dbPath,
  List<String> bookUrls,
) async {
  var laconic = openLaconic(dbPath);
  await laconic.transaction(() async {
    for (var bookUrl in bookUrls) {
      await laconic
          .table('cloud_available_sources')
          .where('book_url', bookUrl)
          .delete();
    }
  });
}
