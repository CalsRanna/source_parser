import 'dart:math';

import 'package:flutter/material.dart' hide Theme;
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/reader/reader_controller.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/reader/local_reader_delegate.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/semaphore.dart';
import 'package:source_parser/util/shared_preference_util.dart';
import 'package:source_parser/util/string_extension.dart';
import 'package:source_parser/model/source_entity.dart';

class ReaderViewModel {
  final BookEntity book;
  late final LocalReaderDelegate delegate;
  late final ReaderController controller;

  final showCacheIndicator = signal(false);
  final downloadAmount = signal(0);
  final downloadSucceed = signal(0);
  final downloadFailed = signal(0);

  late final progress = computed(() {
    if (downloadAmount.value == 0) return 0.0;
    return (downloadSucceed.value + downloadFailed.value) /
        downloadAmount.value;
  });

  ReaderViewModel({required this.book}) {
    delegate = LocalReaderDelegate(book: book);
    controller = ReaderController(
      delegate: delegate,
      initialPageIndex: book.pageIndex,
      progressDebounceDuration: const Duration(seconds: 1),
    );
  }

  // --- 生命周期 ---

  Future<void> initSignals() async {
    await controller.init();
  }

  Future<void> syncBookshelf() async {
    await delegate.onLeave();
  }

  // --- 本地特有功能 ---

  void downloadChapters(BuildContext context, int amount) async {
    var realAmount = amount;
    if (amount == 0) {
      realAmount =
          delegate.chapters.length - (controller.chapterIndex.value + 1);
    }
    realAmount = min(
      realAmount,
      delegate.chapters.length - (controller.chapterIndex.value + 1),
    );
    downloadAmount.value = realAmount;
    downloadSucceed.value = 0;
    downloadFailed.value = 0;
    showCacheIndicator.value = true;
    final startIndex = controller.chapterIndex.value + 1;
    final endIndex = min(
      startIndex + downloadAmount.value,
      delegate.chapters.length,
    );
    var concurrent = await SharedPreferenceUtil.getMaxConcurrent();
    final semaphore = Semaphore(concurrent);
    List<Future<void>> futures = [];
    for (var i = startIndex; i < endIndex; i++) {
      futures.add(_downloadChapter(delegate.source, i, semaphore));
    }
    await Future.wait(futures);
    if (!context.mounted) return;
    DialogUtil.snackBar(StringConfig.cacheCompleted.format([
      downloadSucceed.value,
      downloadFailed.value,
    ]));
    await Future.delayed(const Duration(seconds: 1));
    showCacheIndicator.value = false;
    downloadAmount.value = 0;
    downloadSucceed.value = 0;
    downloadFailed.value = 0;
  }

  void navigateReplacementPage(BuildContext context) {
    ReaderReplacementRoute(book: book).push(context);
  }

  Future<void> navigateAvailableSourcePage(BuildContext context) async {
    var copiedBook = book.copyWith(sourceId: delegate.source.id);
    var availableSource = await AvailableSourceRoute(
      availableSources: delegate.availableSources,
      book: copiedBook,
    ).push<AvailableSourceEntity>(context);
    await delegate.reloadAvailableSources();
    if (availableSource == null) return;
    controller.clearLayoutCache();
    DialogUtil.loading();
    controller.isRotating = true;
    var sourceId = availableSource.sourceId;
    delegate.source = await SourceService().getBookSource(sourceId);
    var url = availableSource.url;
    var updatedCatalogueUrl = await delegate.getRemoteCatalogueUrl(url);
    delegate.catalogueUrl = updatedCatalogueUrl;
    var updatedChapters = await delegate.getRemoteChapters();
    if (updatedChapters.isEmpty) {
      DialogUtil.dismiss();
      if (!context.mounted) return;
      DialogUtil.snackBar(StringConfig.chapterNotFound);
      return;
    }
    delegate.chapters = updatedChapters;
    var targetIndex =
        min(controller.chapterIndex.value, updatedChapters.length - 1);
    controller.chapterIndex.value = targetIndex;
    controller.pageIndex.value = 0;
    controller.resetChapterBuffer();
    controller.currentChapterContent.value = '';
    controller.loadCurrentChapter();
    controller.preloadPreviousChapter();
    controller.preloadNextChapter();
    await ChapterService().destroyChapters(book.id);
    await ChapterService().addChapters(updatedChapters);
    var updatedBook = book.copyWith(
      catalogueUrl: delegate.catalogueUrl,
      chapterCount: updatedChapters.length,
      sourceId: sourceId,
    );
    await BookService().updateBook(updatedBook);
    DialogUtil.dismiss();
    await delegate.onLeave();
  }

  Future<void> navigateCataloguePage(BuildContext context) async {
    var currentState =
        book.copyWith(chapterIndex: controller.chapterIndex.value);
    var index = await CatalogueRoute(
      book: currentState,
      chapters: delegate.chapters,
    ).push<int>(context);
    if (index == null) return;
    await controller.jumpToChapter(index);
  }

  // --- Private helpers ---

  Future<void> _downloadChapter(
    SourceEntity source,
    int index,
    Semaphore semaphore,
  ) async {
    await semaphore.acquire();
    try {
      final url = delegate.chapters.elementAt(index).url;
      final network = CachedNetwork(prefix: book.name);
      final cached = await network.check(url);
      if (!cached) {
        await network.request(
          url,
          charset: source.charset,
          method: source.contentMethod,
        );
      }
      downloadSucceed.value++;
    } catch (e) {
      downloadFailed.value++;
    } finally {
      semaphore.release();
    }
  }
}
