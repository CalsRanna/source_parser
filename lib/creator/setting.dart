import 'package:creator/creator.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/model/setting.dart';
import 'package:source_parser/state/global.dart';

final settingEmitter = Emitter<Setting>((ref, emit) async {
  final isar = await ref.watch(isarEmitter);
  final setting = await isar.settings.where().findFirst() ?? Setting();
  emit(setting);
}, name: 'settingEmitter');
