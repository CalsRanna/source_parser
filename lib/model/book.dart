class Book {
  String author;
  String catalogueUrl;
  String category;
  String cover;
  String introduction;
  String name;
  int sourceId;
  List<int> sources;
  String url;

  Book({
    this.author = '',
    this.catalogueUrl = '',
    this.category = '',
    this.cover = '',
    this.introduction = '',
    this.name = '',
    this.sourceId = 0,
    this.sources = const <int>[],
    this.url = '',
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      author: json['author'] ?? '',
      catalogueUrl: json['catalogue_url'] ?? '',
      category: json['category'] ?? '',
      cover: json['cover'] ?? '',
      introduction: json['introduction'] ?? '',
      name: json['name'] ?? '',
      sourceId: json['source_id'] ?? 0,
      sources: json['sources'] ?? [0],
      url: json['url'] ?? '',
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
      'sources': sources,
      'url': url,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
