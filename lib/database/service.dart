import 'dart:io';

import 'package:laconic/laconic.dart';
import 'package:laconic_sqlite/laconic_sqlite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/database/migration/migration_202504241012.dart';
import 'package:source_parser/database/migration/migration_202506041550.dart';
import 'package:source_parser/database/migration/migration_202506111919.dart';
import 'package:source_parser/database/migration/migration_202508060112.dart';
import 'package:source_parser/database/migration/migration_202602231200.dart';
import 'package:source_parser/database/migration/migration_202602240100.dart';
import 'package:source_parser/util/logger.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  late Laconic laconic;
  late String dbPath;

  DatabaseService._internal();

  Future<void> ensureInitialized() async {
    var directory = await getApplicationSupportDirectory();
    dbPath = join(directory.path, 'source_parser.db');
    var file = File(dbPath);
    logger.i('sqlite path: $dbPath');
    var exists = await file.exists();
    if (!exists) {
      await file.create(recursive: true);
    }
    var driver = SqliteDriver(SqliteConfig(dbPath));
    laconic = Laconic(driver, listen: (query) {
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
    await Migration202504241012().migrate();
    await Migration202506041550().migrate();
    await Migration202506111919().migrate();
    await Migration202508060112().migrate();
    await Migration202602231200().migrate();
    await Migration202602240100().migrate();
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

/// Open a short-lived Laconic connection for use inside an isolate.
Laconic openLaconic(String dbPath) {
  var driver = SqliteDriver(SqliteConfig(dbPath));
  return Laconic(driver);
}
