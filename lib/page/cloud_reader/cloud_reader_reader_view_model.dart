import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/component/reader/reader_controller.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_delegate.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/dialog_util.dart';

class CloudReaderReaderViewModel {
  final CloudBookEntity book;
  late final CloudReaderDelegate delegate;
  late final ReaderController controller;

  CloudReaderReaderViewModel({required this.book}) {
    delegate = CloudReaderDelegate(book: book);
    controller = ReaderController(
      delegate: delegate,
      initialPageIndex: book.durChapterPos,
      progressDebounceDuration: const Duration(seconds: 3),
    );
  }

  // --- 生命周期 ---

  Future<void> initSignals() async {
    await controller.init();
  }

  Future<void> syncProgress() async {
    await delegate.syncProgress(
      controller.chapterIndex.value,
      controller.pageIndex.value,
    );
  }

  // --- 云端特有功能 ---

  Future<void> navigateCataloguePage(BuildContext context) async {
    var index = await CloudReaderCatalogueRoute(
      bookUrl: book.bookUrl,
      currentIndex: controller.chapterIndex.value,
    ).push<int>(context);
    if (index == null) return;
    await controller.jumpToChapter(index);
  }

  Future<void> navigateSourcePage(BuildContext context) async {
    var newBookUrl = await CloudReaderSourceRoute(
      bookUrl: book.bookUrl,
      currentOrigin: book.origin,
    ).push<String>(context);
    if (newBookUrl == null) return;
    controller.clearLayoutCache();
    DialogUtil.loading();
    controller.isRotating = true;
    controller.currentChapterContent.value = '';
    controller.resetChapterBuffer();
    controller.error.value = '';
    await delegate.switchSource(newBookUrl);
    controller.chapterIndex.value = 0;
    controller.pageIndex.value = 0;
    await controller.loadCurrentChapter();
    controller.preloadPreviousChapter();
    controller.preloadNextChapter();
    DialogUtil.dismiss();
  }
}
