import 'package:signals/signals.dart';
import 'package:source_parser/database/cover_service.dart';
import 'package:source_parser/model/cover_entity.dart';

class CoverSelectorViewModel {
  final int bookId;

  CoverSelectorViewModel(this.bookId);

  final isLoading = signal(true);
  final covers = signal(<CoverEntity>[]);

  Future<void> initSignals() async {
    covers.value = await CoverService().getCovers(bookId);
    isLoading.value = false;
  }
}
