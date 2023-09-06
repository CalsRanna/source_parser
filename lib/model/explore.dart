import 'package:source_parser/schema/book.dart';

class ExploreResult {
  ExploreResult({
    this.layout = '',
    this.title = '',
    this.books = const [],
  });

  String layout;
  String title;
  List<Book> books;
}
