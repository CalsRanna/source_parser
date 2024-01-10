// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cacheSizeHash() => r'518548de6f69af78a649f4ec1ee461a7fbfe50e9';

/// See also [CacheSize].
@ProviderFor(CacheSize)
final cacheSizeProvider =
    AutoDisposeAsyncNotifierProvider<CacheSize, String>.internal(
  CacheSize.new,
  name: r'cacheSizeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cacheSizeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CacheSize = AutoDisposeAsyncNotifier<String>;
String _$cacheProgressNotifierHash() =>
    r'6b90c808e008948e8c23aec2887590004c356459';

/// See also [CacheProgressNotifier].
@ProviderFor(CacheProgressNotifier)
final cacheProgressNotifierProvider =
    NotifierProvider<CacheProgressNotifier, CacheProgress>.internal(
  CacheProgressNotifier.new,
  name: r'cacheProgressNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cacheProgressNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CacheProgressNotifier = Notifier<CacheProgress>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
