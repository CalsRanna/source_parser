import 'package:creator/creator.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/model/setting.dart';
import 'package:source_parser/state/global.dart';

final settingEmitter = Emitter<Setting>((ref, emit) async {
  final isar = await ref.watch(isarEmitter);
  Setting? setting = await isar.settings.where().findFirst();
  if (setting == null) {
    await isar.writeTxn(() async {
      isar.settings.put(Setting());
    });
    setting = await isar.settings.where().findFirst();
  }
  emit(setting!);
}, name: 'settingEmitter');
