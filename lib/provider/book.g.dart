// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookNotifierHash() => r'6d12e199fb8395f1393e9e2da4f7f3721ee478d3';

/// See also [BookNotifier].
@ProviderFor(BookNotifier)
final bookNotifierProvider = NotifierProvider<BookNotifier, Book>.internal(
  BookNotifier.new,
  name: r'bookNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BookNotifier = Notifier<Book>;
String _$bookCoversHash() => r'8b6dc3f7513f41076764958af04c2c583ac0175b';

/// See also [BookCovers].
@ProviderFor(BookCovers)
final bookCoversProvider =
    AutoDisposeAsyncNotifierProvider<BookCovers, List<String>>.internal(
  BookCovers.new,
  name: r'bookCoversProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookCoversHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BookCovers = AutoDisposeAsyncNotifier<List<String>>;
String _$booksHash() => r'903cc4c0f23b0268e6470a53b2b0651faaf1cc8f';

/// See also [Books].
@ProviderFor(Books)
final booksProvider =
    AutoDisposeAsyncNotifierProvider<Books, List<Book>>.internal(
  Books.new,
  name: r'booksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$booksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Books = AutoDisposeAsyncNotifier<List<Book>>;
String _$inShelfHash() => r'4d4123c5dfa09dfb00ac3031f9d588960fb90da4';

/// See also [InShelf].
@ProviderFor(InShelf)
final inShelfProvider =
    AutoDisposeAsyncNotifierProvider<InShelf, bool>.internal(
  InShelf.new,
  name: r'inShelfProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$inShelfHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InShelf = AutoDisposeAsyncNotifier<bool>;
String _$searchLoadingHash() => r'8b80255cb8d4fa83254a22839ab671bb043d0276';

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

abstract class _$SearchLoading extends BuildlessAutoDisposeNotifier<bool> {
  late final String credential;

  bool build(
    String credential,
  );
}

/// See also [SearchLoading].
@ProviderFor(SearchLoading)
const searchLoadingProvider = SearchLoadingFamily();

/// See also [SearchLoading].
class SearchLoadingFamily extends Family<bool> {
  /// See also [SearchLoading].
  const SearchLoadingFamily();

  /// See also [SearchLoading].
  SearchLoadingProvider call(
    String credential,
  ) {
    return SearchLoadingProvider(
      credential,
    );
  }

  @override
  SearchLoadingProvider getProviderOverride(
    covariant SearchLoadingProvider provider,
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
  String? get name => r'searchLoadingProvider';
}

/// See also [SearchLoading].
class SearchLoadingProvider
    extends AutoDisposeNotifierProviderImpl<SearchLoading, bool> {
  /// See also [SearchLoading].
  SearchLoadingProvider(
    String credential,
  ) : this._internal(
          () => SearchLoading()..credential = credential,
          from: searchLoadingProvider,
          name: r'searchLoadingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchLoadingHash,
          dependencies: SearchLoadingFamily._dependencies,
          allTransitiveDependencies:
              SearchLoadingFamily._allTransitiveDependencies,
          credential: credential,
        );

  SearchLoadingProvider._internal(
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
  bool runNotifierBuild(
    covariant SearchLoading notifier,
  ) {
    return notifier.build(
      credential,
    );
  }

  @override
  Override overrideWith(SearchLoading Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchLoadingProvider._internal(
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
  AutoDisposeNotifierProviderElement<SearchLoading, bool> createElement() {
    return _SearchLoadingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchLoadingProvider && other.credential == credential;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, credential.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchLoadingRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `credential` of this provider.
  String get credential;
}

class _SearchLoadingProviderElement
    extends AutoDisposeNotifierProviderElement<SearchLoading, bool>
    with SearchLoadingRef {
  _SearchLoadingProviderElement(super.provider);

  @override
  String get credential => (origin as SearchLoadingProvider).credential;
}

String _$searchBooksHash() => r'84873fd91b453277921a8bbce8b649471f3ec9ba';

abstract class _$SearchBooks extends BuildlessAutoDisposeNotifier<List<Book>> {
  late final String credential;

  List<Book> build(
    String credential,
  );
}

/// See also [SearchBooks].
@ProviderFor(SearchBooks)
const searchBooksProvider = SearchBooksFamily();

/// See also [SearchBooks].
class SearchBooksFamily extends Family<List<Book>> {
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
class SearchBooksProvider
    extends AutoDisposeNotifierProviderImpl<SearchBooks, List<Book>> {
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
  List<Book> runNotifierBuild(
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
  AutoDisposeNotifierProviderElement<SearchBooks, List<Book>> createElement() {
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

mixin SearchBooksRef on AutoDisposeNotifierProviderRef<List<Book>> {
  /// The parameter `credential` of this provider.
  String get credential;
}

class _SearchBooksProviderElement
    extends AutoDisposeNotifierProviderElement<SearchBooks, List<Book>>
    with SearchBooksRef {
  _SearchBooksProviderElement(super.provider);

  @override
  String get credential => (origin as SearchBooksProvider).credential;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
