// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookCoversHash() => r'339ca83d9891d050f1d982aaf21f9991dffd70a0';

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

abstract class _$BookCovers
    extends BuildlessAutoDisposeAsyncNotifier<List<String>> {
  late final Book book;

  FutureOr<List<String>> build(
    Book book,
  );
}

/// See also [BookCovers].
@ProviderFor(BookCovers)
const bookCoversProvider = BookCoversFamily();

/// See also [BookCovers].
class BookCoversFamily extends Family<AsyncValue<List<String>>> {
  /// See also [BookCovers].
  const BookCoversFamily();

  /// See also [BookCovers].
  BookCoversProvider call(
    Book book,
  ) {
    return BookCoversProvider(
      book,
    );
  }

  @override
  BookCoversProvider getProviderOverride(
    covariant BookCoversProvider provider,
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
  String? get name => r'bookCoversProvider';
}

/// See also [BookCovers].
class BookCoversProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BookCovers, List<String>> {
  /// See also [BookCovers].
  BookCoversProvider(
    Book book,
  ) : this._internal(
          () => BookCovers()..book = book,
          from: bookCoversProvider,
          name: r'bookCoversProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookCoversHash,
          dependencies: BookCoversFamily._dependencies,
          allTransitiveDependencies:
              BookCoversFamily._allTransitiveDependencies,
          book: book,
        );

  BookCoversProvider._internal(
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
  FutureOr<List<String>> runNotifierBuild(
    covariant BookCovers notifier,
  ) {
    return notifier.build(
      book,
    );
  }

  @override
  Override overrideWith(BookCovers Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookCoversProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<BookCovers, List<String>>
      createElement() {
    return _BookCoversProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookCoversProvider && other.book == book;
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
mixin BookCoversRef on AutoDisposeAsyncNotifierProviderRef<List<String>> {
  /// The parameter `book` of this provider.
  Book get book;
}

class _BookCoversProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BookCovers, List<String>>
    with BookCoversRef {
  _BookCoversProviderElement(super.provider);

  @override
  Book get book => (origin as BookCoversProvider).book;
}

String _$bookNotifierHash() => r'cad02d1c60a33ed9dd265162d564232bc2ecc235';

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
String _$booksHash() => r'a4feafdb5c4b4c84a57e682c13c71b68d37bf132';

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
String _$inShelfHash() => r'86fb9d7216a26d9e0e00712d4b318790bddfb06d';

abstract class _$InShelf extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final Book book;

  FutureOr<bool> build(
    Book book,
  );
}

/// See also [InShelf].
@ProviderFor(InShelf)
const inShelfProvider = InShelfFamily();

/// See also [InShelf].
class InShelfFamily extends Family<AsyncValue<bool>> {
  /// See also [InShelf].
  const InShelfFamily();

  /// See also [InShelf].
  InShelfProvider call(
    Book book,
  ) {
    return InShelfProvider(
      book,
    );
  }

  @override
  InShelfProvider getProviderOverride(
    covariant InShelfProvider provider,
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
  String? get name => r'inShelfProvider';
}

/// See also [InShelf].
class InShelfProvider
    extends AutoDisposeAsyncNotifierProviderImpl<InShelf, bool> {
  /// See also [InShelf].
  InShelfProvider(
    Book book,
  ) : this._internal(
          () => InShelf()..book = book,
          from: inShelfProvider,
          name: r'inShelfProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inShelfHash,
          dependencies: InShelfFamily._dependencies,
          allTransitiveDependencies: InShelfFamily._allTransitiveDependencies,
          book: book,
        );

  InShelfProvider._internal(
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
  FutureOr<bool> runNotifierBuild(
    covariant InShelf notifier,
  ) {
    return notifier.build(
      book,
    );
  }

  @override
  Override overrideWith(InShelf Function() create) {
    return ProviderOverride(
      origin: this,
      override: InShelfProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<InShelf, bool> createElement() {
    return _InShelfProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InShelfProvider && other.book == book;
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
mixin InShelfRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `book` of this provider.
  Book get book;
}

class _InShelfProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<InShelf, bool>
    with InShelfRef {
  _InShelfProviderElement(super.provider);

  @override
  Book get book => (origin as InShelfProvider).book;
}

String _$searchBooksHash() => r'6405775410dbd921475bef9c94d75b6859141d21';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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

String _$searchLoadingHash() => r'8b80255cb8d4fa83254a22839ab671bb043d0276';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
