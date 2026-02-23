import 'package:source_parser/model/cloud_search_book_entity.dart';

class CloudAvailableSourceEntity {
  int id = 0;
  String bookUrl = '';
  String sourceBookUrl = '';
  String origin = '';
  String originName = '';
  String latestChapterTitle = '';

  CloudAvailableSourceEntity();

  factory CloudAvailableSourceEntity.fromDb(Map<String, dynamic> json) {
    return CloudAvailableSourceEntity()
      ..id = json['id'] ?? 0
      ..bookUrl = json['book_url'] ?? ''
      ..sourceBookUrl = json['source_book_url'] ?? ''
      ..origin = json['origin'] ?? ''
      ..originName = json['origin_name'] ?? ''
      ..latestChapterTitle = json['latest_chapter_title'] ?? '';
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'book_url': bookUrl,
      'source_book_url': sourceBookUrl,
      'origin': origin,
      'origin_name': originName,
      'latest_chapter_title': latestChapterTitle,
    };
  }

  factory CloudAvailableSourceEntity.fromSearchEntity(
    String bookUrl,
    CloudSearchBookEntity entity,
  ) {
    return CloudAvailableSourceEntity()
      ..bookUrl = bookUrl
      ..sourceBookUrl = entity.bookUrl
      ..origin = entity.origin
      ..originName = entity.originName
      ..latestChapterTitle = entity.latestChapterTitle;
  }

  CloudSearchBookEntity toSearchEntity() {
    return CloudSearchBookEntity()
      ..bookUrl = sourceBookUrl
      ..origin = origin
      ..originName = originName
      ..latestChapterTitle = latestChapterTitle;
  }
}
