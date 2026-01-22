import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/cache_network.dart';

class AppBooksViewModel {
  final books = signal<List<Book>>([]);
  final loading = signal(false);
  Book? currentBook;

  Future<void> initSignals() async {
    loading.value = true;
    await _loadBooks();
    loading.value = false;
  }

  Future<void> _loadBooks() async {
    final loadedBooks = await isar.books.where().findAll();
    loadedBooks.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    books.value = loadedBooks;
  }

  Future<void> addBook(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.put(book);
    });
    await _loadBooks();
  }

  Future<void> deleteBook(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.delete(book.id);
    });
    CacheManager(prefix: book.name).clearCache();
    await _loadBooks();
  }

  Future<void> updateBook(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.put(book);
    });
    final index = books.value.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      final updatedBooks = [...books.value];
      updatedBooks[index] = book;
      books.value = updatedBooks;
    }
  }

  Future<Book?> getBookByName(String name) async {
    return await isar.books.filter().nameEqualTo(name).findFirst();
  }

  Future<Book?> getBook(int id) async {
    return await isar.books.filter().idEqualTo(id).findFirst();
  }

  Future<bool> checkIsInShelf(int id) async {
    final book = await isar.books.filter().idEqualTo(id).findFirst();
    return book != null;
  }

  void setCurrentBook(Book book) {
    currentBook = book;
  }

  Future<void> refreshCursor(int cursor) async {
    if (currentBook == null) return;
    currentBook = currentBook!.copyWith(cursor: cursor);
    await updateBook(currentBook!);
  }

  Future<void> refreshIndex(int index) async {
    if (currentBook == null) return;
    currentBook = currentBook!.copyWith(index: index);
    await updateBook(currentBook!);
  }

  Future<void> toggleArchive() async {
    if (currentBook == null) return;
    currentBook = currentBook!.copyWith(archive: !currentBook!.archive);
    await isar.writeTxn(() async {
      await isar.books.put(currentBook!);
    });
    await _loadBooks();
  }

  Future<String> getContent(int index) async {
    if (currentBook == null) return '';
    final chapter = currentBook!.chapters.elementAt(index);
    final title = chapter.name;
    final url = chapter.url;
    final source = await isar.sources
        .filter()
        .idEqualTo(currentBook!.sourceId)
        .findFirst();
    if (source == null) return '';
    final setting = await isar.settings.where().findFirst();
    final timeout = setting?.timeout ?? 30000;
    return _getContentFromSource(
      currentBook!.name,
      url,
      source,
      title,
      Duration(milliseconds: timeout),
    );
  }

  Future<String> _getContentFromSource(
    String name,
    String url,
    dynamic source,
    String title,
    Duration timeout,
  ) async {
    return '';
  }
}
