import 'package:source_parser/schema/history.dart';

class Book {
  String author;
  String catalogueUrl;
  String category;
  List<Chapter> chapters;
  String cover;
  String introduction;
  String latestChapter;
  String name;
  int sourceId;
  List<AvailableSource> sources;
  String status;
  String updatedAt;
  String url;
  String words;

  Book({
    this.author = '',
    this.catalogueUrl = '',
    this.category = '',
    this.cover = '',
    this.chapters = const <Chapter>[],
    this.introduction = '',
    this.latestChapter = '',
    this.name = '',
    this.sourceId = 0,
    this.sources = const <AvailableSource>[],
    this.status = '',
    this.updatedAt = '',
    this.url = '',
    this.words = '',
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    List<Chapter> chapters = [];
    if (json['chapters'] is List) {
      chapters = json['chapters'].map<Chapter>((chapter) {
        return Chapter.fromJson(chapter);
      }).toList();
    }
    List<AvailableSource> sources = [];
    if (json['sources'] is List) {
      sources = json['sources'].map<AvailableSource>((source) {
        return AvailableSource.fromJson(source);
      }).toList();
    }
    return Book(
      author: json['author'] ?? '',
      catalogueUrl: json['catalogue_url'] ?? '',
      category: json['category'] ?? '',
      cover: json['cover'] ?? '',
      chapters: chapters,
      introduction: json['introduction'] ?? '',
      latestChapter: json['latest_chapter'] ?? '',
      name: json['name'] ?? '',
      sourceId: json['source_id'] ?? 0,
      sources: sources,
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
      'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
      'introduction': introduction,
      'latest_chapter': latestChapter,
      'name': name,
      'source_id': sourceId,
      'sources': sources.map((source) => source.toJson()).toList(),
      'status': status,
      'updated_at': updatedAt,
      'url': url,
      'words': words,
    };
  }

  Book copyWith({
    String? author,
    String? catalogueUrl,
    String? category,
    List<Chapter>? chapters,
    String? cover,
    String? introduction,
    String? latestChapter,
    String? name,
    int? sourceId,
    List<AvailableSource>? sources,
    String? status,
    String? updatedAt,
    String? url,
    String? words,
  }) {
    return Book(
      author: author ?? this.author,
      catalogueUrl: catalogueUrl ?? this.catalogueUrl,
      category: category ?? this.category,
      chapters: chapters ?? this.chapters,
      cover: cover ?? this.cover,
      introduction: introduction ?? this.introduction,
      latestChapter: latestChapter ?? this.latestChapter,
      name: name ?? this.name,
      sourceId: sourceId ?? this.sourceId,
      sources: sources ?? this.sources,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      url: url ?? this.url,
      words: words ?? this.words,
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
