import 'package:signals/signals.dart';
import 'package:source_parser/database/book_cover_service.dart';
import 'package:source_parser/model/book_cover_entity.dart';

class CoverSelectorViewModel {
  final int bookId;

  CoverSelectorViewModel(this.bookId);

  final isLoading = signal(true);
  final covers = signal(<BookCoverEntity>[]);

  Future<void> initSignals() async {
    covers.value = await BookCoverService().getBookCovers(bookId);
    isLoading.value = false;
  }
}
