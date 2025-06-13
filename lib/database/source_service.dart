import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/source_entity.dart';

class SourceService {
  Future<void> destroySource(int id) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('book_sources').where('id', id).delete();
  }

  Future<SourceEntity> getBookSource(int id) async {
    var laconic = DatabaseService.instance.laconic;
    var bookSource =
        await laconic.table('book_sources').where('id', id).first();
    return SourceEntity.fromJson(bookSource.toMap());
  }

  Future<SourceEntity> getBookSourceByName(String name) async {
    var laconic = DatabaseService.instance.laconic;
    var bookSource =
        await laconic.table('book_sources').where('name', name).first();
    return SourceEntity.fromJson(bookSource.toMap());
  }

  Future<List<SourceEntity>> getEnabledBookSources() async {
    var laconic = DatabaseService.instance.laconic;
    var bookSources =
        await laconic.table('book_sources').where('enabled', true).get();
    return bookSources
        .map((bookSource) => SourceEntity.fromJson(bookSource.toMap()))
        .toList();
  }

  Future<List<SourceEntity>> getAllSources() async {
    var laconic = DatabaseService.instance.laconic;
    var sources = await laconic.table('book_sources').get();
    return sources
        .map((source) => SourceEntity.fromJson(source.toMap()))
        .toList();
  }

  Future<void> updateSource(SourceEntity source) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic
        .table('book_sources')
        .where('id', source.id)
        .update(source.toJson());
  }

  Future<SourceEntity> getSourceByNameAndUrl(String name, String url) async {
    var laconic = DatabaseService.instance.laconic;
    var source = await laconic
        .table('book_sources')
        .where('name', name)
        .where('url', url)
        .first();
    return SourceEntity.fromJson(source.toMap());
  }

  Future<void> addSources(List<SourceEntity> sources) async {
    var laconic = DatabaseService.instance.laconic;
    var data = sources.map((source) {
      var json = source.toJson();
      json.remove('id');
      return json;
    }).toList();
    await laconic.table('book_sources').insert(data);
  }
}
