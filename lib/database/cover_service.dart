import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/cover_entity.dart';

class CoverService {
  Future<List<CoverEntity>> getCovers(int bookId) async {
    var laconic = DatabaseService.instance.laconic;
    var covers = await laconic.table('covers').where('book_id', bookId).get();
    return covers.map((cover) => CoverEntity.fromJson(cover.toMap())).toList();
  }
}
