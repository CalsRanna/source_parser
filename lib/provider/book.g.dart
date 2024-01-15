// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookNotifierHash() => r'c54e6961318e7f5ff2bbaf0461f46016b8a6e641';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
