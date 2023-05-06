import 'package:isar/isar.dart';

part 'book.g.dart';

@collection
@Name('books')
class Book {
  Id id = Isar.autoIncrement;
  String? author;
  String? cover;
  String? category;
  String? introduction;
  String? name;
  String? url;
  @Name('catalogue_url')
  String? catalogueUrl;
  String? status;
  String? words;
  @Name('latest_chapter')
  String? latestChapter;
}
