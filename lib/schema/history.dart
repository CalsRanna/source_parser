import 'package:isar/isar.dart';

part 'history.g.dart';

@collection
@Name('histories')
class History {
  Id id = Isar.autoIncrement;
  String author = '';
  String catalogueUrl = '';
  String category = '';
  int chapters = 0;
  String cover = '';
  int cursor = 0;
  int index = 0;
  String introduction = '';
  @Name('latest_chapter')
  String latestChapter = '';
  String name = '';
  @Name('source_id')
  int sourceId = 0;
  @Name('sources')
  List<int> sources = [];
  String status = '';
  @Name('updated_at')
  String updatedAt = '';
  String url = '';
  String words = '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'catalogueUrl': catalogueUrl,
      'category': category,
      'chapters': chapters,
      'cover': cover,
      'cursor': cursor,
      'index': index,
      'introduction': introduction,
      'latest_chapter': latestChapter,
      'name': name,
      'source_id': sourceId,
      'sources': sources,
      'status': status,
      'updated_at': updatedAt,
      'url': url,
      'words': words,
    };
  }
}
