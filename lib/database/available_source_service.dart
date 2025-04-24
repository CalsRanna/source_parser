import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/available_source_entity.dart';

class AvailableSourceService {
  Future<AvailableSourceEntity> getAvailableSource(int id) async {
    var laconic = DatabaseService.instance.laconic;
    var availableSource =
        await laconic.table('available_sources').where('id', id).first();
    return AvailableSourceEntity.fromJson(availableSource.toMap());
  }
}
