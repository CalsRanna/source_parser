class Book {
  int id = 0;
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
  String latestChapter = '';
  String name = '';
  int sourceId = 0;
  String status = '';
  String updatedAt = '';
  String url = '';
  String words = '';
  int availableSourceId = 0;

  Book();

  factory Book.fromJson(Map<String, dynamic> json) {
    List<Chapter> chapters = [];
    if (json['chapters'] is List) {
      chapters = (json['chapters'] as List).map((chapter) {
        return Chapter.fromJson(chapter);
      }).toList();
    }
    return Book()
      ..id = json['id'] ?? 0
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
      ..sourceId = json['source_id'] as int? ?? 0
      ..status = json['status'] ?? ''
      ..updatedAt = json['updated_at'] ?? ''
      ..url = json['url'] ?? ''
      ..words = json['words'] ?? ''
      ..availableSourceId = json['available_source_id'] ?? 0;
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
      'status': status,
      'updated_at': updatedAt,
      'url': url,
      'words': words,
      'available_source_id': availableSourceId
    };
  }

  Book copyWith({
    int? id,
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
    String? status,
    String? updatedAt,
    String? url,
    String? words,
    int? availableSourceId,
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
      ..status = status ?? this.status
      ..updatedAt = updatedAt ?? this.updatedAt
      ..url = url ?? this.url
      ..words = words ?? this.words
      ..availableSourceId = availableSourceId ?? this.availableSourceId;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

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
