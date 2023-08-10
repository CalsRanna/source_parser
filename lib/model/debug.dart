import 'package:source_parser/model/book.dart';
import 'package:source_parser/model/chapter.dart';

class DebugResult {
  DebugResult({
    required this.searchRaw,
    required this.searchBooks,
    required this.informationRaw,
    this.informationBook,
    required this.catalogueRaw,
    required this.catalogueChapters,
    required this.contentRaw,
    required this.contentContent,
  });

  String searchRaw;
  List<Book> searchBooks;
  String informationRaw;
  Book? informationBook;
  String catalogueRaw;
  List<Chapter> catalogueChapters;
  String contentRaw;
  String contentContent;
}
