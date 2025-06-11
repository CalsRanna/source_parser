import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/book_entity.dart';

class BookService {
  Future<void> addBook(BookEntity book) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('books').insert([book.toJson()]);
  }

  Future<bool> checkIsInShelf(int id) async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic.table('books').where('id', id).count();
    return count > 0;
  }

  Future<void> destroyBook(int id) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('books').where('id', id).delete();
  }

  Future<BookEntity> getBook(int id) async {
    var laconic = DatabaseService.instance.laconic;
    var book = await laconic.table('books').where('id', id).first();
    return BookEntity.fromJson(book.toMap());
  }

  Future<BookEntity> getBookByName(String name) async {
    var laconic = DatabaseService.instance.laconic;
    var book = await laconic.table('books').where('name', name).first();
    return BookEntity.fromJson(book.toMap());
  }

  Future<List<BookEntity>> getBooks() async {
    var laconic = DatabaseService.instance.laconic;
    var books = await laconic.table('books').get();
    return books.map((book) => BookEntity.fromJson(book.toMap())).toList();
  }

  Future<void> updateBook(BookEntity book) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('books').where('id', book.id).update(book.toJson());
  }

  Future<void> updateIsInShelf(int id, bool isInShelf) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('books').where('id', id).update({
      'is_in_shelf': isInShelf,
    });
  }
}
