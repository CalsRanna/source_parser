import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';

part 'source.g.dart';

@riverpod
class Sources extends _$Sources {
  @override
  Future<List<Source>> build() async {
    final sources = await isar.sources.where().findAll();
    sources.sort((a, b) {
      final aWeight = a.enabled ? -9999 : 9999;
      final bWeight = b.enabled ? -9999 : 9999;
      return aWeight.compareTo(bWeight);
    });
    return sources;
  }

  Future<(List<Source>, List<Source>)> importSources({
    String from = 'network',
    required String value,
  }) async {
    final setting = await ref.read(settingNotifierProvider.future);
    final timeout = Duration(milliseconds: setting.timeout);
    List<Source> sources = [];
    if (from == 'network') {
      sources = await Parser.importNetworkSource(value, timeout);
    } else {
      sources = await Parser.importLocalSource(value);
    }
    final sourcesInDatabase = await isar.sources.where().findAll();
    List<Source> newSources = [];
    List<Source> oldSources = [];
    for (var source in sources) {
      if (sourcesInDatabase.where((element) {
        final hasSameName = element.name == source.name;
        final hasSameUrl = element.url == source.url;
        return hasSameName && hasSameUrl;
      }).isNotEmpty) {
        oldSources.add(source);
      } else {
        newSources.add(source);
      }
    }
    return (newSources, oldSources);
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
    ref.invalidateSelf();
  }

  Future<int> store(Source source) async {
    var id = 0;
    await isar.writeTxn(() async {
      id = await isar.sources.put(source);
    });
    ref.invalidateSelf();
    return id;
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.sources.delete(id);
    });
    ref.invalidateSelf();
  }

  Future<Stream<int>> validate() async {
    final controller = StreamController<int>();
    final sources = await future;
    for (var source in sources) {
      store(source.copyWith(enabled: false));
    }
    final setting = await ref.read(settingNotifierProvider.future);
    final concurrent = setting.maxConcurrent.floor();
    final duration = Duration(seconds: setting.cacheDuration.floor());
    final timeout = Duration(milliseconds: setting.timeout);
    final stream = await Parser.validate('都市', concurrent, duration, timeout);
    List<int> valid = [];
    stream.listen(
      (id) {
        if (valid.contains(id)) return;
        valid.add(id);
        controller.add(id);
        final source = sources.where((element) => element.id == id).first;
        store(source.copyWith(enabled: true));
      },
      onDone: () => controller.close(),
      onError: (_) => controller.close(),
    );
    return controller.stream;
  }
}

@riverpod
class CurrentSource extends _$CurrentSource {
  @override
  Future<Source?> build() async {
    final sources = await ref.watch(sourcesProvider.future);
    final book = ref.watch(bookNotifierProvider);
    return sources.where((source) => source.id == book.sourceId).firstOrNull;
  }
}

@Riverpod(keepAlive: true)
class FormSource extends _$FormSource {
  @override
  Source build() => Source();

  void update(Source source) {
    state = source;
  }

  Future<String> validate() async {
    if (state.name.isEmpty) return '名称不能为空';
    if (state.url.isEmpty) return '网址不能为空';
    final filter = isar.sources.filter();
    var builder = filter.nameEqualTo(state.name);
    final exist = await builder.findFirst();
    if (exist != null && exist.id != state.id) {
      return '书源名称已存在';
    }
    return '';
  }

  void edit(int id) async {
    final sources = await ref.read(sourcesProvider.future);
    final source = sources.where((source) => source.id == id).firstOrNull;
    state = source ?? Source();
  }

  void create() async {
    ref.invalidateSelf();
  }

  Future<Stream<DebugResultNew>> debug() async {
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = setting.cacheDuration;
    final timeout = setting.timeout;
    final stream = Parser.debug(
      state,
      Duration(hours: duration.floor()),
      Duration(milliseconds: timeout),
    );
    return stream;
  }
}

@riverpod
class SourceDebugger extends _$SourceDebugger {
  @override
  Future<Stream<List<DebugResultNew>>> build() async {
    final controller = StreamController<List<DebugResultNew>>();
    final source = ref.read(formSourceProvider);
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = setting.cacheDuration;
    final timeout = setting.timeout;
    var stream = Parser.debug(
      source,
      Duration(hours: duration.floor()),
      Duration(milliseconds: timeout),
    );
    List<DebugResultNew> results = [];
    stream.listen(
      (result) {
        results.add(result);
        final isMacOS = Platform.isMacOS;
        final isWindows = Platform.isWindows;
        final isLinux = Platform.isLinux;
        final showExtra = isMacOS || isWindows || isLinux;
        if (showExtra && result.title == '正文') {
          results.add(DebugResultNew(
            json: result.json,
            html: jsonDecode(result.json)['content'].codeUnits.toString(),
            title: '正文Unicode编码',
          ));
        }
        controller.add(results);
      },
      onDone: () => controller.close(),
      onError: (error) => controller.close(),
    );
    return controller.stream;
  }

  void debug() async {
    ref.invalidateSelf();
  }
}
