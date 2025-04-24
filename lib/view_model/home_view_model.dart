import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/model/book_entity.dart';

class HomeViewModel {
  final controller = PageController();
  final index = signal(0);
  final books = signal(<BookEntity>[]);

  Future<void> initSignals() async {
    books.value = await BookService().getBooks();
    FlutterNativeSplash.remove();
  }

  void changePage(int page) {
    index.value = page;
  }

  void selectDestination(int index) {
    controller.jumpToPage(index);
    this.index.value = index;
  }

  Future<void> destroyBook(BookEntity book) async {
    await BookService().destroyBook(book);
    books.value = await BookService().getBooks();
  }

  void dispose() {
    controller.dispose();
  }
}
