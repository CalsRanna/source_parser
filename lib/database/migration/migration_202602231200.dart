import 'package:source_parser/database/service.dart';

class Migration202602231200 {
  static final cloudBooksTable = 'cloud_books';
  static final createCloudBooksTableSql = '''
CREATE TABLE $cloudBooksTable (
  book_url TEXT PRIMARY KEY,
  toc_url TEXT NOT NULL DEFAULT '',
  origin TEXT NOT NULL DEFAULT '',
  origin_name TEXT NOT NULL DEFAULT '',
  name TEXT NOT NULL DEFAULT '',
  author TEXT NOT NULL DEFAULT '',
  kind TEXT NOT NULL DEFAULT '',
  cover_url TEXT NOT NULL DEFAULT '',
  intro TEXT NOT NULL DEFAULT '',
  type INTEGER NOT NULL DEFAULT 0,
  group_id INTEGER NOT NULL DEFAULT 0,
  latest_chapter_title TEXT NOT NULL DEFAULT '',
  latest_chapter_time INTEGER NOT NULL DEFAULT 0,
  last_check_time INTEGER NOT NULL DEFAULT 0,
  last_check_count INTEGER NOT NULL DEFAULT 0,
  total_chapter_num INTEGER NOT NULL DEFAULT 0,
  dur_chapter_title TEXT NOT NULL DEFAULT '',
  dur_chapter_index INTEGER NOT NULL DEFAULT 0,
  dur_chapter_pos INTEGER NOT NULL DEFAULT 0,
  dur_chapter_time INTEGER NOT NULL DEFAULT 0,
  word_count TEXT NOT NULL DEFAULT '',
  can_update INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER NOT NULL DEFAULT 0,
  origin_order INTEGER NOT NULL DEFAULT 0,
  use_replace_rule INTEGER NOT NULL DEFAULT 0,
  is_in_shelf INTEGER NOT NULL DEFAULT 0
);
''';

  static final cloudChaptersTable = 'cloud_chapters';
  static final createCloudChaptersTableSql = '''
CREATE TABLE $cloudChaptersTable (
  book_url TEXT NOT NULL DEFAULT '',
  chapter_index INTEGER NOT NULL DEFAULT 0,
  url TEXT NOT NULL DEFAULT '',
  title TEXT NOT NULL DEFAULT '',
  is_volume INTEGER NOT NULL DEFAULT 0,
  base_url TEXT NOT NULL DEFAULT '',
  tag TEXT NOT NULL DEFAULT '',
  PRIMARY KEY (book_url, chapter_index)
);
''';

  Future<void> migrate() async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic
        .table('migrations')
        .where('name', 'migration_202602231200')
        .count();
    if (count > 0) return;
    await laconic.statement(createCloudBooksTableSql);
    await laconic.statement(createCloudChaptersTableSql);
    await laconic.table('migrations').insert([
      {'name': 'migration_202602231200'}
    ]);
  }
}
