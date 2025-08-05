import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/replacement_entity.dart';

class ReplacementService {
  final _table = 'replacements';

  Future<List<ReplacementEntity>> getReplacementsByBookId(int bookId) async {
    var laconic = DatabaseService.instance.laconic;
    var replacements =
        await laconic.table(_table).where('book_id', bookId).get();
    return replacements
        .map((replacement) => ReplacementEntity.fromJson(replacement.toMap()))
        .toList();
  }

  Future<void> addReplacement(ReplacementEntity replacement) async {
    var laconic = DatabaseService.instance.laconic;
    var json = replacement.toJson();
    json.remove('id');
    await laconic.table(_table).insert([json]);
  }
}
