import 'package:source_parser/database/service.dart';

class Migration202508060112 {
  static final replacementTable = 'replacements';
  static final createReplacementTableSql = '''
CREATE TABLE $replacementTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  source TEXT NOT NULL DEFAULT '',
  target TEXT NOT NULL DEFAULT '',
  book_id INTEGER NOT NULL DEFAULT 0
);
''';

  Future<void> migrate() async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic
        .table('migrations')
        .where('name', 'migration_202508060112')
        .count();
    if (count > 0) return;
    await laconic.statement(createReplacementTableSql);
    await laconic.table('migrations').insert([
      {'name': 'migration_202508060112'}
    ]);
  }
}
