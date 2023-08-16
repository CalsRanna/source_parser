import 'package:isar/isar.dart';

part 'history.g.dart';

@collection
@Name('histories')
class History {
  Id id = Isar.autoIncrement;
  String author = '';
  int chapters = 0;
  String cover = '';
  int cursor = 0;
  int index = 0;
  String introduction = '';
  String name = '';
  @Name('source_id')
  int sourceId = 0;
  String url = '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'chapters': chapters,
      'cover': cover,
      'cursor': cursor,
      'index': index,
      'introduction': introduction,
      'name': name,
      'source_id': sourceId,
      'url': url,
    };
  }
}
