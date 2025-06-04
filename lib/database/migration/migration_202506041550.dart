import 'package:source_parser/database/service.dart';

class Migration202506041550 {
  static final availableSourceTable = 'available_sources';
  static final alterAvailableSourceTableSql = '''
ALTER TABLE $availableSourceTable ADD COLUMN source_id INTEGER NOT NULL DEFAULT 0;
''';
  static final bookTable = 'books';
  static final alterBookTableSql = '''
ALTER TABLE $bookTable DROP COLUMN available_source_id;
''';

  Future<void> migrate() async {
    var laconic = DatabaseService.instance.laconic;
    var count = await laconic
        .table('migrations')
        .where('name', 'migration_202506041550')
        .count();
    if (count > 0) return;
    await laconic.statement(alterAvailableSourceTableSql);
    await laconic.statement(alterBookTableSql);
    await laconic.table('migrations').insert([
      {'name': 'migration_202506041550'}
    ]);
  }
}
