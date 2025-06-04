class AvailableSourceEntity {
  int id = 0;
  String latestChapter = '';
  String name = '';
  String url = '';
  int bookId = 0;
  int sourceId = 0;

  AvailableSourceEntity();

  factory AvailableSourceEntity.fromJson(Map<String, dynamic> json) {
    return AvailableSourceEntity()
      ..id = json['id'] ?? 0
      ..latestChapter = json['latest_chapter'] ?? ''
      ..name = json['name'] ?? ''
      ..url = json['url'] ?? ''
      ..bookId = json['book_id'] ?? 0
      ..sourceId = json['source_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latest_chapter': latestChapter,
      'name': name,
      'url': url,
      'book_id': bookId,
      'source_id': sourceId,
    };
  }

  AvailableSourceEntity copyWith({
    int? id,
    String? latestChapter,
    String? name,
    String? url,
    int? bookId,
    int? sourceId,
  }) {
    return AvailableSourceEntity()
      ..id = id ?? this.id
      ..latestChapter = latestChapter ?? this.latestChapter
      ..name = name ?? this.name
      ..url = url ?? this.url
      ..bookId = bookId ?? this.bookId
      ..sourceId = sourceId ?? this.sourceId;
  }
}
