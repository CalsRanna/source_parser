import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/source_entity.dart';

class BookSourceService {
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
}
