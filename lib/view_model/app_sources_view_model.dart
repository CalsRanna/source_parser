import 'dart:async';

import 'package:isar/isar.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';

class AppSourcesViewModel {
  final sources = signal<List<Source>>([]);
  final loading = signal(false);
  final validating = signal(false);
  final validSourceIds = signal<List<int>>([]);

  Future<void> initSignals() async {
    loading.value = true;
    await _loadSources();
    loading.value = false;
  }

  Future<void> _loadSources() async {
    final loadedSources = await isar.sources.where().findAll();
    loadedSources.sort((a, b) {
      final aWeight = a.enabled ? -9999 : 9999;
      final bWeight = b.enabled ? -9999 : 9999;
      return aWeight.compareTo(bWeight);
    });
    sources.value = loadedSources;
  }

  Future<int> storeSource(Source source) async {
    var id = 0;
    await isar.writeTxn(() async {
      id = await isar.sources.put(source);
    });
    await _loadSources();
    return id;
  }

  Future<void> deleteSource(int id) async {
    await isar.writeTxn(() async {
      await isar.sources.delete(id);
    });
    await _loadSources();
  }

  Future<void> confirmImport(
    List<Source> newSources,
    List<Source> oldSources, {
    bool override = false,
  }) async {
    if (override) {
      final builder = isar.sources.filter();
      for (var oldSource in oldSources) {
        final source = await builder
            .nameEqualTo(oldSource.name)
            .urlEqualTo(oldSource.url)
            .findFirst();
        if (source != null) {
          await isar.writeTxn(() async {
            await isar.sources.put(oldSource.copyWith(id: source.id));
          });
        }
      }
    }
    await isar.writeTxn(() async {
      await isar.sources.putAll(newSources);
    });
    await _loadSources();
  }

  Future<Stream<int>> validate() async {
    validating.value = true;
    validSourceIds.value = [];

    final controller = StreamController<int>();
    final currentSources = await isar.sources.where().findAll();

    for (var source in currentSources) {
      await isar.writeTxn(() async {
        await isar.sources.put(source.copyWith(enabled: false));
      });
    }

    await _loadSources();

    final setting = await isar.settings.where().findFirst();
    final concurrent = setting?.maxConcurrent.floor() ?? 16;
    final duration = Duration(seconds: setting?.cacheDuration.floor() ?? 4);
    final timeout = Duration(milliseconds: setting?.timeout ?? 30000);

    final stream = await Parser.validate('都市', concurrent, duration, timeout);
    List<int> valid = [];

    stream.listen(
      (id) {
        if (valid.contains(id)) return;
        valid.add(id);
        controller.add(id);
        final source =
            currentSources.where((element) => element.id == id).first;
        storeSource(source.copyWith(enabled: true));
      },
      onDone: () {
        validating.value = false;
        controller.close();
      },
      onError: (error) {
        validating.value = false;
        controller.close();
      },
    );

    return controller.stream;
  }

  Source? getSourceByNameAndUrl(String name, String url) {
    return sources.value
        .where((source) => source.name == name && source.url == url)
        .firstOrNull;
  }

  Source? getSourceByName(String name) {
    return sources.value.where((source) => source.name == name).firstOrNull;
  }

  Source? getSource(int id) {
    return sources.value.where((source) => source.id == id).firstOrNull;
  }

  List<Source> getEnabledSources() {
    return sources.value.where((source) => source.enabled).toList();
  }

  List<Source> getExploreSources() {
    return sources.value.where((source) => source.exploreEnabled).toList();
  }

  Stream<String> debugSource(Source source) {
    final sourceEntity = _convertToSourceEntity(source);
    return Parser.debug(sourceEntity).map((result) {
      if (result.title == '正文') {
        return '${result.title}\n${result.json}';
      }
      return '${result.title}\n${result.html}\n${result.json}';
    });
  }

  SourceEntity _convertToSourceEntity(Source source) {
    return SourceEntity.fromJson(source.toJson());
  }
}
