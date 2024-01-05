import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';

part 'setting.g.dart';

@riverpod
class SettingNotifier extends _$SettingNotifier {
  @override
  Future<Setting> build() async {
    var setting = await isar.settings.where().findFirst();
    if (setting == null) {
      setting = Setting();
      await isar.writeTxn(() async {
        await isar.settings.put(setting!);
      });
    }
    return setting;
  }
}
