import 'package:lpinyin/lpinyin.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/util/cache_network.dart';

class AppBooksViewModel {
  final books = signal<List<BookEntity>>([]);
  final loading = signal(false);
  BookEntity? currentBook;
  final _bookService = BookService();

  Future<void> initSignals() async {
    loading.value = true;
    await _loadBooks();
    loading.value = false;
  }

  Future<void> _loadBooks() async {
    final loadedBooks = await _bookService.getBooks();
    loadedBooks.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    books.value = loadedBooks;
  }

  Future<void> addBook(BookEntity book) async {
    await _bookService.addBook(book);
    await _loadBooks();
  }

  Future<void> deleteBook(BookEntity book) async {
    await _bookService.destroyBook(book.id);
    CacheManager(prefix: book.name).clearCache();
    await _loadBooks();
  }

  Future<void> updateBook(BookEntity book) async {
    await _bookService.updateBook(book);
    final index = books.value.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      final updatedBooks = [...books.value];
      updatedBooks[index] = book;
      books.value = updatedBooks;
    }
  }

  Future<BookEntity?> getBookByName(String name) async {
    try {
      return await _bookService.getBookByName(name);
    } catch (e) {
      return null;
    }
  }

  Future<BookEntity?> getBook(int id) async {
    try {
      return await _bookService.getBook(id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkIsInShelf(int id) async {
    return await _bookService.checkIsInShelf(id);
  }

  void setCurrentBook(BookEntity book) {
    currentBook = book;
  }

  Future<void> refreshCursor(int cursor) async {
    if (currentBook == null) return;
    currentBook = currentBook!.copyWith(pageIndex: cursor);
    await updateBook(currentBook!);
  }

  Future<void> refreshIndex(int index) async {
    if (currentBook == null) return;
    currentBook = currentBook!.copyWith(chapterIndex: index);
    await updateBook(currentBook!);
  }

  Future<void> toggleArchive() async {
    if (currentBook == null) return;
    currentBook = currentBook!.copyWith(archive: !currentBook!.archive);
    await updateBook(currentBook!);
    await _loadBooks();
  }

  Future<String> getContent(int index) async {
    if (currentBook == null) return '';
    // TODO: Implement content fetching using chapter service
    return '';
  }
}
