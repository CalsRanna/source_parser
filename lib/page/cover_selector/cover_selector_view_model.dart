import 'package:signals/signals.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/cover_service.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/cover_entity.dart';
import 'package:source_parser/util/parser_util.dart';

class CoverSelectorViewModel {
  final book = signal(BookEntity());

  final isLoading = signal(true);
  final covers = signal(<CoverEntity>[]);

  Future<void> initSignals(BookEntity book) async {
    this.book.value = book;
    covers.value = await CoverService().getCovers(this.book.value.id);
    isLoading.value = false;
  }

  Future<void> refreshCovers() async {
    covers.value.clear();
    var stream = ParserUtil.instance.getCovers(book.value);
    await for (var cover in stream) {
      covers.value = [...covers.value, cover];
    }
    var isInShelf = await BookService().checkIsInShelf(book.value.id);
    if (isInShelf) {
      for (var cover in covers.value) {
        var exist = await CoverService().exist(cover.url);
        if (exist) {
          await CoverService().updateCover(cover);
        } else {
          await CoverService().addCover(cover);
        }
      }
    }
  }
}
