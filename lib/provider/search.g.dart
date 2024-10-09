// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$topSearchBooksHash() => r'c66d47da727a20a8b639abdad64a7a154cdfecf0';

/// See also [TopSearchBooks].
@ProviderFor(TopSearchBooks)
final topSearchBooksProvider =
    AutoDisposeAsyncNotifierProvider<TopSearchBooks, List<Book>>.internal(
  TopSearchBooks.new,
  name: r'topSearchBooksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$topSearchBooksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TopSearchBooks = AutoDisposeAsyncNotifier<List<Book>>;
String _$searchBooksHash() => r'2e02695832464ea944ed8ab36009dc9670e889c4';

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

abstract class _$SearchBooks
    extends BuildlessAutoDisposeAsyncNotifier<Stream<List<Book>>> {
  late final String credential;

  FutureOr<Stream<List<Book>>> build(
    String credential,
  );
}

/// See also [SearchBooks].
@ProviderFor(SearchBooks)
const searchBooksProvider = SearchBooksFamily();

/// See also [SearchBooks].
class SearchBooksFamily extends Family<AsyncValue<Stream<List<Book>>>> {
  /// See also [SearchBooks].
  const SearchBooksFamily();

  /// See also [SearchBooks].
  SearchBooksProvider call(
    String credential,
  ) {
    return SearchBooksProvider(
      credential,
    );
  }

  @override
  SearchBooksProvider getProviderOverride(
    covariant SearchBooksProvider provider,
  ) {
    return call(
      provider.credential,
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
  String? get name => r'searchBooksProvider';
}

/// See also [SearchBooks].
class SearchBooksProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SearchBooks, Stream<List<Book>>> {
  /// See also [SearchBooks].
  SearchBooksProvider(
    String credential,
  ) : this._internal(
          () => SearchBooks()..credential = credential,
          from: searchBooksProvider,
          name: r'searchBooksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchBooksHash,
          dependencies: SearchBooksFamily._dependencies,
          allTransitiveDependencies:
              SearchBooksFamily._allTransitiveDependencies,
          credential: credential,
        );

  SearchBooksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.credential,
  }) : super.internal();

  final String credential;

  @override
  FutureOr<Stream<List<Book>>> runNotifierBuild(
    covariant SearchBooks notifier,
  ) {
    return notifier.build(
      credential,
    );
  }

  @override
  Override overrideWith(SearchBooks Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchBooksProvider._internal(
        () => create()..credential = credential,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        credential: credential,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SearchBooks, Stream<List<Book>>>
      createElement() {
    return _SearchBooksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchBooksProvider && other.credential == credential;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, credential.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchBooksRef
    on AutoDisposeAsyncNotifierProviderRef<Stream<List<Book>>> {
  /// The parameter `credential` of this provider.
  String get credential;
}

class _SearchBooksProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SearchBooks,
        Stream<List<Book>>> with SearchBooksRef {
  _SearchBooksProviderElement(super.provider);

  @override
  String get credential => (origin as SearchBooksProvider).credential;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
