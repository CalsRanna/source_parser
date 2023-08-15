import 'package:isar/isar.dart';

part 'history.g.dart';

@collection
@Name('histories')
class History {
  Id id = Isar.autoIncrement;
  String? author;
  int? chapters;
  String? cover;
  int cursor = 0;
  int index = 0;
  String? introduction;
  String? name;
  @Name('source_id')
  int? sourceId;
  String? url;
}
