import 'package:source_parser/database/service.dart';
import 'package:source_parser/schema/theme.dart';

class ThemeService {
  Future<void> addTheme(Theme theme) async {
    var laconic = DatabaseService.instance.laconic;
    var json = theme.toJson();
    json.remove('id');
    await laconic.table('themes').insert([json]);
  }

  Future<void> destroyTheme(int id) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('themes').where('id', id).delete();
  }

  Future<List<Theme>> getThemes() async {
    var laconic = DatabaseService.instance.laconic;
    var themes = await laconic.table('themes').get();
    return themes.map((theme) => Theme.fromJson(theme.toMap())).toList();
  }

  Future<void> updateTheme(Theme theme) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('themes').where('id', theme.id).update(theme.toJson());
  }
}
