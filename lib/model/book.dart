class Book {
  String author;
  String catalogueUrl;
  String category;
  String cover;
  String introduction;
  String name;
  int sourceId;
  String url;

  Book({
    required this.author,
    required this.catalogueUrl,
    required this.category,
    required this.cover,
    required this.introduction,
    required this.name,
    required this.sourceId,
    required this.url,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      author: json['author'],
      catalogueUrl: json['catalogue_url'],
      category: json['category'],
      cover: json['cover'],
      introduction: json['introduction'],
      name: json['name'],
      sourceId: json['source_id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'catalogue_url': catalogueUrl,
      'category': category,
      'cover': cover,
      'introduction': introduction,
      'name': name,
      'source_id': sourceId,
      'url': url,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
