import 'package:floor/floor.dart';

import '../model/book.dart';

@dao
abstract class BookDao {
  @Query('select * from books')
  Future<List<Book>> getAllBooks();
}
