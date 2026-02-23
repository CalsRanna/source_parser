import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/cloud_available_source_service.dart';
import 'package:source_parser/database/cloud_book_service.dart';
import 'package:source_parser/database/cloud_chapter_service.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class CloudReaderBookshelfViewModel {
  final books = signal<List<CloudBookEntity>>([]);
  final isLoading = signal(false);
  final isSyncing = signal(false);
  final error = signal('');
  final shelfMode = signal('list');

  Future<void> initSignals() async {
    isLoading.value = true;
    error.value = '';
    try {
      shelfMode.value = await SharedPreferenceUtil.getCloudReaderShelfMode();
      books.value = await CloudBookService().getBooks();
    } catch (e) {
      logger.e('加载本地书籍失败: $e');
    }
    isLoading.value = false;
    _syncFromServer();
  }

  Future<void> _syncFromServer() async {
    isSyncing.value = true;
    try {
      await CloudReaderApiClient().loadConfig();
      var remoteBooks = await CloudReaderApiClient().getBookshelf();
      var remoteUrls = remoteBooks.map((b) => b.bookUrl).toSet();
      var localBooks = await CloudBookService().getBooks();
      var localUrls = localBooks.map((b) => b.bookUrl).toSet();
      // Upsert remote books, use server progress but keep local page position
      for (var remote in remoteBooks) {
        var local = localBooks.where((b) => b.bookUrl == remote.bookUrl);
        if (local.isNotEmpty) {
          remote.durChapterPos = local.first.durChapterPos;
        } else {
          remote.durChapterPos = 0;
        }
        await CloudBookService().upsertBook(remote);
      }
      // Delete local books not on server
      for (var localUrl in localUrls) {
        if (!remoteUrls.contains(localUrl)) {
          var localBook = localBooks.firstWhere((b) => b.bookUrl == localUrl);
          await CloudBookService().deleteBook(localUrl);
          await CloudChapterService().deleteChapters(localUrl);
          await CloudAvailableSourceService().deleteSources(localUrl);
          await CacheManager(prefix: localBook.name).clearCache();
        }
      }
      books.value = await CloudBookService().getBooks();
    } catch (e) {
      logger.e('同步书架失败: $e');
      if (books.value.isEmpty) {
        error.value = '同步失败: $e';
      }
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> updateShelfMode(String mode) async {
    shelfMode.value = mode;
    await SharedPreferenceUtil.setCloudReaderShelfMode(mode);
  }

  Future<void> refreshBooks() async {
    await initSignals();
  }

  Future<void> deleteBook(int index) async {
    try {
      var book = books.value[index];
      await CloudReaderApiClient().deleteBook(book);
      await CloudBookService().deleteBook(book.bookUrl);
      await CloudChapterService().deleteChapters(book.bookUrl);
      await CloudAvailableSourceService().deleteSources(book.bookUrl);
      await CacheManager(prefix: book.name).clearCache();
      books.value = List.from(books.value)..removeAt(index);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> openReader(BuildContext context, int index) async {
    var book = books.value[index];
    await CloudReaderReaderRoute(book: book).push(context);
    books.value = await CloudBookService().getBooks();
  }

  Future<void> openSearch(BuildContext context) async {
    await CloudReaderSearchRoute().push(context);
    await refreshBooks();
  }
}
