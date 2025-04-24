import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/model/book_entity.dart';

class BookshelfViewModel {
  final books = signal(<BookEntity>[]);

  Future<void> destroyBook(BookEntity book) async {
    await BookService().destroyBook(book);
    books.value = await BookService().getBooks();
  }

  Future<void> initSignals() async {
    books.value = await BookService().getBooks();
    FlutterNativeSplash.remove();
  }
}
