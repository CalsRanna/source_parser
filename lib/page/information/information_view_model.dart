import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';

class InformationViewModel {
  final int bookId;
  InformationViewModel(this.bookId);

  final isInShelf = signal(false);

  Future<void> initSignals() async {
    isInShelf.value = await BookService().getIsInShelf(bookId);
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
}
