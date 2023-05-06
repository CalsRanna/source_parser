import 'package:isar/isar.dart';

part 'history.g.dart';

@collection
@Name('histories')
class History {
  Id id = Isar.autoIncrement;
  String? author;
  String? cover;
  String? name;
}
