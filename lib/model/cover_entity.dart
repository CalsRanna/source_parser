class CoverEntity {
  int id = 0;
  String url = '';
  int bookId = 0;

  CoverEntity();

  factory CoverEntity.fromJson(Map<String, dynamic> json) {
    return CoverEntity()
      ..id = json['id'] ?? 0
      ..url = json['url'] ?? ''
      ..bookId = json['book_id'] ?? 0;
  }

  CoverEntity copyWith({
    int? id,
    String? url,
    int? bookId,
  }) {
    return CoverEntity()
      ..id = id ?? this.id
      ..url = url ?? this.url
      ..bookId = bookId ?? this.bookId;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'book_id': bookId,
    };
  }
}
