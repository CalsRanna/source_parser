import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/chapter_entity.dart';

class ChapterService {
  Future<List<ChapterEntity>> getChapters(int bookId) async {
    var laconic = DatabaseService.instance.laconic;
    var chapters =
        await laconic.table('chapters').where('book_id', bookId).get();
    return chapters
        .map((chapter) => ChapterEntity.fromJson(chapter.toMap()))
        .toList();
  }
}
