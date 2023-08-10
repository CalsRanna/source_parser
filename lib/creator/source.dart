import 'package:creator/creator.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/main.dart';

import 'package:source_parser/schema/source.dart';

final sourcesEmitter = Emitter<List<Source>>((ref, emit) async {
  final sources = await isar.sources.where().findAll();
  emit(sources);
}, name: 'sourcesEmitter');

final currentSourceCreator = Creator<Source>.value(
  Source(),
  name: 'currentSourceCreator',
);
