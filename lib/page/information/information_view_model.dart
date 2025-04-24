import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
// import 'package:source_parser/router/router.gr.dart';

class InformationViewModel {
  final int bookId;
  final isInShelf = signal(false);
  final currentSource = signal(AvailableSourceEntity());

  InformationViewModel(this.bookId);

  void navigateAvailableSourcePage(BuildContext context) {
    // AvailableSourceListRoute().push(context);
  }

  Future<void> changeIsInShelf(BookEntity book) async {
    isInShelf.value = !isInShelf.value;
    var bookshelfViewModel = GetIt.instance<BookshelfViewModel>();
    if (isInShelf.value) {
      bookshelfViewModel.books.value.add(book);
      await BookService().addToBookshelf(book);
    } else {
      bookshelfViewModel.books.value.removeWhere((item) => item.id == book.id);
      await BookService().removeFromBookshelf(book.id);
    }
  }

  Future<void> initSignals() async {
    isInShelf.value = await BookService().getIsInShelf(bookId);
    try {
      var book = await BookService().getBook(bookId);
      currentSource.value = await AvailableSourceService()
          .getAvailableSource(book.availableSourceId);
    } catch (error) {
      currentSource.value = AvailableSourceEntity();
    }
  }
}
