import 'dart:io';

import 'package:laconic/laconic.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/database/migration/migration_202404241012.dart';
import 'package:source_parser/util/logger.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  late Laconic laconic;

  DatabaseService._internal();

  Future<void> ensureInitialized() async {
    var directory = await getApplicationSupportDirectory();
    var path = join(directory.path, 'source_parser.db');
    var file = File(path);
    logger.i('sqlite path: $path');
    var exists = await file.exists();
    if (!exists) {
      await file.create(recursive: true);
    }
    var config = SqliteConfig(path);
    laconic = Laconic.sqlite(config, listen: (query) {
      logger.d(query.rawSql);
    });
    await _migrate();
  }

  Future<void> _migrate() async {
    var laconic = DatabaseService.instance.laconic;
    var tables = await laconic.select(checkMigrationExistSql);
    if (tables.isEmpty) {
      await laconic.statement(migrationCreateSql);
    }
    await Migration202404241012().migrate();
  }

  final migrationCreateSql = '''
CREATE TABLE migrations(
  name TEXT NOT NULL
);
''';
  final checkMigrationExistSql = '''
SELECT name FROM sqlite_master WHERE type='table' AND name='migrations';
''';
}
