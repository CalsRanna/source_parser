import 'package:floor/floor.dart';

@Entity(tableName: 'books')
class Book {
  Book({
    this.id,
    this.author,
    this.category,
    this.cover,
    this.introduction,
    this.name,
    this.url,
    this.catalogueUrl,
    this.status,
    this.words,
    this.latestChapter,
    this.sourceId,
  });

  @PrimaryKey()
  int? id;
  String? author;
  String? cover;
  String? category;
  String? introduction;
  String? name;
  String? url;
  @ColumnInfo(name: 'catalogue_url')
  String? catalogueUrl;
  String? status;
  String? words;
  @ColumnInfo(name: 'latest_chapter')
  String? latestChapter;
  int? sourceId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'category': category,
      'cover': cover,
      'introduction': introduction,
      'name': name,
      'url': url,
      'catalogue_url': catalogueUrl,
      'status': status,
      'words': words,
      'latest_chapter': latestChapter,
      'source_id': sourceId,
    };
  }
}
