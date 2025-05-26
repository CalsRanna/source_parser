import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_book_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_service.dart';
import 'package:source_parser/router/router.gr.dart';

class CloudReaderViewModel {
  final books = signal<List<CloudReaderBookEntity>>([]);
  Future<void> initSignals() async {
    books.value = await CloudReaderService().getBooksInShelf();
  }

  Future<void> openBook(BuildContext context, int index) async {
    var book = BookEntity.fromJson(books.value[index].toJson());
    ReaderRoute(book: book).push(context);
  }
}
