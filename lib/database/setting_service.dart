import 'package:source_parser/database/service.dart';
import 'package:source_parser/model/setting_entity.dart';

class SettingService {
  Future<SettingEntity?> getSetting() async {
    var laconic = DatabaseService.instance.laconic;
    var settings = await laconic.table('settings').get();
    if (settings.isEmpty) return null;
    return SettingEntity.fromJson(settings.first.toMap());
  }

  Future<void> updateSetting(SettingEntity setting) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('settings').where('id', setting.id).update(setting.toJson());
  }

  Future<void> createSetting(SettingEntity setting) async {
    var laconic = DatabaseService.instance.laconic;
    var json = setting.toJson();
    json.remove('id');
    await laconic.table('settings').insert([json]);
  }
}
