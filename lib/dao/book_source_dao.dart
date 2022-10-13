import 'package:floor/floor.dart';

import '../model/book_source.dart';

@dao
abstract class BookSourceDao {
  @delete
  Future<void> deleteBookSource(BookSource bookSource);
  @Query('select * from book_sources where id=:id')
  Future<BookSource?> getBookSource(int id);
  @Query('select * from book_sources where name=:name')
  Future<BookSource?> findBookSourceByName(String name);
  @Query('select * from book_sources where url like %:url%')
  Future<BookSource?> findBookSourceByUrl(String url);
  @Query(
      'select * from book_sources where explore_enabled=1 order by weight asc limit 1')
  Future<BookSource?> findFirstExploreEnabledBookSource();
  @Query('SELECT * FROM book_sources')
  Future<List<BookSource>> getAllBookSources();
  @Query(
      'select * from book_sources where explore_enabled=1 order by weight asc')
  Future<List<BookSource>> getAllExploreEnabledBookSources();
  @Query('select * from book_sources where enabled=1 order by weight asc')
  Future<List<BookSource>> getAllEnabledBookSources();
  @insert
  Future<void> insertBookSource(BookSource bookSource);
  @update
  Future<void> updateBookSource(BookSource bookSource);
  @Query(
      'delete from book_sources;update sqlite_sequence set seq=0 where name="book_sources";')
  Future<void> emptyBookSources();
}
