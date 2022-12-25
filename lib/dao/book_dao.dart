import 'package:floor/floor.dart';
import 'package:source_parser/model/book.dart';

@dao
abstract class BookDao {
  @Query('select * from books')
  Future<List<Book>> getAllBooks();
}
