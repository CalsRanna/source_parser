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
}
