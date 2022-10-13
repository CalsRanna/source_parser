// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'book_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BookSourceState {
  BookSource? get bookSource => throw _privateConstructorUsedError;
  List<BookSource>? get bookSources => throw _privateConstructorUsedError;
  bool get importing => throw _privateConstructorUsedError;
  List<Rule>? get rules => throw _privateConstructorUsedError;
  bool get showBookSource => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookSourceStateCopyWith<BookSourceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookSourceStateCopyWith<$Res> {
  factory $BookSourceStateCopyWith(
          BookSourceState value, $Res Function(BookSourceState) then) =
      _$BookSourceStateCopyWithImpl<$Res>;
  $Res call(
      {BookSource? bookSource,
      List<BookSource>? bookSources,
      bool importing,
      List<Rule>? rules,
      bool showBookSource});
}

/// @nodoc
class _$BookSourceStateCopyWithImpl<$Res>
    implements $BookSourceStateCopyWith<$Res> {
  _$BookSourceStateCopyWithImpl(this._value, this._then);

  final BookSourceState _value;
  // ignore: unused_field
  final $Res Function(BookSourceState) _then;

  @override
  $Res call({
    Object? bookSource = freezed,
    Object? bookSources = freezed,
    Object? importing = freezed,
    Object? rules = freezed,
    Object? showBookSource = freezed,
  }) {
    return _then(_value.copyWith(
      bookSource: bookSource == freezed
          ? _value.bookSource
          : bookSource // ignore: cast_nullable_to_non_nullable
              as BookSource?,
      bookSources: bookSources == freezed
          ? _value.bookSources
          : bookSources // ignore: cast_nullable_to_non_nullable
              as List<BookSource>?,
      importing: importing == freezed
          ? _value.importing
          : importing // ignore: cast_nullable_to_non_nullable
              as bool,
      rules: rules == freezed
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<Rule>?,
      showBookSource: showBookSource == freezed
          ? _value.showBookSource
          : showBookSource // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_BookSourceStateCopyWith<$Res>
    implements $BookSourceStateCopyWith<$Res> {
  factory _$$_BookSourceStateCopyWith(
          _$_BookSourceState value, $Res Function(_$_BookSourceState) then) =
      __$$_BookSourceStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {BookSource? bookSource,
      List<BookSource>? bookSources,
      bool importing,
      List<Rule>? rules,
      bool showBookSource});
}

/// @nodoc
class __$$_BookSourceStateCopyWithImpl<$Res>
    extends _$BookSourceStateCopyWithImpl<$Res>
    implements _$$_BookSourceStateCopyWith<$Res> {
  __$$_BookSourceStateCopyWithImpl(
      _$_BookSourceState _value, $Res Function(_$_BookSourceState) _then)
      : super(_value, (v) => _then(v as _$_BookSourceState));

  @override
  _$_BookSourceState get _value => super._value as _$_BookSourceState;

  @override
  $Res call({
    Object? bookSource = freezed,
    Object? bookSources = freezed,
    Object? importing = freezed,
    Object? rules = freezed,
    Object? showBookSource = freezed,
  }) {
    return _then(_$_BookSourceState(
      bookSource: bookSource == freezed
          ? _value.bookSource
          : bookSource // ignore: cast_nullable_to_non_nullable
              as BookSource?,
      bookSources: bookSources == freezed
          ? _value._bookSources
          : bookSources // ignore: cast_nullable_to_non_nullable
              as List<BookSource>?,
      importing: importing == freezed
          ? _value.importing
          : importing // ignore: cast_nullable_to_non_nullable
              as bool,
      rules: rules == freezed
          ? _value._rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<Rule>?,
      showBookSource: showBookSource == freezed
          ? _value.showBookSource
          : showBookSource // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_BookSourceState implements _BookSourceState {
  const _$_BookSourceState(
      {required this.bookSource,
      required final List<BookSource>? bookSources,
      required this.importing,
      required final List<Rule>? rules,
      required this.showBookSource})
      : _bookSources = bookSources,
        _rules = rules;

  @override
  final BookSource? bookSource;
  final List<BookSource>? _bookSources;
  @override
  List<BookSource>? get bookSources {
    final value = _bookSources;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool importing;
  final List<Rule>? _rules;
  @override
  List<Rule>? get rules {
    final value = _rules;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool showBookSource;

  @override
  String toString() {
    return 'BookSourceState(bookSource: $bookSource, bookSources: $bookSources, importing: $importing, rules: $rules, showBookSource: $showBookSource)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BookSourceState &&
            const DeepCollectionEquality()
                .equals(other.bookSource, bookSource) &&
            const DeepCollectionEquality()
                .equals(other._bookSources, _bookSources) &&
            const DeepCollectionEquality().equals(other.importing, importing) &&
            const DeepCollectionEquality().equals(other._rules, _rules) &&
            const DeepCollectionEquality()
                .equals(other.showBookSource, showBookSource));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(bookSource),
      const DeepCollectionEquality().hash(_bookSources),
      const DeepCollectionEquality().hash(importing),
      const DeepCollectionEquality().hash(_rules),
      const DeepCollectionEquality().hash(showBookSource));

  @JsonKey(ignore: true)
  @override
  _$$_BookSourceStateCopyWith<_$_BookSourceState> get copyWith =>
      __$$_BookSourceStateCopyWithImpl<_$_BookSourceState>(this, _$identity);
}

abstract class _BookSourceState implements BookSourceState {
  const factory _BookSourceState(
      {required final BookSource? bookSource,
      required final List<BookSource>? bookSources,
      required final bool importing,
      required final List<Rule>? rules,
      required final bool showBookSource}) = _$_BookSourceState;

  @override
  BookSource? get bookSource;
  @override
  List<BookSource>? get bookSources;
  @override
  bool get importing;
  @override
  List<Rule>? get rules;
  @override
  bool get showBookSource;
  @override
  @JsonKey(ignore: true)
  _$$_BookSourceStateCopyWith<_$_BookSourceState> get copyWith =>
      throw _privateConstructorUsedError;
}
