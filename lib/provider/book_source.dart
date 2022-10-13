import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/book_source.dart';
import '../entity/rule.dart';

part 'book_source.freezed.dart';

@freezed
class BookSourceState with _$BookSourceState {
  const factory BookSourceState({
    required BookSource? bookSource,
    required List<BookSource>? bookSources,
    required bool importing,
    required List<Rule>? rules,
    required bool showBookSource,
  }) = _BookSourceState;
}

class BookSourceStateNotifier extends StateNotifier<BookSourceState> {
  BookSourceStateNotifier()
      : super(const BookSourceState(
          bookSource: null,
          bookSources: null,
          importing: false,
          rules: null,
          showBookSource: false,
        ));

  void updateBookSource(BookSource bookSource) {
    state = state.copyWith(bookSource: bookSource);
  }

  void updateBookSources(List<BookSource> bookSources) {
    state = state.copyWith(bookSources: bookSources);
  }

  void updateImporting(bool importing) {
    state = state.copyWith(importing: importing);
  }

  void updateRules(List<Rule> rules) {
    state = state.copyWith(rules: rules);
  }

  void updateShowBookSource(bool showBookSource) {
    state = state.copyWith(showBookSource: showBookSource);
  }
}

final bookSourceState =
    StateNotifierProvider<BookSourceStateNotifier, BookSourceState>(
        (ref) => BookSourceStateNotifier());
