// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'global.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GlobalState {
  int get color => throw _privateConstructorUsedError;
  AppDatabase? get database => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GlobalStateCopyWith<GlobalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalStateCopyWith<$Res> {
  factory $GlobalStateCopyWith(
          GlobalState value, $Res Function(GlobalState) then) =
      _$GlobalStateCopyWithImpl<$Res>;
  $Res call({int color, AppDatabase? database, int index});
}

/// @nodoc
class _$GlobalStateCopyWithImpl<$Res> implements $GlobalStateCopyWith<$Res> {
  _$GlobalStateCopyWithImpl(this._value, this._then);

  final GlobalState _value;
  // ignore: unused_field
  final $Res Function(GlobalState) _then;

  @override
  $Res call({
    Object? color = freezed,
    Object? database = freezed,
    Object? index = freezed,
  }) {
    return _then(_value.copyWith(
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      database: database == freezed
          ? _value.database
          : database // ignore: cast_nullable_to_non_nullable
              as AppDatabase?,
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_GlobalStateCopyWith<$Res>
    implements $GlobalStateCopyWith<$Res> {
  factory _$$_GlobalStateCopyWith(
          _$_GlobalState value, $Res Function(_$_GlobalState) then) =
      __$$_GlobalStateCopyWithImpl<$Res>;
  @override
  $Res call({int color, AppDatabase? database, int index});
}

/// @nodoc
class __$$_GlobalStateCopyWithImpl<$Res> extends _$GlobalStateCopyWithImpl<$Res>
    implements _$$_GlobalStateCopyWith<$Res> {
  __$$_GlobalStateCopyWithImpl(
      _$_GlobalState _value, $Res Function(_$_GlobalState) _then)
      : super(_value, (v) => _then(v as _$_GlobalState));

  @override
  _$_GlobalState get _value => super._value as _$_GlobalState;

  @override
  $Res call({
    Object? color = freezed,
    Object? database = freezed,
    Object? index = freezed,
  }) {
    return _then(_$_GlobalState(
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      database: database == freezed
          ? _value.database
          : database // ignore: cast_nullable_to_non_nullable
              as AppDatabase?,
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_GlobalState implements _GlobalState {
  const _$_GlobalState(
      {required this.color, required this.database, required this.index});

  @override
  final int color;
  @override
  final AppDatabase? database;
  @override
  final int index;

  @override
  String toString() {
    return 'GlobalState(color: $color, database: $database, index: $index)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GlobalState &&
            const DeepCollectionEquality().equals(other.color, color) &&
            const DeepCollectionEquality().equals(other.database, database) &&
            const DeepCollectionEquality().equals(other.index, index));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(color),
      const DeepCollectionEquality().hash(database),
      const DeepCollectionEquality().hash(index));

  @JsonKey(ignore: true)
  @override
  _$$_GlobalStateCopyWith<_$_GlobalState> get copyWith =>
      __$$_GlobalStateCopyWithImpl<_$_GlobalState>(this, _$identity);
}

abstract class _GlobalState implements GlobalState {
  const factory _GlobalState(
      {required final int color,
      required final AppDatabase? database,
      required final int index}) = _$_GlobalState;

  @override
  int get color;
  @override
  AppDatabase? get database;
  @override
  int get index;
  @override
  @JsonKey(ignore: true)
  _$$_GlobalStateCopyWith<_$_GlobalState> get copyWith =>
      throw _privateConstructorUsedError;
}
