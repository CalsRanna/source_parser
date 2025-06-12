// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i29;
import 'package:flutter/material.dart' as _i30;
import 'package:source_parser/model/available_source_entity.dart' as _i31;
import 'package:source_parser/model/book_entity.dart' as _i32;
import 'package:source_parser/model/chapter_entity.dart' as _i33;
import 'package:source_parser/model/information_entity.dart' as _i34;
import 'package:source_parser/page/about.dart' as _i1;
import 'package:source_parser/page/available_source/available_source_page.dart'
    as _i3;
import 'package:source_parser/page/available_source/form.dart' as _i2;
import 'package:source_parser/page/book/form.dart' as _i4;
import 'package:source_parser/page/catalogue/catalogue_page.dart' as _i5;
import 'package:source_parser/page/cloud_reader/cloud_reader.dart' as _i6;
import 'package:source_parser/page/cloud_reader/simple_cloud_reader.dart'
    as _i19;
import 'package:source_parser/page/cover_selector/cover_selector_page.dart'
    as _i7;
import 'package:source_parser/page/database_page/database_page.dart' as _i8;
import 'package:source_parser/page/developer_page/developer_page.dart' as _i9;
import 'package:source_parser/page/file_manager.dart' as _i10;
import 'package:source_parser/page/home/home_page.dart' as _i11;
import 'package:source_parser/page/information/information_page.dart' as _i12;
import 'package:source_parser/page/layout.dart' as _i14;
import 'package:source_parser/page/local_server/local_server.dart' as _i13;
import 'package:source_parser/page/reader/reader_page.dart' as _i15;
import 'package:source_parser/page/search/search_page.dart' as _i17;
import 'package:source_parser/page/setting.dart' as _i18;
import 'package:source_parser/page/source/advanced.dart' as _i20;
import 'package:source_parser/page/source/catalogue.dart' as _i21;
import 'package:source_parser/page/source/content.dart' as _i22;
import 'package:source_parser/page/source/debugger.dart' as _i23;
import 'package:source_parser/page/source/form.dart' as _i24;
import 'package:source_parser/page/source/information.dart' as _i25;
import 'package:source_parser/page/source/search.dart' as _i27;
import 'package:source_parser/page/source/source.dart' as _i26;
import 'package:source_parser/page/theme/theme.dart' as _i16;
import 'package:source_parser/page/theme/theme_editor.dart' as _i28;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i29.PageRouteInfo<void> {
  const AboutRoute({List<_i29.PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.AvailableSourceFormPage]
class AvailableSourceFormRoute extends _i29.PageRouteInfo<void> {
  const AvailableSourceFormRoute({List<_i29.PageRouteInfo>? children})
      : super(
          AvailableSourceFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'AvailableSourceFormRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i2.AvailableSourceFormPage();
    },
  );
}

/// generated route for
/// [_i3.AvailableSourcePage]
class AvailableSourceRoute
    extends _i29.PageRouteInfo<AvailableSourceRouteArgs> {
  AvailableSourceRoute({
    _i30.Key? key,
    List<_i31.AvailableSourceEntity>? availableSources,
    required _i32.BookEntity book,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          AvailableSourceRoute.name,
          args: AvailableSourceRouteArgs(
            key: key,
            availableSources: availableSources,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'AvailableSourceRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AvailableSourceRouteArgs>();
      return _i3.AvailableSourcePage(
        key: args.key,
        availableSources: args.availableSources,
        book: args.book,
      );
    },
  );
}

class AvailableSourceRouteArgs {
  const AvailableSourceRouteArgs({
    this.key,
    this.availableSources,
    required this.book,
  });

  final _i30.Key? key;

  final List<_i31.AvailableSourceEntity>? availableSources;

  final _i32.BookEntity book;

  @override
  String toString() {
    return 'AvailableSourceRouteArgs{key: $key, availableSources: $availableSources, book: $book}';
  }
}

/// generated route for
/// [_i4.BookFormPage]
class BookFormRoute extends _i29.PageRouteInfo<void> {
  const BookFormRoute({List<_i29.PageRouteInfo>? children})
      : super(
          BookFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookFormRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i4.BookFormPage();
    },
  );
}

/// generated route for
/// [_i5.CataloguePage]
class CatalogueRoute extends _i29.PageRouteInfo<CatalogueRouteArgs> {
  CatalogueRoute({
    _i30.Key? key,
    required _i32.BookEntity book,
    List<_i33.ChapterEntity>? chapters,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          CatalogueRoute.name,
          args: CatalogueRouteArgs(
            key: key,
            book: book,
            chapters: chapters,
          ),
          initialChildren: children,
        );

  static const String name = 'CatalogueRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CatalogueRouteArgs>();
      return _i5.CataloguePage(
        key: args.key,
        book: args.book,
        chapters: args.chapters,
      );
    },
  );
}

class CatalogueRouteArgs {
  const CatalogueRouteArgs({
    this.key,
    required this.book,
    this.chapters,
  });

  final _i30.Key? key;

  final _i32.BookEntity book;

  final List<_i33.ChapterEntity>? chapters;

  @override
  String toString() {
    return 'CatalogueRouteArgs{key: $key, book: $book, chapters: $chapters}';
  }
}

/// generated route for
/// [_i6.CloudReaderPage]
class CloudReaderRoute extends _i29.PageRouteInfo<void> {
  const CloudReaderRoute({List<_i29.PageRouteInfo>? children})
      : super(
          CloudReaderRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i6.CloudReaderPage();
    },
  );
}

/// generated route for
/// [_i7.CoverSelectorPage]
class CoverSelectorRoute extends _i29.PageRouteInfo<CoverSelectorRouteArgs> {
  CoverSelectorRoute({
    _i30.Key? key,
    required _i32.BookEntity book,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          CoverSelectorRoute.name,
          args: CoverSelectorRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CoverSelectorRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CoverSelectorRouteArgs>();
      return _i7.CoverSelectorPage(
        key: args.key,
        book: args.book,
      );
    },
  );
}

class CoverSelectorRouteArgs {
  const CoverSelectorRouteArgs({
    this.key,
    required this.book,
  });

  final _i30.Key? key;

  final _i32.BookEntity book;

  @override
  String toString() {
    return 'CoverSelectorRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i8.DatabasePage]
class DatabaseRoute extends _i29.PageRouteInfo<void> {
  const DatabaseRoute({List<_i29.PageRouteInfo>? children})
      : super(
          DatabaseRoute.name,
          initialChildren: children,
        );

  static const String name = 'DatabaseRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i8.DatabasePage();
    },
  );
}

/// generated route for
/// [_i9.DeveloperPage]
class DeveloperRoute extends _i29.PageRouteInfo<void> {
  const DeveloperRoute({List<_i29.PageRouteInfo>? children})
      : super(
          DeveloperRoute.name,
          initialChildren: children,
        );

  static const String name = 'DeveloperRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i9.DeveloperPage();
    },
  );
}

/// generated route for
/// [_i10.FileManagerPage]
class FileManagerRoute extends _i29.PageRouteInfo<void> {
  const FileManagerRoute({List<_i29.PageRouteInfo>? children})
      : super(
          FileManagerRoute.name,
          initialChildren: children,
        );

  static const String name = 'FileManagerRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i10.FileManagerPage();
    },
  );
}

/// generated route for
/// [_i11.HomePage]
class HomeRoute extends _i29.PageRouteInfo<void> {
  const HomeRoute({List<_i29.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i11.HomePage();
    },
  );
}

/// generated route for
/// [_i12.InformationPage]
class InformationRoute extends _i29.PageRouteInfo<InformationRouteArgs> {
  InformationRoute({
    _i30.Key? key,
    required _i34.InformationEntity information,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          InformationRoute.name,
          args: InformationRouteArgs(
            key: key,
            information: information,
          ),
          initialChildren: children,
        );

  static const String name = 'InformationRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InformationRouteArgs>();
      return _i12.InformationPage(
        key: args.key,
        information: args.information,
      );
    },
  );
}

class InformationRouteArgs {
  const InformationRouteArgs({
    this.key,
    required this.information,
  });

  final _i30.Key? key;

  final _i34.InformationEntity information;

  @override
  String toString() {
    return 'InformationRouteArgs{key: $key, information: $information}';
  }
}

/// generated route for
/// [_i13.LocalServerPage]
class LocalServerRoute extends _i29.PageRouteInfo<void> {
  const LocalServerRoute({List<_i29.PageRouteInfo>? children})
      : super(
          LocalServerRoute.name,
          initialChildren: children,
        );

  static const String name = 'LocalServerRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i13.LocalServerPage();
    },
  );
}

/// generated route for
/// [_i14.ReaderLayoutPage]
class ReaderLayoutRoute extends _i29.PageRouteInfo<void> {
  const ReaderLayoutRoute({List<_i29.PageRouteInfo>? children})
      : super(
          ReaderLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderLayoutRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i14.ReaderLayoutPage();
    },
  );
}

/// generated route for
/// [_i15.ReaderPage]
class ReaderRoute extends _i29.PageRouteInfo<ReaderRouteArgs> {
  ReaderRoute({
    _i30.Key? key,
    required _i32.BookEntity book,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          ReaderRoute.name,
          args: ReaderRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderRouteArgs>();
      return _i15.ReaderPage(
        key: args.key,
        book: args.book,
      );
    },
  );
}

class ReaderRouteArgs {
  const ReaderRouteArgs({
    this.key,
    required this.book,
  });

  final _i30.Key? key;

  final _i32.BookEntity book;

  @override
  String toString() {
    return 'ReaderRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i16.ReaderThemePage]
class ReaderThemeRoute extends _i29.PageRouteInfo<void> {
  const ReaderThemeRoute({List<_i29.PageRouteInfo>? children})
      : super(
          ReaderThemeRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i16.ReaderThemePage();
    },
  );
}

/// generated route for
/// [_i17.SearchPage]
class SearchRoute extends _i29.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i30.Key? key,
    String? credential,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            credential: credential,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SearchRouteArgs>(orElse: () => const SearchRouteArgs());
      return _i17.SearchPage(
        key: args.key,
        credential: args.credential,
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({
    this.key,
    this.credential,
  });

  final _i30.Key? key;

  final String? credential;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, credential: $credential}';
  }
}

/// generated route for
/// [_i18.SettingPage]
class SettingRoute extends _i29.PageRouteInfo<void> {
  const SettingRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i18.SettingPage();
    },
  );
}

/// generated route for
/// [_i19.SimpleCloudReaderPage]
class SimpleCloudReaderRoute extends _i29.PageRouteInfo<void> {
  const SimpleCloudReaderRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SimpleCloudReaderRoute.name,
          initialChildren: children,
        );

  static const String name = 'SimpleCloudReaderRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i19.SimpleCloudReaderPage();
    },
  );
}

/// generated route for
/// [_i20.SourceAdvancedConfigurationPage]
class SourceAdvancedConfigurationRoute extends _i29.PageRouteInfo<void> {
  const SourceAdvancedConfigurationRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SourceAdvancedConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceAdvancedConfigurationRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i20.SourceAdvancedConfigurationPage();
    },
  );
}

/// generated route for
/// [_i21.SourceCatalogueConfigurationPage]
class SourceCatalogueConfigurationRoute extends _i29.PageRouteInfo<void> {
  const SourceCatalogueConfigurationRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SourceCatalogueConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceCatalogueConfigurationRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i21.SourceCatalogueConfigurationPage();
    },
  );
}

/// generated route for
/// [_i22.SourceContentConfigurationPage]
class SourceContentConfigurationRoute extends _i29.PageRouteInfo<void> {
  const SourceContentConfigurationRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SourceContentConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceContentConfigurationRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i22.SourceContentConfigurationPage();
    },
  );
}

/// generated route for
/// [_i23.SourceDebuggerPage]
class SourceDebuggerRoute extends _i29.PageRouteInfo<void> {
  const SourceDebuggerRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SourceDebuggerRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceDebuggerRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i23.SourceDebuggerPage();
    },
  );
}

/// generated route for
/// [_i24.SourceFormPage]
class SourceFormRoute extends _i29.PageRouteInfo<SourceFormRouteArgs> {
  SourceFormRoute({
    _i30.Key? key,
    int? id,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          SourceFormRoute.name,
          args: SourceFormRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'SourceFormRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SourceFormRouteArgs>(
          orElse: () => const SourceFormRouteArgs());
      return _i24.SourceFormPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class SourceFormRouteArgs {
  const SourceFormRouteArgs({
    this.key,
    this.id,
  });

  final _i30.Key? key;

  final int? id;

  @override
  String toString() {
    return 'SourceFormRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i25.SourceInformationConfigurationPage]
class SourceInformationConfigurationRoute extends _i29.PageRouteInfo<void> {
  const SourceInformationConfigurationRoute(
      {List<_i29.PageRouteInfo>? children})
      : super(
          SourceInformationConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceInformationConfigurationRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i25.SourceInformationConfigurationPage();
    },
  );
}

/// generated route for
/// [_i26.SourceListPage]
class SourceListRoute extends _i29.PageRouteInfo<void> {
  const SourceListRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SourceListRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceListRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i26.SourceListPage();
    },
  );
}

/// generated route for
/// [_i27.SourceSearchConfigurationPage]
class SourceSearchConfigurationRoute extends _i29.PageRouteInfo<void> {
  const SourceSearchConfigurationRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SourceSearchConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceSearchConfigurationRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i27.SourceSearchConfigurationPage();
    },
  );
}

/// generated route for
/// [_i28.ThemeEditorPage]
class ThemeEditorRoute extends _i29.PageRouteInfo<void> {
  const ThemeEditorRoute({List<_i29.PageRouteInfo>? children})
      : super(
          ThemeEditorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ThemeEditorRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i28.ThemeEditorPage();
    },
  );
}
