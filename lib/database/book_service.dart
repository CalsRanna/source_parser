import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/book_entity.dart';

class BookService {
  Future<List<BookEntity>> getBooks() async {
    var laconic = DatabaseService.instance.laconic;
    var books = await laconic.table('books').get();
    return books.map((book) => BookEntity.fromJson(book.toMap())).toList();
  }

  Future<void> destroyBook(BookEntity book) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('books').where('id', book.id).delete();
  }
}
