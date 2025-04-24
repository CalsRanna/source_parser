import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/book_cover_entity.dart';

class BookCoverService {
  Future<List<BookCoverEntity>> getBookCovers(int bookId) async {
    var laconic = DatabaseService.instance.laconic;
    var covers = await laconic.table('covers').where('book_id', bookId).get();
    return covers
        .map((cover) => BookCoverEntity.fromJson(cover.toMap()))
        .toList();
  }
}
