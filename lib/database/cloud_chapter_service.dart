import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/cloud_chapter_entity.dart';

class CloudChapterService {
  Future<List<CloudChapterEntity>> getChapters(String bookUrl) async {
    var laconic = DatabaseService.instance.laconic;
    var rows = await laconic
        .table('cloud_chapters')
        .where('book_url', bookUrl)
        .get();
    var chapters =
        rows.map((row) => CloudChapterEntity.fromDb(row.toMap())).toList();
    chapters.sort((a, b) => a.index.compareTo(b.index));
    return chapters;
  }

  Future<void> replaceChapters(
    String bookUrl,
    List<CloudChapterEntity> chapters,
  ) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('cloud_chapters').where('book_url', bookUrl).delete();
    if (chapters.isEmpty) return;
    var data = chapters.map((chapter) => chapter.toDb()).toList();
    await laconic.table('cloud_chapters').insert(data);
  }

  Future<void> deleteChapters(String bookUrl) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('cloud_chapters').where('book_url', bookUrl).delete();
  }
}
