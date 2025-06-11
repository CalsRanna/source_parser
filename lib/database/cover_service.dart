import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/cover_entity.dart';

class CoverService {
  Future<void> addCover(CoverEntity cover) async {
    var laconic = DatabaseService.instance.laconic;
    var json = cover.toJson();
    json.remove('id');
    await laconic.table('covers').insert([json]);
  }

  Future<void> addCovers(List<CoverEntity> covers) async {
    var laconic = DatabaseService.instance.laconic;
    var coverData = covers.map((cover) {
      var json = cover.toJson();
      json.remove('id');
      return json;
    }).toList();
    await laconic.table('covers').insert(coverData);
  }

  Future<bool> exist(String url) async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic.table('covers').where('url', url).count();
    return count > 0;
  }

  Future<List<CoverEntity>> getCovers(int bookId) async {
    var laconic = DatabaseService.instance.laconic;
    var covers = await laconic.table('covers').where('book_id', bookId).get();
    return covers.map((cover) => CoverEntity.fromJson(cover.toMap())).toList();
  }

  Future<void> updateCover(CoverEntity cover) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('covers').where('id', cover.id).update(cover.toJson());
  }
}
