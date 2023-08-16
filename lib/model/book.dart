class Book {
  String author;
  String catalogueUrl;
  String category;
  String cover;
  String introduction;
  String latestChapter;
  String name;
  int sourceId;
  List<int> sources;
  String status;
  String updatedAt;
  String url;
  String words;

  Book({
    this.author = '',
    this.catalogueUrl = '',
    this.category = '',
    this.cover = '',
    this.introduction = '',
    this.latestChapter = '',
    this.name = '',
    this.sourceId = 0,
    this.sources = const <int>[],
    this.status = '',
    this.updatedAt = '',
    this.url = '',
    this.words = '',
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      author: json['author'] ?? '',
      catalogueUrl: json['catalogue_url'] ?? '',
      category: json['category'] ?? '',
      cover: json['cover'] ?? '',
      introduction: json['introduction'] ?? '',
      latestChapter: json['latest_chapter'] ?? '',
      name: json['name'] ?? '',
      sourceId: json['source_id'] ?? 0,
      sources: json['sources'] ?? [0],
      status: json['status'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      url: json['url'] ?? '',
      words: json['words'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'catalogue_url': catalogueUrl,
      'category': category,
      'cover': cover,
      'introduction': introduction,
      'latest_chapter': latestChapter,
      'name': name,
      'source_id': sourceId,
      'sources': sources,
      'status': status,
      'updated_at': updatedAt,
      'url': url,
      'words': words,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
