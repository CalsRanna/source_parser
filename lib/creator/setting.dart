import 'package:creator/creator.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/schema/setting.dart';

final settingEmitter = Emitter<Setting>((ref, emit) async {
  final setting = await isar.settings.where().findFirst() ?? Setting();
  emit(setting);
}, name: 'settingEmitter');
