import 'package:source_parser/database/service.dart';

class Migration202602240100 {
  static final cloudAvailableSourcesTable = 'cloud_available_sources';
  static final createCloudAvailableSourcesTableSql = '''
CREATE TABLE $cloudAvailableSourcesTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_url TEXT NOT NULL DEFAULT '',
  source_book_url TEXT NOT NULL DEFAULT '',
  origin TEXT NOT NULL DEFAULT '',
  origin_name TEXT NOT NULL DEFAULT '',
  latest_chapter_title TEXT NOT NULL DEFAULT ''
);
''';

  static final createIndexSql = '''
CREATE INDEX idx_cloud_available_sources_book_url ON $cloudAvailableSourcesTable (book_url);
''';

  Future<void> migrate() async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic
        .table('migrations')
        .where('name', 'migration_202602240100')
        .count();
    if (count > 0) return;
    await laconic.statement(createCloudAvailableSourcesTableSql);
    await laconic.statement(createIndexSql);
    await laconic.table('migrations').insert([
      {'name': 'migration_202602240100'}
    ]);
  }
}
