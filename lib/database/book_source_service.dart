import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/book_source_entity.dart';

class BookSourceService {
  Future<BookSourceEntity> getBookSource(int id) async {
    var laconic = DatabaseService.instance.laconic;
    var bookSource =
        await laconic.table('book_sources').where('id', id).first();
    return BookSourceEntity.fromJson(bookSource.toMap());
  }

  Future<BookSourceEntity> getBookSourceByName(String name) async {
    var laconic = DatabaseService.instance.laconic;
    var bookSource =
        await laconic.table('book_sources').where('name', name).first();
    return BookSourceEntity.fromJson(bookSource.toMap());
  }

  Future<List<BookSourceEntity>> getEnabledBookSources() async {
    var laconic = DatabaseService.instance.laconic;
    var bookSources =
        await laconic.table('book_sources').where('enabled', true).get();
    return bookSources
        .map((bookSource) => BookSourceEntity.fromJson(bookSource.toMap()))
        .toList();
  }
}
