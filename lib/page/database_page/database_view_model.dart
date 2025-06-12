import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/service.dart';

class DatabaseViewModel {
  final tables = signal(<String>[]);
  final showTableData = signal(false);
  final currentTable = signal('');
  final tableData = signal(<Map<String, Object?>>[]);
  final rowData = signal(<String, Object?>{});
  final columnData = signal('');
  final level = signal(1);

  Future<void> initSignals() async {
    var laconic = DatabaseService.instance.laconic;
    var results = await laconic
        .table('sqlite_master')
        .where('type', 'table')
        .select(['name']).get();
    tables.value = results.map((e) => e['name'] as String).toList();
  }

  Future<void> getTableData(int index) async {
    var table = tables.value[index];
    var laconic = DatabaseService.instance.laconic;
    var results = await laconic.table(table).get();
    tableData.value = results.map((e) => e.toMap()).toList();
    level.value = 2;
    currentTable.value = table;
  }

  Future<void> getRowData(int index) async {
    var row = tableData.value[index];
    var laconic = DatabaseService.instance.laconic;
    var column = 'id';
    var value = row[column];
    if (value == null) {
      column = 'name';
      value = row[column];
    }
    var result =
        await laconic.table(currentTable.value).where(column, value).sole();
    rowData.value = result.toMap();
    level.value = 3;
  }

  Future<void> getColumnData(int index) async {
    var keys = rowData.value.keys;
    columnData.value = (rowData.value[keys.elementAt(index)]).toString();
    level.value = 4;
  }

  Future<void> back() async {
    if (level.value > 1) level.value -= 1;
  }
}
