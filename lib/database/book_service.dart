import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/book_entity.dart';

class BookService {
  Future<void> addToBookshelf(BookEntity book) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('books').insert(book.toJson());
  }

  Future<void> destroyBook(BookEntity book) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('books').where('id', book.id).delete();
  }

  Future<BookEntity> getBook(int id) async {
    var laconic = DatabaseService.instance.laconic;
    var book = await laconic.table('books').where('id', id).first();
    return BookEntity.fromJson(book.toMap());
  }

  Future<List<BookEntity>> getBooks() async {
    var laconic = DatabaseService.instance.laconic;
    var books = await laconic.table('books').get();
    return books.map((book) => BookEntity.fromJson(book.toMap())).toList();
  }

  Future<bool> getIsInShelf(int bookId) async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic.table('books').where('id', bookId).count();
    return count > 0;
  }

  Future<void> removeFromBookshelf(int bookId) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('books').where('id', bookId).delete();
  }

  Future<void> updateIsInShelf(int bookId, bool isInShelf) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('books').where('id', bookId).update({
      'is_in_shelf': isInShelf,
    });
  }
}
