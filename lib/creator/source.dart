import 'package:creator/creator.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/main.dart';

import 'package:source_parser/schema/source.dart';

Emitter<Source> sourceEmitter(int? id) {
  return Emitter((ref, emit) async {
    var source = Source();
    if (id != null) {
      source = (await isar.sources.filter().idEqualTo(id).findFirst())!;
    }
    emit(source);
  }, args: ['source', id], name: 'sourceEmitter_$id');
}

final sourcesEmitter = Emitter<List<Source>>((ref, emit) async {
  final sources = await isar.sources.where().findAll();
  emit(sources);
}, name: 'sourcesEmitter');
