import 'package:source_parser/database/service.dart';

class Migration202504241012 {
  static final createBookSourceTableSql = '''
CREATE TABLE $bookSourceTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL DEFAULT '',
  url TEXT NOT NULL DEFAULT '',
  enabled INTEGER NOT NULL DEFAULT 1,
  explore_enabled INTEGER NOT NULL DEFAULT 0,
  type TEXT NOT NULL DEFAULT 'book',
  comment TEXT NOT NULL DEFAULT '',
  header TEXT NOT NULL DEFAULT '',
  charset TEXT NOT NULL DEFAULT 'utf8',
  search_url TEXT NOT NULL DEFAULT '',
  search_method TEXT NOT NULL DEFAULT 'get',
  search_books TEXT NOT NULL DEFAULT '',
  search_name TEXT NOT NULL DEFAULT '',
  search_author TEXT NOT NULL DEFAULT '',
  search_category TEXT NOT NULL DEFAULT '',
  search_word_count TEXT NOT NULL DEFAULT '',
  search_introduction TEXT NOT NULL DEFAULT '',
  search_cover TEXT NOT NULL DEFAULT '',
  search_information_url TEXT NOT NULL DEFAULT '',
  search_latest_chapter TEXT NOT NULL DEFAULT '',
  information_method TEXT NOT NULL DEFAULT 'get',
  information_name TEXT NOT NULL DEFAULT '',
  information_author TEXT NOT NULL DEFAULT '',
  information_category TEXT NOT NULL DEFAULT '',
  information_word_count TEXT NOT NULL DEFAULT '',
  information_latest_chapter TEXT NOT NULL DEFAULT '',
  information_introduction TEXT NOT NULL DEFAULT '',
  information_cover TEXT NOT NULL DEFAULT '',
  information_catalogue_url TEXT NOT NULL DEFAULT '',
  catalogue_method TEXT NOT NULL DEFAULT 'get',
  catalogue_chapters TEXT NOT NULL DEFAULT '',
  catalogue_name TEXT NOT NULL DEFAULT '',
  catalogue_url TEXT NOT NULL DEFAULT '',
  catalogue_updated_at TEXT NOT NULL DEFAULT '',
  catalogue_pagination TEXT NOT NULL DEFAULT '',
  catalogue_pagination_validation TEXT NOT NULL DEFAULT '',
  catalogue_preset TEXT NOT NULL DEFAULT '',
  content_method TEXT NOT NULL DEFAULT 'get',
  content_content TEXT NOT NULL DEFAULT '',
  content_pagination TEXT NOT NULL DEFAULT '',
  content_pagination_validation TEXT NOT NULL DEFAULT '',
  explore_json TEXT NOT NULL DEFAULT ''
);
''';
  static final bookSourceTable = 'book_sources';
  static final createAvailableSourceTableSql = '''
CREATE TABLE $availableSourceTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  latest_chapter TEXT NOT NULL DEFAULT '',
  name TEXT NOT NULL DEFAULT '',
  url TEXT NOT NULL DEFAULT '',
  book_id INTEGER NOT NULL DEFAULT 0
);
''';
  static final availableSourceTable = 'available_sources';
  static final bookTable = 'books';
  static final createBookTableSql = '''
CREATE TABLE $bookTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  author TEXT NOT NULL DEFAULT '',
  archive INTEGER NOT NULL DEFAULT 0,
  catalogue_url TEXT NOT NULL DEFAULT '',
  category TEXT NOT NULL DEFAULT '',
  chapter_index INTEGER NOT NULL DEFAULT 0,
  cover TEXT NOT NULL DEFAULT '',
  introduction TEXT NOT NULL DEFAULT '',
  latest_chapter TEXT NOT NULL DEFAULT '',
  name TEXT NOT NULL DEFAULT '',
  page_index INTEGER NOT NULL DEFAULT 0,
  source_id INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT '',
  updated_at TEXT NOT NULL DEFAULT '',
  url TEXT NOT NULL DEFAULT '',
  words TEXT NOT NULL DEFAULT '',
  available_source_id INTEGER NOT NULL DEFAULT 0
);
''';
  static final chapterTable = 'chapters';
  static final createChapterTableSql = '''
CREATE TABLE $chapterTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL DEFAULT '',
  url TEXT NOT NULL DEFAULT '',
  book_id INTEGER NOT NULL
);
''';
  static final coverTable = 'covers';
  static final createCoverTableSql = '''
CREATE TABLE $coverTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  url TEXT NOT NULL DEFAULT '',
  book_id INTEGER NOT NULL
);
''';
  static final layoutTable = 'layouts';
  static final createLayoutTableSql = '''
CREATE TABLE $layoutTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slot_0 TEXT NOT NULL DEFAULT '',
  slot_1 TEXT NOT NULL DEFAULT '',
  slot_2 TEXT NOT NULL DEFAULT '',
  slot_3 TEXT NOT NULL DEFAULT '',
  slot_4 TEXT NOT NULL DEFAULT '',
  slot_5 TEXT NOT NULL DEFAULT '',
  slot_6 TEXT NOT NULL DEFAULT ''
);
''';
  static final themeTable = 'themes';
  static final createThemeTableSql = '''
CREATE TABLE $themeTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  background_color TEXT NOT NULL DEFAULT '',
  background_image TEXT NOT NULL DEFAULT '',
  chapter_font_size REAL NOT NULL DEFAULT 32,
  chapter_font_weight INTEGER NOT NULL DEFAULT 4,
  chapter_height REAL NOT NULL DEFAULT 1.618,
  chapter_letter_spacing REAL NOT NULL DEFAULT 0.618,
  chapter_word_spacing REAL NOT NULL DEFAULT 0.618,
  content_color TEXT NOT NULL DEFAULT '',
  content_font_size REAL NOT NULL DEFAULT 18,
  content_font_weight INTEGER NOT NULL DEFAULT 3,
  content_height REAL NOT NULL DEFAULT 2.236,
  content_letter_spacing REAL NOT NULL DEFAULT 0.618,
  content_word_spacing REAL NOT NULL DEFAULT 0.618,
  content_padding_bottom REAL NOT NULL DEFAULT 0,
  content_padding_left REAL NOT NULL DEFAULT 16,
  content_padding_right REAL NOT NULL DEFAULT 16,
  content_padding_top REAL NOT NULL DEFAULT 0,
  footer_color TEXT NOT NULL DEFAULT '',
  footer_font_size REAL NOT NULL DEFAULT 10,
  footer_font_weight INTEGER NOT NULL DEFAULT 2,
  footer_height REAL NOT NULL DEFAULT 1,
  footer_letter_spacing REAL NOT NULL DEFAULT 0.618,
  footer_word_spacing REAL NOT NULL DEFAULT 0.618,
  footer_padding_bottom REAL NOT NULL DEFAULT 16,
  footer_padding_left REAL NOT NULL DEFAULT 16,
  footer_padding_right REAL NOT NULL DEFAULT 16,
  footer_padding_top REAL NOT NULL DEFAULT 4,
  header_color TEXT NOT NULL DEFAULT '',
  header_font_size REAL NOT NULL DEFAULT 10,
  header_font_weight INTEGER NOT NULL DEFAULT 2,
  header_height REAL NOT NULL DEFAULT 1,
  header_letter_spacing REAL NOT NULL DEFAULT 0.618,
  header_word_spacing REAL NOT NULL DEFAULT 0.618,
  header_padding_bottom REAL NOT NULL DEFAULT 4,
  header_padding_left REAL NOT NULL DEFAULT 16,
  header_padding_right REAL NOT NULL DEFAULT 16,
  header_padding_top REAL NOT NULL DEFAULT 16,
  name TEXT NOT NULL DEFAULT 'Default Theme'
);
''';
  static final dropBookTableSql = '''
DROP TABLE IF EXISTS $bookTable;
''';
  static final dropAvailableSourceTableSql = '''
DROP TABLE IF EXISTS $availableSourceTable;
''';
  static final dropBookSourceTableSql = '''
DROP TABLE IF EXISTS $bookSourceTable;
''';
  static final dropChapterTableSql = '''
DROP TABLE IF EXISTS $chapterTable;
''';
  static final dropCoverTableSql = '''
DROP TABLE IF EXISTS $coverTable;
''';
  static final dropLayoutTableSql = '''
DROP TABLE IF EXISTS $layoutTable;
''';
  static final dropThemeTableSql = '''
DROP TABLE IF EXISTS $themeTable;
''';

  Future<void> migrate() async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic
        .table('migrations')
        .where('name', 'migration_202504241012')
        .count();
    if (count > 0) return;
    await laconic.statement(dropBookTableSql);
    await laconic.statement(dropAvailableSourceTableSql);
    await laconic.statement(dropBookSourceTableSql);
    await laconic.statement(dropChapterTableSql);
    await laconic.statement(dropCoverTableSql);
    await laconic.statement(dropLayoutTableSql);
    await laconic.statement(dropThemeTableSql);
    await laconic.statement(createBookSourceTableSql);
    await laconic.statement(createAvailableSourceTableSql);
    await laconic.statement(createBookTableSql);
    await laconic.statement(createChapterTableSql);
    await laconic.statement(createCoverTableSql);
    await laconic.statement(createLayoutTableSql);
    await laconic.statement(createThemeTableSql);

    // Note: Isar to SQLite data migration has been removed.
    // This migration now only creates the tables.
    // Users upgrading from older versions with Isar data should have
    // already completed the migration through the previous version.

    await laconic.table('migrations').insert([
      {'name': 'migration_202504241012'}
    ]);
  }
}
