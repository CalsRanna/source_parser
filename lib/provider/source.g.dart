// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sourcesHash() => r'04928f658bc8964ab124a8d83ff98694493f9e61';

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
String _$formSourceHash() => r'56d9daea8792c1c71c5ba6ee3eed9f606b924ff5';

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
String _$sourceDebuggerHash() => r'13fea0bca1528afbd2d1213a5c5fd120724d8167';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
