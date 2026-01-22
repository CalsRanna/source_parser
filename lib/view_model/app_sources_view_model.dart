import 'dart:async';

import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/util/parser.dart';

class AppSourcesViewModel {
  final sources = signal<List<SourceEntity>>([]);
  final loading = signal(false);
  final validating = signal(false);
  final validSourceIds = signal<List<int>>([]);
  final _sourceService = SourceService();

  Future<void> initSignals() async {
    loading.value = true;
    await _loadSources();
    loading.value = false;
  }

  Future<void> _loadSources() async {
    final loadedSources = await _sourceService.getAllSources();
    loadedSources.sort((a, b) {
      final aWeight = a.enabled ? -9999 : 9999;
      final bWeight = b.enabled ? -9999 : 9999;
      return aWeight.compareTo(bWeight);
    });
    sources.value = loadedSources;
  }

  Future<int> storeSource(SourceEntity source) async {
    var id = source.id;
    if (id == 0) {
      // New source, need to get the ID after insert
      var existing = await _sourceService.countSourceByNameAndUrl(
        source.name,
        source.url,
      );
      if (existing > 0) {
        var existingSource = await _sourceService.getSourceByNameAndUrl(
          source.name,
          source.url,
        );
        id = existingSource.id;
      }
    }
    await _sourceService.updateSource(source);
    await _loadSources();
    return id;
  }

  Future<void> deleteSource(int id) async {
    await _sourceService.destroySource(id);
    await _loadSources();
  }

  Future<void> confirmImport(
    List<SourceEntity> newSources,
    List<SourceEntity> oldSources, {
    bool override = false,
  }) async {
    if (override) {
      for (var oldSource in oldSources) {
        final count = await _sourceService.countSourceByNameAndUrl(
          oldSource.name,
          oldSource.url,
        );
        if (count > 0) {
          final existingSource = await _sourceService.getSourceByNameAndUrl(
            oldSource.name,
            oldSource.url,
          );
          final updatedSource = oldSource.copyWith(id: existingSource.id);
          await _sourceService.updateSource(updatedSource);
        }
      }
    }
    await _sourceService.addSources(newSources);
    await _loadSources();
  }

  Future<Stream<int>> validate() async {
    validating.value = true;
    validSourceIds.value = [];

    final controller = StreamController<int>();
    final currentSources = await _sourceService.getAllSources();

    for (var source in currentSources) {
      final updatedSource = source.copyWith(enabled: false);
      await _sourceService.updateSource(updatedSource);
    }

    await _loadSources();

    // TODO: Get these values from settings service
    final concurrent = 16;
    final duration = const Duration(seconds: 4);
    final timeout = const Duration(milliseconds: 30000);

    final stream = await Parser.validate('都市', concurrent, duration, timeout);
    List<int> valid = [];

    stream.listen(
      (id) {
        if (valid.contains(id)) return;
        valid.add(id);
        controller.add(id);
        final source =
            currentSources.where((element) => element.id == id).firstOrNull;
        if (source != null) {
          final updatedSource = source.copyWith(enabled: true);
          // Note: This is async but we're not awaiting in the original
          _sourceService.updateSource(updatedSource).then((_) {
            _loadSources();
          });
        }
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

  SourceEntity? getSourceByNameAndUrl(String name, String url) {
    return sources.value
        .where((source) => source.name == name && source.url == url)
        .firstOrNull;
  }

  SourceEntity? getSourceByName(String name) {
    return sources.value.where((source) => source.name == name).firstOrNull;
  }

  SourceEntity? getSource(int id) {
    return sources.value.where((source) => source.id == id).firstOrNull;
  }

  List<SourceEntity> getEnabledSources() {
    return sources.value.where((source) => source.enabled).toList();
  }

  List<SourceEntity> getExploreSources() {
    return sources.value.where((source) => source.exploreEnabled).toList();
  }

  Stream<String> debugSource(SourceEntity source) {
    return Parser.debug(source).map((result) {
      if (result.title == '正文') {
        return '${result.title}\n${result.json}';
      }
      return '${result.title}\n${result.html}\n${result.json}';
    });
  }
}
