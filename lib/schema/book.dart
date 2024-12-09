import 'package:isar/isar.dart';

part 'book.g.dart';

@collection
@Name('books')
class Book {
  Id id = Isar.autoIncrement;
  String author = '';
  bool archive = false;
  String catalogueUrl = '';
  String category = '';
  List<Chapter> chapters = [];
  String cover = '';
  List<String> covers = [];
  int cursor = 0;
  int index = 0;
  String introduction = '';
  @Name('latest_chapter')
  String latestChapter = '';
  String name = '';
  @Name('source_id')
  int sourceId = 0;
  @Name('sources')
  List<AvailableSource> sources = [];
  String status = '';
  @Name('updated_at')
  String updatedAt = '';
  String url = '';
  String words = '';

  Book();

  factory Book.fromJson(Map<String, dynamic> json) {
    List<Chapter> chapters = [];
    if (json['chapters'] is List) {
      chapters = (json['chapters'] as List).map((chapter) {
        return Chapter.fromJson(chapter);
      }).toList();
    }
    List<AvailableSource> sources = [];
    if (json['sources'] is List) {
      sources = (json['sources'] as List).map((source) {
        return AvailableSource.fromJson(source);
      }).toList();
    }
    return Book()
      ..author = json['author'] ?? ''
      ..archive = json['archive'] ?? false
      ..catalogueUrl = json['catalogue_url'] ?? ''
      ..category = json['category'] ?? ''
      ..chapters = chapters
      ..cover = json['cover'] ?? ''
      ..covers = json['covers'] ?? []
      ..cursor = json['cursor'] ?? 0
      ..index = json['index'] ?? 0
      ..introduction = json['introduction'] ?? ''
      ..latestChapter = json['latest_chapter'] ?? ''
      ..name = json['name'] ?? ''
      ..sourceId = json['source_id'] as int
      ..sources = sources
      ..status = json['status'] ?? ''
      ..updatedAt = json['updated_at'] ?? ''
      ..url = json['url'] ?? ''
      ..words = json['words'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'archive': archive,
      'catalogue_url': catalogueUrl,
      'category': category,
      'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
      'cover': cover,
      'covers': covers,
      'cursor': cursor,
      'index': index,
      'introduction': introduction,
      'latest_chapter': latestChapter,
      'name': name,
      'source_id': sourceId,
      'sources': sources.map((source) => source.toJson()).toList(),
      'status': status,
      'updated_at': updatedAt,
      'url': url,
      'words': words,
    };
  }

  Book copyWith({
    Id? id,
    String? author,
    bool? archive,
    String? catalogueUrl,
    String? category,
    List<Chapter>? chapters,
    String? cover,
    List<String>? covers,
    int? cursor,
    int? index,
    String? introduction,
    String? latestChapter,
    String? name,
    int? sourceId,
    List<AvailableSource>? sources,
    String? status,
    String? updatedAt,
    String? url,
    String? words,
  }) {
    return Book()
      ..id = id ?? this.id
      ..author = author ?? this.author
      ..archive = archive ?? this.archive
      ..catalogueUrl = catalogueUrl ?? this.catalogueUrl
      ..category = category ?? this.category
      ..chapters = chapters ?? this.chapters
      ..cover = cover ?? this.cover
      ..covers = covers ?? this.covers
      ..cursor = cursor ?? this.cursor
      ..index = index ?? this.index
      ..introduction = introduction ?? this.introduction
      ..latestChapter = latestChapter ?? this.latestChapter
      ..name = name ?? this.name
      ..sourceId = sourceId ?? this.sourceId
      ..sources = sources ?? this.sources
      ..status = status ?? this.status
      ..updatedAt = updatedAt ?? this.updatedAt
      ..url = url ?? this.url
      ..words = words ?? this.words;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

@embedded
@Name('chapters')
class Chapter {
  String name = '';
  String url = '';

  Chapter();

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter()
      ..name = json['name'] ?? ''
      ..url = json['url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url};
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

@embedded
@Name('available_sources')
class AvailableSource {
  int id = 0;
  @Name('latest_chapter')
  String latestChapter = '';
  String name = '';
  String url = '';

  AvailableSource();

  factory AvailableSource.fromJson(Map<String, dynamic> json) {
    return AvailableSource()
      ..id = json['id'] ?? 0
      ..latestChapter = json['latest_chapter'] ?? ''
      ..name = json['name'] ?? ''
      ..url = json['url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latest_chapter': latestChapter,
      'name': name,
      'url': url
    };
  }

  AvailableSource copyWith({
    int? id,
    String? latestChapter,
    String? name,
    String? url,
  }) {
    return AvailableSource()
      ..id = id ?? this.id
      ..latestChapter = latestChapter ?? this.latestChapter
      ..name = name ?? this.name
      ..url = url ?? this.url;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
