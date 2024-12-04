// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readerStateNotifierHash() =>
    r'338c368931f0dda94687d567c4be5500584c150e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ReaderStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ReaderState> {
  late final Book book;

  FutureOr<ReaderState> build(
    Book book,
  );
}

/// See also [ReaderStateNotifier].
@ProviderFor(ReaderStateNotifier)
const readerStateNotifierProvider = ReaderStateNotifierFamily();

/// See also [ReaderStateNotifier].
class ReaderStateNotifierFamily extends Family<AsyncValue<ReaderState>> {
  /// See also [ReaderStateNotifier].
  const ReaderStateNotifierFamily();

  /// See also [ReaderStateNotifier].
  ReaderStateNotifierProvider call(
    Book book,
  ) {
    return ReaderStateNotifierProvider(
      book,
    );
  }

  @override
  ReaderStateNotifierProvider getProviderOverride(
    covariant ReaderStateNotifierProvider provider,
  ) {
    return call(
      provider.book,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'readerStateNotifierProvider';
}

/// See also [ReaderStateNotifier].
class ReaderStateNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ReaderStateNotifier, ReaderState> {
  /// See also [ReaderStateNotifier].
  ReaderStateNotifierProvider(
    Book book,
  ) : this._internal(
          () => ReaderStateNotifier()..book = book,
          from: readerStateNotifierProvider,
          name: r'readerStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$readerStateNotifierHash,
          dependencies: ReaderStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              ReaderStateNotifierFamily._allTransitiveDependencies,
          book: book,
        );

  ReaderStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.book,
  }) : super.internal();

  final Book book;

  @override
  FutureOr<ReaderState> runNotifierBuild(
    covariant ReaderStateNotifier notifier,
  ) {
    return notifier.build(
      book,
    );
  }

  @override
  Override overrideWith(ReaderStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReaderStateNotifierProvider._internal(
        () => create()..book = book,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        book: book,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ReaderStateNotifier, ReaderState>
      createElement() {
    return _ReaderStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReaderStateNotifierProvider && other.book == book;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, book.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReaderStateNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<ReaderState> {
  /// The parameter `book` of this provider.
  Book get book;
}

class _ReaderStateNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ReaderStateNotifier,
        ReaderState> with ReaderStateNotifierRef {
  _ReaderStateNotifierProviderElement(super.provider);

  @override
  Book get book => (origin as ReaderStateNotifierProvider).book;
}

String _$readerThemeNotifierHash() =>
    r'b38aa28156332e3864033adf9559017df5ca2694';

/// See also [ReaderThemeNotifier].
@ProviderFor(ReaderThemeNotifier)
final readerThemeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ReaderThemeNotifier, ReaderTheme>.internal(
  ReaderThemeNotifier.new,
  name: r'readerThemeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$readerThemeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReaderThemeNotifier = AutoDisposeAsyncNotifier<ReaderTheme>;
String _$readerSizeNotifierHash() =>
    r'792abc9cdb2d8ed167dcd9a1f53ee70350b07d85';

/// See also [ReaderSizeNotifier].
@ProviderFor(ReaderSizeNotifier)
final readerSizeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ReaderSizeNotifier, Size>.internal(
  ReaderSizeNotifier.new,
  name: r'readerSizeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$readerSizeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReaderSizeNotifier = AutoDisposeAsyncNotifier<Size>;
String _$mediaQueryDataNotifierHash() =>
    r'0d1658c27689a07d02ea6054d8fe7dcd16afd409';

/// See also [MediaQueryDataNotifier].
@ProviderFor(MediaQueryDataNotifier)
final mediaQueryDataNotifierProvider =
    NotifierProvider<MediaQueryDataNotifier, MediaQueryData>.internal(
  MediaQueryDataNotifier.new,
  name: r'mediaQueryDataNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mediaQueryDataNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MediaQueryDataNotifier = Notifier<MediaQueryData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package