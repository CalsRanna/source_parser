import 'dart:math';

import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/model/cache.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/semaphore.dart';

part 'cache.g.dart';

@riverpod
class CacheSize extends _$CacheSize {
  @override
  Future<String> build() async {
    return await _getCacheSize();
  }

  Future<bool> clear() async {
    final cleared = await CacheManager().clearCache();
    ref.invalidateSelf();
    return cleared;
  }

  Future<String> _getCacheSize() async {
    final total = await CacheManager().getCacheSize();
    String string;
    if (total < 1024) {
      string = '$total Bytes';
    } else if (total >= 1024 && total < 1024 * 1024) {
      string = '${(total / 1024).toStringAsFixed(2)} KB';
    } else {
      string = '${(total / 1024 / 1024).toStringAsFixed(2)} MB';
    }
    return string;
  }
}

@Riverpod(keepAlive: true)
class CacheProgressNotifier extends _$CacheProgressNotifier {
  @override
  CacheProgress build() => CacheProgress();

  Future<void> cacheChapters({int amount = 3}) async {
    final book = ref.read(bookNotifierProvider);
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(book.sourceId).findFirst();
    if (source == null) return;
    if (amount == 0) {
      amount = book.chapters.length - (book.index + 1);
    }
    amount = min(amount, book.chapters.length - (book.index + 1));
    state = state.copyWith(amount: amount, failed: 0, succeed: 0);
    final startIndex = book.index + 1;
    final endIndex = min(startIndex + amount, book.chapters.length);
    final setting = await ref.read(settingNotifierProvider.future);
    final maxConcurrent = setting.maxConcurrent;
    final semaphore = Semaphore(maxConcurrent.floor());
    List<Future<void>> futures = [];
    for (var i = startIndex; i < endIndex; i++) {
      futures.add(_cacheChapter(source, i, semaphore));
    }
    await Future.wait(futures);
  }

  Future<void> _cacheChapter(
    Source source,
    int index,
    Semaphore semaphore,
  ) async {
    await semaphore.acquire();
    try {
      final book = ref.read(bookNotifierProvider);
      final url = book.chapters.elementAt(index).url;
      final setting = await ref.read(settingNotifierProvider.future);
      final timeout = setting.timeout;
      final network = CachedNetwork(
        prefix: book.name,
        timeout: Duration(milliseconds: timeout),
      );
      final cached = await network.cached(url);
      if (!cached) {
        await network.request(
          url,
          charset: source.charset,
          method: source.contentMethod,
        );
      }
      state = state.copyWith(succeed: state.succeed + 1);
    } catch (error) {
      state = state.copyWith(failed: state.failed + 1);
    } finally {
      semaphore.release();
    }
  }
}
