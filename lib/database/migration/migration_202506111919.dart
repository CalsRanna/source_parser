import 'package:source_parser/database/service.dart';

class Migration202506111919 {
  static final availableSourceTable = 'books';
  static final alterAvailableSourceTableSql = '''
ALTER TABLE $availableSourceTable ADD COLUMN source_id INTEGER NOT NULL DEFAULT 0;
''';
  static final bookTable = 'books';
  static final alterBookTableSql = '''
ALTER TABLE $bookTable ADD COLUMN chapter_count INTEGER NOT NULL DEFAULT 0;
''';

  Future<void> migrate() async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic
        .table('migrations')
        .where('name', 'migration_202506111919')
        .count();
    if (count > 0) return;
    await laconic.statement(alterBookTableSql);
    var books = await laconic.table('books').get();
    for (var book in books) {
      var chapterCount =
          await laconic.table('chapters').where('book_id', book['id']).count();
      await laconic
          .table('books')
          .where('id', book['id'])
          .update({'chapter_count': chapterCount});
    }
    await laconic.table('migrations').insert([
      {'name': 'migration_202506111919'}
    ]);
  }
}
