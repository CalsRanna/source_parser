class Book {
  String author;
  String catalogueUrl;
  String category;
  String cover;
  String introduction;
  String name;
  String url;

  Book({
    required this.author,
    required this.catalogueUrl,
    required this.category,
    required this.cover,
    required this.introduction,
    required this.name,
    required this.url,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      author: json['author'],
      catalogueUrl: json['catalogueUrl'],
      category: json['category'],
      cover: json['cover'],
      introduction: json['introduction'],
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'catalogueUrl': catalogueUrl,
      'category': category,
      'cover': cover,
      'introduction': introduction,
      'name': name,
      'url': url,
    };
  }
}
