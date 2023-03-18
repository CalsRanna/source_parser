import 'package:creator/creator.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/model/history.dart';
import 'package:source_parser/model/setting.dart';
import 'package:source_parser/model/source.dart';

final isarEmitter = Emitter<Isar>((ref, emit) async {
  final isar = await Isar.open([HistorySchema, SettingSchema, SourceSchema]);
  emit(isar);
}, keepAlive: true, name: 'isarEmitter');
