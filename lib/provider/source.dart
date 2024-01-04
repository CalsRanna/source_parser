import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';

part 'source.g.dart';

@riverpod
class Sources extends _$Sources {
  @override
  Future<List<Source>> build() async {
    return await isar.sources.where().findAll();
  }

  Future<(List<Source>, List<Source>)> importSources({
    String from = 'network',
    required String value,
  }) async {
    const timeout = Duration(milliseconds: 30 * 1000);
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
}
