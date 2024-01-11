import 'dart:async';
import 'dart:convert';

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
  Future<Stream<List<ExploreResult>>> build() async {
    final controller = StreamController<List<ExploreResult>>();
    final setting = await ref.watch(settingNotifierProvider.future);
    final source = await isar.sources
        .filter()
        .idEqualTo(setting.exploreSource)
        .findFirst();
    if (source == null) {
      controller.close();
      return controller.stream;
    }
    final exploreJson = json.decode(source.exploreJson);
    final order = exploreJson.map((config) => config['title']).toList();
    final duration = Duration(hours: setting.cacheDuration.floor());
    final timeout = Duration(milliseconds: setting.timeout);
    final stream = await Parser.getExplore(source, duration, timeout);
    List<ExploreResult> exploreBooks = [];
    stream.listen(
      (exploreResult) {
        exploreBooks.add(exploreResult);
        exploreBooks.sort((a, b) {
          return order.indexOf(a.title).compareTo(order.indexOf(b.title));
        });
        controller.add(exploreBooks);
      },
      onDone: () => controller.close(),
      onError: (error) => controller.close(),
    );
    return controller.stream;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
