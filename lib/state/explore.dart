import 'package:creator/creator.dart';

import '../model/book_source.dart';
import '../model/explore_module.dart';
import '../model/rule.dart';
import 'global.dart';

final exploreBookSourcesEmitter = Emitter<List<BookSource>?>((ref, emit) async {
  final database = ref.watch(databaseEmitter.asyncData).data;
  final sources =
      await database?.bookSourceDao.getAllExploreEnabledBookSources();
  emit(sources);
}, keepAlive: true, name: 'exploreBookSources');

final exploreBookSourceEmitter = Emitter<BookSource?>(
  (ref, emit) async {
    final database = ref.watch(databaseEmitter.asyncData).data;
    final bookSource =
        await database?.bookSourceDao.findFirstExploreEnabledBookSource();
    emit(bookSource);
  },
  keepAlive: true,
  name: 'exploreBookSource',
);

final exploreRulesEmitter = Emitter<List<Rule>?>(
  (ref, emit) async {
    final database = ref.watch(databaseEmitter.asyncData).data;
    final bookSource = await ref.watch(exploreBookSourceEmitter);
    List<Rule>? rules;
    if (bookSource != null) {
      rules = await database?.ruleDao.getRulesBySourceId(bookSource.id!);
    }
    emit(rules);
  },
  keepAlive: true,
  name: 'exploreRules',
);

final exploreModulesEmitter = Emitter<List<ExploreModule>>(
  (ref, emmit) async {
    // final bookSource = await ref.watch(exploreBookSourceCreator);
    // final rules = await ref.watch(exploreRulesCreator);
    List<ExploreModule> modules = [];
    emmit(modules);
  },
  keepAlive: true,
  name: 'exploreModules',
);
