import 'package:source_parser/schema/book.dart';

class DebugResult {
  DebugResult({
    this.searchRaw = '',
    this.searchBooks = const <Book>[],
    this.informationRaw = '',
    this.informationBook = const <Book>[],
    this.catalogueRaw = '',
    this.catalogueChapters = const <Chapter>[],
    this.contentRaw = '',
    this.contentContent = '',
  });

  String searchRaw;
  List<Book> searchBooks;
  String informationRaw;
  List<Book> informationBook;
  String catalogueRaw;
  List<Chapter> catalogueChapters;
  String contentRaw;
  String contentContent;
}
