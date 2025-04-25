class ChapterEntity {
  int id = 0;
  String name = '';
  String url = '';
  int bookId = 0;

  ChapterEntity();

  factory ChapterEntity.fromJson(Map<String, dynamic> json) {
    return ChapterEntity()
      ..id = json['id'] ?? 0
      ..name = json['name'] ?? ''
      ..url = json['url'] ?? ''
      ..bookId = json['book_id'] ?? 0;
  }

  ChapterEntity copyWith({
    int? id,
    String? name,
    String? url,
    int? bookId,
  }) {
    return ChapterEntity()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..url = url ?? this.url
      ..bookId = bookId ?? this.bookId;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'book_id': bookId,
    };
  }
}
