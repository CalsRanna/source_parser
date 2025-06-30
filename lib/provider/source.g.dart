// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sourcesHash() => r'f9c2c1d52b0a19f6adb5ccb94bcf176f02fb3c56';

/// See also [Sources].
@ProviderFor(Sources)
final sourcesProvider =
    AutoDisposeAsyncNotifierProvider<Sources, List<Source>>.internal(
  Sources.new,
  name: r'sourcesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sourcesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Sources = AutoDisposeAsyncNotifier<List<Source>>;
String _$currentSourceHash() => r'a43813b2540d96217bf293055318b5d0794426eb';

/// See also [CurrentSource].
@ProviderFor(CurrentSource)
final currentSourceProvider =
    AutoDisposeAsyncNotifierProvider<CurrentSource, Source?>.internal(
  CurrentSource.new,
  name: r'currentSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentSource = AutoDisposeAsyncNotifier<Source?>;
String _$formSourceHash() => r'8b7e96b0a7662d2a105a468837ba770d10fddb44';

/// See also [FormSource].
@ProviderFor(FormSource)
final formSourceProvider = NotifierProvider<FormSource, Source>.internal(
  FormSource.new,
  name: r'formSourceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$formSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FormSource = Notifier<Source>;
String _$sourceDebuggerHash() => r'0930ebbb25a2135718a5b84fb5e553bacb41a50a';

/// See also [SourceDebugger].
@ProviderFor(SourceDebugger)
final sourceDebuggerProvider = AutoDisposeAsyncNotifierProvider<SourceDebugger,
    Stream<List<DebugResultNew>>>.internal(
  SourceDebugger.new,
  name: r'sourceDebuggerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sourceDebuggerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SourceDebugger
    = AutoDisposeAsyncNotifier<Stream<List<DebugResultNew>>>;
String _$exploreSourcesNotifierHash() =>
    r'fb881a0f9b942f1e0e3c0a9f27f7d7e5caf2c0be';

/// See also [ExploreSourcesNotifier].
@ProviderFor(ExploreSourcesNotifier)
final exploreSourcesNotifierProvider = AutoDisposeAsyncNotifierProvider<
    ExploreSourcesNotifier, List<Source>>.internal(
  ExploreSourcesNotifier.new,
  name: r'exploreSourcesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exploreSourcesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExploreSourcesNotifier = AutoDisposeAsyncNotifier<List<Source>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
