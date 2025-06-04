class BookEntity {
  int id = 0;
  String author = '';
  bool archive = false;
  String catalogueUrl = '';
  String category = '';
  int chapterIndex = 0;
  String cover = '';
  String introduction = '';
  String latestChapter = '';
  String name = '';
  int pageIndex = 0;
  String status = '';
  String updatedAt = '';
  String url = '';
  String words = '';
  int sourceId = 0;

  BookEntity();

  factory BookEntity.fromJson(Map<String, dynamic> json) {
    return BookEntity()
      ..id = json['id'] as int? ?? 0
      ..author = json['author'] ?? ''
      ..archive = json['archive'] == 1 ? true : false
      ..catalogueUrl = json['catalogue_url'] ?? ''
      ..category = json['category'] ?? ''
      ..chapterIndex = json['chapter_index'] ?? 0
      ..cover = json['cover'] ?? ''
      ..introduction = json['introduction'] ?? ''
      ..latestChapter = json['latest_chapter'] ?? ''
      ..name = json['name'] ?? ''
      ..pageIndex = json['page_index'] ?? 0
      ..status = json['status'] ?? ''
      ..updatedAt = json['updated_at'] ?? ''
      ..url = json['url'] ?? ''
      ..words = json['words'] ?? ''
      ..sourceId = json['source_id'] as int? ?? 0;
  }

  BookEntity copyWith({
    int? id,
    String? author,
    bool? archive,
    String? catalogueUrl,
    String? category,
    int? chapterIndex,
    String? cover,
    String? introduction,
    String? latestChapter,
    String? name,
    int? pageIndex,
    String? status,
    String? updatedAt,
    String? url,
    String? words,
    int? sourceId,
  }) {
    return BookEntity()
      ..id = id ?? this.id
      ..author = author ?? this.author
      ..archive = archive ?? this.archive
      ..catalogueUrl = catalogueUrl ?? this.catalogueUrl
      ..category = category ?? this.category
      ..chapterIndex = chapterIndex ?? this.chapterIndex
      ..cover = cover ?? this.cover
      ..introduction = introduction ?? this.introduction
      ..latestChapter = latestChapter ?? this.latestChapter
      ..name = name ?? this.name
      ..pageIndex = pageIndex ?? this.pageIndex
      ..status = status ?? this.status
      ..updatedAt = updatedAt ?? this.updatedAt
      ..url = url ?? this.url
      ..words = words ?? this.words
      ..sourceId = sourceId ?? this.sourceId;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'archive': archive ? 1 : 0,
      'catalogue_url': catalogueUrl,
      'category': category,
      'chapter_index': chapterIndex,
      'cover': cover,
      'introduction': introduction,
      'latest_chapter': latestChapter,
      'name': name,
      'page_index': pageIndex,
      'status': status,
      'updated_at': updatedAt,
      'url': url,
      'words': words,
      'source_id': sourceId,
    };
  }
}
