import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class CloudReaderBookshelfViewModel {
  final books = signal<List<CloudBookEntity>>([]);
  final isLoading = signal(false);
  final error = signal('');
  final shelfMode = signal('list');

  Future<void> initSignals() async {
    isLoading.value = true;
    error.value = '';
    try {
      shelfMode.value = await SharedPreferenceUtil.getCloudReaderShelfMode();
      await CloudReaderApiClient().loadConfig();
      books.value = await CloudReaderApiClient().getBookshelf();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
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
      books.value = List.from(books.value)..removeAt(index);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> openReader(BuildContext context, int index) async {
    var book = books.value[index];
    await CloudReaderReaderRoute(book: book).push(context);
    refreshBooks();
  }

  void openSearch(BuildContext context) {
    CloudReaderSearchRoute().push(context);
  }
}
