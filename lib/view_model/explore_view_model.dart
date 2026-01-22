import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/explore.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/view_model/app_setting_view_model.dart';

class ExploreViewModel {
  final exploreBooks = signal<List<ExploreResult>>([]);
  final loading = signal(false);
  final settingViewModel = AppSettingViewModel();

  Future<void> initSignals() async {
    loading.value = true;
    await _loadExploreBooks();
    loading.value = false;
  }

  Future<void> _loadExploreBooks() async {
    await settingViewModel.initSignals();
    final sourceId = settingViewModel.setting.value?.exploreSource ?? 0;
    if (sourceId == 0) {
      exploreBooks.value = [];
      return;
    }

    final source = await isar.sources.filter().idEqualTo(sourceId).findFirst();
    if (source == null) {
      exploreBooks.value = [];
      return;
    }

    final exploreJsonString = source.exploreJson;
    if (exploreJsonString.isEmpty) {
      exploreBooks.value = [];
      return;
    }

    final exploreJson = jsonDecode(exploreJsonString);
    final setting = settingViewModel.setting.value;
    final duration = Duration(hours: setting?.cacheDuration.floor() ?? 4);
    final timeout = Duration(milliseconds: setting?.timeout ?? 30000);
    final maxConcurrent = setting?.maxConcurrent.floor() ?? 16;

    final results = await Parser.getExplore(
      source,
      duration,
      timeout,
      maxConcurrent,
    );

    results.sort((a, b) {
      final aOrder = exploreJson
          .indexWhere((config) => config['title'])
          .toList()
          .indexOf(a.title);
      final bOrder = exploreJson
          .indexWhere((config) => config['title'])
          .toList()
          .indexOf(b.title);
      return aOrder.compareTo(bOrder);
    });

    exploreBooks.value = results;
  }

  Future<void> refresh() async {
    await _loadExploreBooks();
  }
}
