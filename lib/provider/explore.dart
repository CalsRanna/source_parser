import 'dart:async';

import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/model/explore.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';

part 'explore.g.dart';

@riverpod
class ExploreBooks extends _$ExploreBooks {
  @override
  Future<List<ExploreResult>> build() async {
    final setting = await ref.watch(settingNotifierProvider.future);
    final source = await isar.sources
        .filter()
        .idEqualTo(setting.exploreSource)
        .findFirst();
    if (source == null) return [];
    final duration = Duration(hours: setting.cacheDuration.floor());
    final timeout = Duration(milliseconds: setting.timeout);
    final stream = await Parser.getExplore(source, duration, timeout);
    List<ExploreResult> exploreBooks = [];
    stream.listen((exploreResult) async {
      final previousState = await future;
      state = AsyncData([...previousState, exploreResult]);
    });
    return exploreBooks;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
