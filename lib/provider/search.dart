import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/book.dart';
import '../entity/history.dart';

part 'search.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required List<Book> books,
    required String? credential,
    required List<History> searchHistories,
    required bool showSearchResult,
    required List<Book> topSearchBooks,
  }) = _SearchState;
}

class SearchStateNotifier extends StateNotifier<SearchState> {
  SearchStateNotifier()
      : super(const SearchState(
          books: [],
          credential: null,
          searchHistories: [],
          showSearchResult: false,
          topSearchBooks: [],
        ));

  void updateBooks(List<Book> books) {
    state = state.copyWith(books: books);
  }

  void updateCredential(String? credential) {
    state = state.copyWith(credential: credential);
  }

  void updateTopSearchBooks(List<Book> books) {
    state = state.copyWith(topSearchBooks: books);
  }

  void updateShowSearchResult(bool showSearchResult) {
    state = state.copyWith(showSearchResult: showSearchResult);
  }
}

final searchState = StateNotifierProvider<SearchStateNotifier, SearchState>(
    (ref) => SearchStateNotifier());
