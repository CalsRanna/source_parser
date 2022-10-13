// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SearchState {
  List<Book> get books => throw _privateConstructorUsedError;
  String? get credential => throw _privateConstructorUsedError;
  List<History> get searchHistories => throw _privateConstructorUsedError;
  bool get showSearchResult => throw _privateConstructorUsedError;
  List<Book> get topSearchBooks => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchStateCopyWith<SearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
          SearchState value, $Res Function(SearchState) then) =
      _$SearchStateCopyWithImpl<$Res>;
  $Res call(
      {List<Book> books,
      String? credential,
      List<History> searchHistories,
      bool showSearchResult,
      List<Book> topSearchBooks});
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res> implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  final SearchState _value;
  // ignore: unused_field
  final $Res Function(SearchState) _then;

  @override
  $Res call({
    Object? books = freezed,
    Object? credential = freezed,
    Object? searchHistories = freezed,
    Object? showSearchResult = freezed,
    Object? topSearchBooks = freezed,
  }) {
    return _then(_value.copyWith(
      books: books == freezed
          ? _value.books
          : books // ignore: cast_nullable_to_non_nullable
              as List<Book>,
      credential: credential == freezed
          ? _value.credential
          : credential // ignore: cast_nullable_to_non_nullable
              as String?,
      searchHistories: searchHistories == freezed
          ? _value.searchHistories
          : searchHistories // ignore: cast_nullable_to_non_nullable
              as List<History>,
      showSearchResult: showSearchResult == freezed
          ? _value.showSearchResult
          : showSearchResult // ignore: cast_nullable_to_non_nullable
              as bool,
      topSearchBooks: topSearchBooks == freezed
          ? _value.topSearchBooks
          : topSearchBooks // ignore: cast_nullable_to_non_nullable
              as List<Book>,
    ));
  }
}

/// @nodoc
abstract class _$$_SearchStateCopyWith<$Res>
    implements $SearchStateCopyWith<$Res> {
  factory _$$_SearchStateCopyWith(
          _$_SearchState value, $Res Function(_$_SearchState) then) =
      __$$_SearchStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<Book> books,
      String? credential,
      List<History> searchHistories,
      bool showSearchResult,
      List<Book> topSearchBooks});
}

/// @nodoc
class __$$_SearchStateCopyWithImpl<$Res> extends _$SearchStateCopyWithImpl<$Res>
    implements _$$_SearchStateCopyWith<$Res> {
  __$$_SearchStateCopyWithImpl(
      _$_SearchState _value, $Res Function(_$_SearchState) _then)
      : super(_value, (v) => _then(v as _$_SearchState));

  @override
  _$_SearchState get _value => super._value as _$_SearchState;

  @override
  $Res call({
    Object? books = freezed,
    Object? credential = freezed,
    Object? searchHistories = freezed,
    Object? showSearchResult = freezed,
    Object? topSearchBooks = freezed,
  }) {
    return _then(_$_SearchState(
      books: books == freezed
          ? _value._books
          : books // ignore: cast_nullable_to_non_nullable
              as List<Book>,
      credential: credential == freezed
          ? _value.credential
          : credential // ignore: cast_nullable_to_non_nullable
              as String?,
      searchHistories: searchHistories == freezed
          ? _value._searchHistories
          : searchHistories // ignore: cast_nullable_to_non_nullable
              as List<History>,
      showSearchResult: showSearchResult == freezed
          ? _value.showSearchResult
          : showSearchResult // ignore: cast_nullable_to_non_nullable
              as bool,
      topSearchBooks: topSearchBooks == freezed
          ? _value._topSearchBooks
          : topSearchBooks // ignore: cast_nullable_to_non_nullable
              as List<Book>,
    ));
  }
}

/// @nodoc

class _$_SearchState implements _SearchState {
  const _$_SearchState(
      {required final List<Book> books,
      required this.credential,
      required final List<History> searchHistories,
      required this.showSearchResult,
      required final List<Book> topSearchBooks})
      : _books = books,
        _searchHistories = searchHistories,
        _topSearchBooks = topSearchBooks;

  final List<Book> _books;
  @override
  List<Book> get books {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_books);
  }

  @override
  final String? credential;
  final List<History> _searchHistories;
  @override
  List<History> get searchHistories {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchHistories);
  }

  @override
  final bool showSearchResult;
  final List<Book> _topSearchBooks;
  @override
  List<Book> get topSearchBooks {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topSearchBooks);
  }

  @override
  String toString() {
    return 'SearchState(books: $books, credential: $credential, searchHistories: $searchHistories, showSearchResult: $showSearchResult, topSearchBooks: $topSearchBooks)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchState &&
            const DeepCollectionEquality().equals(other._books, _books) &&
            const DeepCollectionEquality()
                .equals(other.credential, credential) &&
            const DeepCollectionEquality()
                .equals(other._searchHistories, _searchHistories) &&
            const DeepCollectionEquality()
                .equals(other.showSearchResult, showSearchResult) &&
            const DeepCollectionEquality()
                .equals(other._topSearchBooks, _topSearchBooks));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_books),
      const DeepCollectionEquality().hash(credential),
      const DeepCollectionEquality().hash(_searchHistories),
      const DeepCollectionEquality().hash(showSearchResult),
      const DeepCollectionEquality().hash(_topSearchBooks));

  @JsonKey(ignore: true)
  @override
  _$$_SearchStateCopyWith<_$_SearchState> get copyWith =>
      __$$_SearchStateCopyWithImpl<_$_SearchState>(this, _$identity);
}

abstract class _SearchState implements SearchState {
  const factory _SearchState(
      {required final List<Book> books,
      required final String? credential,
      required final List<History> searchHistories,
      required final bool showSearchResult,
      required final List<Book> topSearchBooks}) = _$_SearchState;

  @override
  List<Book> get books;
  @override
  String? get credential;
  @override
  List<History> get searchHistories;
  @override
  bool get showSearchResult;
  @override
  List<Book> get topSearchBooks;
  @override
  @JsonKey(ignore: true)
  _$$_SearchStateCopyWith<_$_SearchState> get copyWith =>
      throw _privateConstructorUsedError;
}
