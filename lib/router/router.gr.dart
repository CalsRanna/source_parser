// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i26;
import 'package:flutter/material.dart' as _i27;
import 'package:source_parser/model/book_entity.dart' as _i28;
import 'package:source_parser/page/about.dart' as _i1;
import 'package:source_parser/page/available_source/available_source_page.dart'
    as _i3;
import 'package:source_parser/page/available_source/form.dart' as _i2;
import 'package:source_parser/page/book/form.dart' as _i4;
import 'package:source_parser/page/catalogue/catalogue_page.dart' as _i5;
import 'package:source_parser/page/cloud_reader.dart' as _i6;
import 'package:source_parser/page/cover_selector/cover_selector_page.dart'
    as _i7;
import 'package:source_parser/page/file_manager.dart' as _i8;
import 'package:source_parser/page/home/home_page.dart' as _i9;
import 'package:source_parser/page/information/information_page.dart' as _i10;
import 'package:source_parser/page/layout.dart' as _i12;
import 'package:source_parser/page/local_server/local_server.dart' as _i11;
import 'package:source_parser/page/reader/reader_page.dart' as _i13;
import 'package:source_parser/page/search/search_page.dart' as _i15;
import 'package:source_parser/page/setting.dart' as _i16;
import 'package:source_parser/page/source/advanced.dart' as _i17;
import 'package:source_parser/page/source/catalogue.dart' as _i18;
import 'package:source_parser/page/source/content.dart' as _i19;
import 'package:source_parser/page/source/debugger.dart' as _i20;
import 'package:source_parser/page/source/form.dart' as _i21;
import 'package:source_parser/page/source/information.dart' as _i22;
import 'package:source_parser/page/source/search.dart' as _i24;
import 'package:source_parser/page/source/source.dart' as _i23;
import 'package:source_parser/page/theme/theme.dart' as _i14;
import 'package:source_parser/page/theme/theme_editor.dart' as _i25;
import 'package:source_parser/schema/book.dart' as _i29;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i26.PageRouteInfo<void> {
  const AboutRoute({List<_i26.PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.AvailableSourceFormPage]
class AvailableSourceFormRoute extends _i26.PageRouteInfo<void> {
  const AvailableSourceFormRoute({List<_i26.PageRouteInfo>? children})
      : super(
          AvailableSourceFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'AvailableSourceFormRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i2.AvailableSourceFormPage();
    },
  );
}

/// generated route for
/// [_i3.AvailableSourcePage]
class AvailableSourceRoute
    extends _i26.PageRouteInfo<AvailableSourceRouteArgs> {
  AvailableSourceRoute({
    _i27.Key? key,
    required _i28.BookEntity book,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          AvailableSourceRoute.name,
          args: AvailableSourceRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'AvailableSourceRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AvailableSourceRouteArgs>();
      return _i3.AvailableSourcePage(
        key: args.key,
        book: args.book,
      );
    },
  );
}

class AvailableSourceRouteArgs {
  const AvailableSourceRouteArgs({
    this.key,
    required this.book,
  });

  final _i27.Key? key;

  final _i28.BookEntity book;

  @override
  String toString() {
    return 'AvailableSourceRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i4.BookFormPage]
class BookFormRoute extends _i26.PageRouteInfo<void> {
  const BookFormRoute({List<_i26.PageRouteInfo>? children})
      : super(
          BookFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookFormRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i4.BookFormPage();
    },
  );
}

/// generated route for
/// [_i5.CataloguePage]
class CatalogueRoute extends _i26.PageRouteInfo<CatalogueRouteArgs> {
  CatalogueRoute({
    _i27.Key? key,
    required _i28.BookEntity book,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          CatalogueRoute.name,
          args: CatalogueRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CatalogueRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CatalogueRouteArgs>();
      return _i5.CataloguePage(
        key: args.key,
        book: args.book,
      );
    },
  );
}

class CatalogueRouteArgs {
  const CatalogueRouteArgs({
    this.key,
    required this.book,
  });

  final _i27.Key? key;

  final _i28.BookEntity book;

  @override
  String toString() {
    return 'CatalogueRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i6.CloudReaderPage]
class CloudReaderRoute extends _i26.PageRouteInfo<void> {
  const CloudReaderRoute({List<_i26.PageRouteInfo>? children})
      : super(
          CloudReaderRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i6.CloudReaderPage();
    },
  );
}

/// generated route for
/// [_i7.CoverSelectorPage]
class CoverSelectorRoute extends _i26.PageRouteInfo<CoverSelectorRouteArgs> {
  CoverSelectorRoute({
    _i27.Key? key,
    required _i28.BookEntity book,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          CoverSelectorRoute.name,
          args: CoverSelectorRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CoverSelectorRoute';

  static _i26.PageInfo page = _i26.PageInfo(
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

  final _i27.Key? key;

  final _i28.BookEntity book;

  @override
  String toString() {
    return 'CoverSelectorRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i8.FileManagerPage]
class FileManagerRoute extends _i26.PageRouteInfo<void> {
  const FileManagerRoute({List<_i26.PageRouteInfo>? children})
      : super(
          FileManagerRoute.name,
          initialChildren: children,
        );

  static const String name = 'FileManagerRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i8.FileManagerPage();
    },
  );
}

/// generated route for
/// [_i9.HomePage]
class HomeRoute extends _i26.PageRouteInfo<void> {
  const HomeRoute({List<_i26.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i9.HomePage();
    },
  );
}

/// generated route for
/// [_i10.InformationPage]
class InformationRoute extends _i26.PageRouteInfo<InformationRouteArgs> {
  InformationRoute({
    _i27.Key? key,
    required _i28.BookEntity book,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          InformationRoute.name,
          args: InformationRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'InformationRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InformationRouteArgs>();
      return _i10.InformationPage(
        key: args.key,
        book: args.book,
      );
    },
  );
}

class InformationRouteArgs {
  const InformationRouteArgs({
    this.key,
    required this.book,
  });

  final _i27.Key? key;

  final _i28.BookEntity book;

  @override
  String toString() {
    return 'InformationRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i11.LocalServerPage]
class LocalServerRoute extends _i26.PageRouteInfo<void> {
  const LocalServerRoute({List<_i26.PageRouteInfo>? children})
      : super(
          LocalServerRoute.name,
          initialChildren: children,
        );

  static const String name = 'LocalServerRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i11.LocalServerPage();
    },
  );
}

/// generated route for
/// [_i12.ReaderLayoutPage]
class ReaderLayoutRoute extends _i26.PageRouteInfo<void> {
  const ReaderLayoutRoute({List<_i26.PageRouteInfo>? children})
      : super(
          ReaderLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderLayoutRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i12.ReaderLayoutPage();
    },
  );
}

/// generated route for
/// [_i13.ReaderPage]
class ReaderRoute extends _i26.PageRouteInfo<ReaderRouteArgs> {
  ReaderRoute({
    _i27.Key? key,
    required _i29.Book book,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          ReaderRoute.name,
          args: ReaderRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderRouteArgs>();
      return _i13.ReaderPage(
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

  final _i27.Key? key;

  final _i29.Book book;

  @override
  String toString() {
    return 'ReaderRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i14.ReaderThemePage]
class ReaderThemeRoute extends _i26.PageRouteInfo<void> {
  const ReaderThemeRoute({List<_i26.PageRouteInfo>? children})
      : super(
          ReaderThemeRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i14.ReaderThemePage();
    },
  );
}

/// generated route for
/// [_i15.SearchPage]
class SearchRoute extends _i26.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i27.Key? key,
    String? credential,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            credential: credential,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SearchRouteArgs>(orElse: () => const SearchRouteArgs());
      return _i15.SearchPage(
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

  final _i27.Key? key;

  final String? credential;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, credential: $credential}';
  }
}

/// generated route for
/// [_i16.SettingPage]
class SettingRoute extends _i26.PageRouteInfo<void> {
  const SettingRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i16.SettingPage();
    },
  );
}

/// generated route for
/// [_i17.SourceAdvancedConfigurationPage]
class SourceAdvancedConfigurationRoute extends _i26.PageRouteInfo<void> {
  const SourceAdvancedConfigurationRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SourceAdvancedConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceAdvancedConfigurationRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i17.SourceAdvancedConfigurationPage();
    },
  );
}

/// generated route for
/// [_i18.SourceCatalogueConfigurationPage]
class SourceCatalogueConfigurationRoute extends _i26.PageRouteInfo<void> {
  const SourceCatalogueConfigurationRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SourceCatalogueConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceCatalogueConfigurationRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i18.SourceCatalogueConfigurationPage();
    },
  );
}

/// generated route for
/// [_i19.SourceContentConfigurationPage]
class SourceContentConfigurationRoute extends _i26.PageRouteInfo<void> {
  const SourceContentConfigurationRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SourceContentConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceContentConfigurationRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i19.SourceContentConfigurationPage();
    },
  );
}

/// generated route for
/// [_i20.SourceDebuggerPage]
class SourceDebuggerRoute extends _i26.PageRouteInfo<void> {
  const SourceDebuggerRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SourceDebuggerRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceDebuggerRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i20.SourceDebuggerPage();
    },
  );
}

/// generated route for
/// [_i21.SourceFormPage]
class SourceFormRoute extends _i26.PageRouteInfo<SourceFormRouteArgs> {
  SourceFormRoute({
    _i27.Key? key,
    int? id,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          SourceFormRoute.name,
          args: SourceFormRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'SourceFormRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SourceFormRouteArgs>(
          orElse: () => const SourceFormRouteArgs());
      return _i21.SourceFormPage(
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

  final _i27.Key? key;

  final int? id;

  @override
  String toString() {
    return 'SourceFormRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i22.SourceInformationConfigurationPage]
class SourceInformationConfigurationRoute extends _i26.PageRouteInfo<void> {
  const SourceInformationConfigurationRoute(
      {List<_i26.PageRouteInfo>? children})
      : super(
          SourceInformationConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceInformationConfigurationRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i22.SourceInformationConfigurationPage();
    },
  );
}

/// generated route for
/// [_i23.SourceListPage]
class SourceListRoute extends _i26.PageRouteInfo<void> {
  const SourceListRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SourceListRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceListRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i23.SourceListPage();
    },
  );
}

/// generated route for
/// [_i24.SourceSearchConfigurationPage]
class SourceSearchConfigurationRoute extends _i26.PageRouteInfo<void> {
  const SourceSearchConfigurationRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SourceSearchConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceSearchConfigurationRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i24.SourceSearchConfigurationPage();
    },
  );
}

/// generated route for
/// [_i25.ThemeEditorPage]
class ThemeEditorRoute extends _i26.PageRouteInfo<void> {
  const ThemeEditorRoute({List<_i26.PageRouteInfo>? children})
      : super(
          ThemeEditorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ThemeEditorRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i25.ThemeEditorPage();
    },
  );
}
