import 'package:isar/isar.dart';

part 'available_source.g.dart';

@collection
@Name('available_sources')
class AvailableSource {
  Id id = Isar.autoIncrement;
  @Name('latest_chapter')
  String latestChapter = '';
  String name = '';
  String url = '';
  @Name('book_id')
  int bookId = 0;

  AvailableSource();

  factory AvailableSource.fromJson(Map<String, dynamic> json) {
    return AvailableSource()
      ..id = json['id'] ?? 0
      ..latestChapter = json['latest_chapter'] ?? ''
      ..name = json['name'] ?? ''
      ..url = json['url'] ?? ''
      ..bookId = json['book_id'] ?? 0;
  }

  AvailableSource copyWith({
    int? id,
    String? latestChapter,
    String? name,
    String? url,
    int? bookId,
  }) {
    return AvailableSource()
      ..id = id ?? this.id
      ..latestChapter = latestChapter ?? this.latestChapter
      ..name = name ?? this.name
      ..url = url ?? this.url
      ..bookId = bookId ?? this.bookId;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latest_chapter': latestChapter,
      'name': name,
      'url': url,
      'book_id': bookId,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
