class ReplacementEntity {
  int id = 0;
  String source = '';
  String target = '';
  int bookId = 0;

  ReplacementEntity();

  factory ReplacementEntity.fromJson(Map<String, dynamic> json) {
    return ReplacementEntity()
      ..id = json['id']
      ..source = json['source']
      ..target = json['target']
      ..bookId = json['book_id'];
  }

  ReplacementEntity copyWith({
    int? id,
    String? source,
    String? target,
    int? bookId,
  }) {
    return ReplacementEntity()
      ..id = id ?? this.id
      ..source = source ?? this.source
      ..target = target ?? this.target
      ..bookId = bookId ?? this.bookId;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'target': target,
      'book_id': bookId,
    };
  }
}
