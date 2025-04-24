import 'package:source_parser/database/service.dart';

class Migration {
  Future<void> migrate() async {
    var laconic = DatabaseService.instance.laconic;
    var existMigrationTable = await laconic.table('migrations').count();
    if (existMigrationTable == 0) {
      await laconic.statement('create table migrations(name text)');
    }
  }
}
