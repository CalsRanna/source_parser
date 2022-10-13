import 'package:floor/floor.dart';

@Entity(tableName: 'rules')
class Rule {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  @ColumnInfo(name: 'source_id')
  final int? sourceId;
  final String? value;
  // IntColumn get id => integer().autoIncrement()();
  // TextColumn get name => text()();
  // IntColumn get sourceId => integer()();
  // TextColumn get value => text().nullable()();
  Rule(this.id, this.name, this.sourceId, this.value);

  Rule.bean({this.id, this.name = '', this.sourceId, this.value});
}
