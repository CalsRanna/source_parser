import 'dart:async';
import 'dart:math';

import 'package:signals/signals_flutter.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/cache_network.dart';

class CacheViewModel {
  final progress = signal(0.0);
  final completed = signal(0);
  final failed = signal(0);
  final isCaching = signal(false);

  late StreamController<int> _controller;

  CacheViewModel() {
    _controller = StreamController<int>();
  }

  Future<void> initSignals() async {
    // Initialize signals if needed
  }

  Future<void> cacheChapters({
    required Book book,
    int amount = 0,
    int maxConcurrent = 16,
    Duration cacheDuration = const Duration(hours: 4),
    Duration timeout = const Duration(milliseconds: 30000),
  }) async {
    if (isCaching.value) return;

    isCaching.value = true;
    progress.value = 0.0;
    completed.value = 0;
    failed.value = 0;

    _controller = StreamController<int>();

    var network = CachedNetwork(prefix: book.name, timeout: timeout);
    var chapters = book.chapters;
    var count =
        amount == 0 ? chapters.length : amount.clamp(0, chapters.length);
    count = count.clamp(0, chapters.length);

    final startIndex = book.index + 1;
    final endIndex = min(startIndex + count, chapters.length);

    for (var i = startIndex; i < endIndex; i++) {
      final chapter = chapters[i];
      final url = chapter.url;
      final cached = await network.check(url);
      if (!cached) {
        await network.request(
          url,
          charset: 'utf-8',
          duration: cacheDuration,
        );
        completed.value++;
      } else {
        completed.value++;
      }
      progress.value = (i - startIndex + 1) / count;
    }

    isCaching.value = false;
    await _controller.close();
  }

  Stream<int> get progressStream => _controller.stream;

  Future<void> dispose() async {
    await _controller.close();
  }

  Future<void> resetStats() async {
    progress.value = 0.0;
    completed.value = 0;
    failed.value = 0;
  }
}
