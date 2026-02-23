import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/cloud_book_entity.dart';

class CloudBookService {
  Future<List<CloudBookEntity>> getBooks() async {
    var laconic = DatabaseService.instance.laconic;
    var rows = await laconic.table('cloud_books').get();
    return rows.map((row) => CloudBookEntity.fromDb(row.toMap())).toList();
  }

  Future<CloudBookEntity?> getBook(String bookUrl) async {
    var laconic = DatabaseService.instance.laconic;
    var rows =
        await laconic.table('cloud_books').where('book_url', bookUrl).get();
    if (rows.isEmpty) return null;
    return CloudBookEntity.fromDb(rows.first.toMap());
  }

  Future<void> upsertBook(CloudBookEntity entity) async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic
        .table('cloud_books')
        .where('book_url', entity.bookUrl)
        .count();
    if (count > 0) {
      await laconic
          .table('cloud_books')
          .where('book_url', entity.bookUrl)
          .update(entity.toDb());
    } else {
      await laconic.table('cloud_books').insert([entity.toDb()]);
    }
  }

  Future<void> upsertBooks(List<CloudBookEntity> entities) async {
    if (entities.isEmpty) return;
    var laconic = DatabaseService.instance.laconic;
    await laconic.transaction(() async {
      for (var entity in entities) {
        var count = await laconic
            .table('cloud_books')
            .where('book_url', entity.bookUrl)
            .count();
        if (count > 0) {
          await laconic
              .table('cloud_books')
              .where('book_url', entity.bookUrl)
              .update(entity.toDb());
        } else {
          await laconic.table('cloud_books').insert([entity.toDb()]);
        }
      }
    });
  }

  Future<void> deleteBook(String bookUrl) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('cloud_books').where('book_url', bookUrl).delete();
  }

  Future<void> deleteBooks(List<String> bookUrls) async {
    if (bookUrls.isEmpty) return;
    var laconic = DatabaseService.instance.laconic;
    await laconic.transaction(() async {
      for (var bookUrl in bookUrls) {
        await laconic.table('cloud_books').where('book_url', bookUrl).delete();
      }
    });
  }

  Future<void> updateProgress(
    String bookUrl,
    int chapterIndex,
    String chapterTitle,
    int pageIndex,
  ) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('cloud_books').where('book_url', bookUrl).update({
      'dur_chapter_index': chapterIndex,
      'dur_chapter_title': chapterTitle,
      'dur_chapter_pos': pageIndex,
      'dur_chapter_time': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
