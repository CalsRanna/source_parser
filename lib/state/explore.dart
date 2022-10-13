import 'package:creator/creator.dart';

import '../entity/book_source.dart';
import '../entity/explore_module.dart';
import '../entity/rule.dart';
import 'global.dart';

final exploreBookSourcesCreator = Emitter<List<BookSource>?>((ref, emit) async {
  final database = ref.watch(databaseCreator);
  final sources =
      await database?.bookSourceDao.getAllExploreEnabledBookSources();
  emit(sources);
}, keepAlive: true, name: 'exploreBookSources');

final exploreBookSourceCreator = Emitter<BookSource?>(
  (ref, emit) async {
    final database = ref.watch(databaseCreator);
    final bookSource =
        await database?.bookSourceDao.findFirstExploreEnabledBookSource();
    emit(bookSource);
  },
  keepAlive: true,
  name: 'exploreBookSource',
);

final exploreRulesCreator = Emitter<List<Rule>?>(
  (ref, emit) async {
    final database = ref.watch(databaseCreator);
    final bookSource = await ref.watch(exploreBookSourceCreator);
    List<Rule>? rules;
    if (bookSource != null) {
      rules = await database?.ruleDao.getRulesBySourceId(bookSource.id!);
    }
    emit(rules);
  },
  keepAlive: true,
  name: 'exploreRules',
);

final exploreModulesState = Emitter<List<ExploreModule>>(
  (ref, emmit) async {
    // final bookSource = await ref.watch(exploreBookSourceCreator);
    // final rules = await ref.watch(exploreRulesCreator);
    List<ExploreModule> modules = [];
    emmit(modules);
  },
  keepAlive: true,
  name: 'exploreModules',
);
