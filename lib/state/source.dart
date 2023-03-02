import 'package:creator/creator.dart';
import 'package:source_parser/model/book_source.dart';
import 'package:source_parser/model/rule.dart';
import 'package:source_parser/model/source.dart';
import 'package:source_parser/state/global.dart';

final bookSourceCreator = Creator<BookSource>.value(
  BookSource.bean(),
  name: 'bookSource',
);

final bookSourcesCreator = Emitter<List<BookSource>?>((ref, emit) async {
  final database = ref.watch(databaseEmitter.asyncData).data;
  final sources = await database?.bookSourceDao.getAllBookSources();
  emit(sources);
}, name: 'bookSources');

final sourcesEmitter = Emitter<List<Source?>?>((ref, emit) async {
  final isar = ref.watch(isarEmitter.asyncData).data;
  final sources = await isar?.sources.getAll([]);
  emit(sources);
}, name: 'sources');

final searchRuleCreator = Creator<SearchRule?>.value(
  null,
  keepAlive: true,
  name: 'searchRule',
);

final exploreRuleCreator = Creator<ExploreRule?>.value(
  null,
  keepAlive: true,
  name: 'exploreRule',
);

final informationRuleCreator = Creator<InformationRule?>.value(
  null,
  keepAlive: true,
  name: 'informationRule',
);

final catalogueRuleCreator = Creator<CatalogueRule?>.value(
  null,
  keepAlive: true,
  name: 'catalogueRule',
);

final contentRuleCreator = Creator<ContentRule?>.value(
  null,
  keepAlive: true,
  name: 'contentRule',
);
