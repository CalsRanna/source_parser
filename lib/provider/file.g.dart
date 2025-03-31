// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filesHash() => r'b5ccece0ddb094e66b5a47a884dff41af0167ab2';

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

abstract class _$Files
    extends BuildlessAutoDisposeAsyncNotifier<List<FileSystemEntity>> {
  late final String? directory;

  FutureOr<List<FileSystemEntity>> build(
    String? directory,
  );
}

/// See also [Files].
@ProviderFor(Files)
const filesProvider = FilesFamily();

/// See also [Files].
class FilesFamily extends Family<AsyncValue<List<FileSystemEntity>>> {
  /// See also [Files].
  const FilesFamily();

  /// See also [Files].
  FilesProvider call(
    String? directory,
  ) {
    return FilesProvider(
      directory,
    );
  }

  @override
  FilesProvider getProviderOverride(
    covariant FilesProvider provider,
  ) {
    return call(
      provider.directory,
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
  String? get name => r'filesProvider';
}

/// See also [Files].
class FilesProvider extends AutoDisposeAsyncNotifierProviderImpl<Files,
    List<FileSystemEntity>> {
  /// See also [Files].
  FilesProvider(
    String? directory,
  ) : this._internal(
          () => Files()..directory = directory,
          from: filesProvider,
          name: r'filesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filesHash,
          dependencies: FilesFamily._dependencies,
          allTransitiveDependencies: FilesFamily._allTransitiveDependencies,
          directory: directory,
        );

  FilesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.directory,
  }) : super.internal();

  final String? directory;

  @override
  FutureOr<List<FileSystemEntity>> runNotifierBuild(
    covariant Files notifier,
  ) {
    return notifier.build(
      directory,
    );
  }

  @override
  Override overrideWith(Files Function() create) {
    return ProviderOverride(
      origin: this,
      override: FilesProvider._internal(
        () => create()..directory = directory,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        directory: directory,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Files, List<FileSystemEntity>>
      createElement() {
    return _FilesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilesProvider && other.directory == directory;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, directory.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilesRef on AutoDisposeAsyncNotifierProviderRef<List<FileSystemEntity>> {
  /// The parameter `directory` of this provider.
  String? get directory;
}

class _FilesProviderElement extends AutoDisposeAsyncNotifierProviderElement<
    Files, List<FileSystemEntity>> with FilesRef {
  _FilesProviderElement(super.provider);

  @override
  String? get directory => (origin as FilesProvider).directory;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
