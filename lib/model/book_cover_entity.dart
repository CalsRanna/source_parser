class BookCoverEntity {
  int id = 0;
  String url = '';
  int bookId = 0;

  BookCoverEntity();

  factory BookCoverEntity.fromJson(Map<String, dynamic> json) {
    return BookCoverEntity()
      ..id = json['id'] ?? 0
      ..url = json['url'] ?? ''
      ..bookId = json['book_id'] ?? 0;
  }

  BookCoverEntity copyWith({
    int? id,
    String? url,
    int? bookId,
  }) {
    return BookCoverEntity()
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
