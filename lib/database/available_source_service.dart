import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/available_source_entity.dart';

class AvailableSourceService {
  Future<void> addAvailableSource(AvailableSourceEntity availableSource) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('available_sources').insert(availableSource.toJson());
  }

  Future<bool> exist(String url) async {
    var laconic = DatabaseService.instance.laconic;
    var count =
        await laconic.table('available_sources').where('url', url).count();
    return count > 0;
  }

  Future<void> updateAvailableSource(
      AvailableSourceEntity availableSource) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic
        .table('available_sources')
        .where('id', availableSource.id)
        .update(availableSource.toJson());
  }

  Future<AvailableSourceEntity> getAvailableSource(int id) async {
    var laconic = DatabaseService.instance.laconic;
    var availableSource =
        await laconic.table('available_sources').where('id', id).first();
    return AvailableSourceEntity.fromJson(availableSource.toMap());
  }

  Future<List<AvailableSourceEntity>> getAvailableSources(int bookId) async {
    var laconic = DatabaseService.instance.laconic;
    var availableSources =
        await laconic.table('available_sources').where('book_id', bookId).get();
    return availableSources
        .map((availableSource) =>
            AvailableSourceEntity.fromJson(availableSource.toMap()))
        .toList();
  }
}
