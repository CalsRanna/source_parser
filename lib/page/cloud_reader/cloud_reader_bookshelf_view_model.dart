import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/cloud_available_source_service.dart';
import 'package:source_parser/database/cloud_book_service.dart';
import 'package:source_parser/database/cloud_chapter_service.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/model/cloud_chapter_entity.dart';
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
      var client = CloudReaderApiClient();
      await client.loadConfig();
      var remoteBooks = await client.getBookshelf();
      var remoteUrls = remoteBooks.map((b) => b.bookUrl).toSet();
      var localBooks = await CloudBookService().getBooks();
      var localUrls = localBooks.map((b) => b.bookUrl).toSet();
      var localMap = {for (var b in localBooks) b.bookUrl: b};
      // Preserve local page position
      for (var remote in remoteBooks) {
        remote.durChapterPos = localMap[remote.bookUrl]?.durChapterPos ?? 0;
      }
      // Batch upsert remote books
      await CloudBookService().upsertBooks(remoteBooks);
      // Fetch book info and chapter list concurrently
      var futures = remoteBooks.map((remote) async {
        try {
          var results = await Future.wait([
            client.getBookInfo(remote.bookUrl, reacquire: true),
            client.getChapterList(remote.bookUrl, reacquire: true),
          ]);
          var info = results[0] as CloudBookEntity;
          info.durChapterPos = remote.durChapterPos;
          var chapters = results[1] as List<CloudChapterEntity>;
          return (bookUrl: remote.bookUrl, info: info, chapters: chapters);
        } catch (e) {
          logger.e('刷新书籍详情失败: ${remote.name}, $e');
          return null;
        }
      });
      var results = await Future.wait(futures);
      var infosToUpsert = <CloudBookEntity>[];
      var chaptersMap = <String, List<CloudChapterEntity>>{};
      for (var result in results) {
        if (result == null) continue;
        infosToUpsert.add(result.info);
        chaptersMap[result.bookUrl] = result.chapters;
      }
      // Batch write book info and chapters
      await CloudBookService().upsertBooks(infosToUpsert);
      await CloudChapterService().replaceMultipleChapters(chaptersMap);
      // Batch delete local books not on server
      var removedUrls = localUrls.difference(remoteUrls).toList();
      if (removedUrls.isNotEmpty) {
        await CloudBookService().deleteBooks(removedUrls);
        await CloudChapterService().deleteMultipleChapters(removedUrls);
        await CloudAvailableSourceService().deleteMultipleSources(removedUrls);
        for (var url in removedUrls) {
          var localBook = localMap[url];
          if (localBook != null) {
            await CacheManager(prefix: localBook.name).clearCache();
          }
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
