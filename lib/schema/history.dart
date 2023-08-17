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

  History();

  factory History.fromJson(Map<String, dynamic> json) {
    return History()
      ..id = json['id'] as Id
      ..author = json['author'] as String
      ..catalogueUrl = json['catalogueUrl'] as String
      ..category = json['category'] as String
      ..chapters = json['chapters'] as int
      ..cover = json['cover'] as String
      ..cursor = json['cursor'] as int
      ..index = json['index'] as int
      ..introduction = json['introduction'] as String
      ..latestChapter = json['latest_chapter'] as String
      ..name = json['name'] as String
      ..sourceId = json['source_id'] as int
      ..sources =
          (json['sources'] as List<dynamic>).map((e) => e as int).toList()
      ..status = json['status'] as String
      ..updatedAt = json['updated_at'] as String
      ..url = json['url'] as String
      ..words = json['words'] as String;
  }

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

  @override
  String toString() {
    return toJson().toString();
  }
}
