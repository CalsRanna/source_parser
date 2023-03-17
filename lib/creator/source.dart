import 'package:creator/creator.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/model/source.dart';
import 'package:source_parser/state/global.dart';

final sourceEmitter = Emitter.arg1<Source, int?>((ref, id, emit) async {
  final isar = await ref.watch(isarEmitter);
  var source = Source();
  if (id != null) {
    source = (await isar.sources.filter().idEqualTo(id).findFirst())!;
  }
  emit(source);
}, name: (id) => 'sourceEmitter_$id');

final sourcesEmitter = Emitter<List<Source>>((ref, emit) async {
  final isar = await ref.watch(isarEmitter);
  final sources = await isar.sources.where().findAll();
  emit(sources);
}, name: 'sourcesEmitter');
