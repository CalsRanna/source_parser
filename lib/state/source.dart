import 'package:creator/creator.dart';

import '../entity/book_source.dart';
import '../model/rule.dart';
import 'global.dart';

final bookSourceCreator = Creator<BookSource?>.value(null, name: 'bookSource');

final bookSourcesCreator = Emitter<List<BookSource>?>((ref, emit) async {
  final database = ref.watch(databaseCreator);
  final sources = await database?.bookSourceDao.getAllBookSources();
  emit(sources);
}, name: 'bookSources');

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
