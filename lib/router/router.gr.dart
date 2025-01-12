// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i23;
import 'package:flutter/material.dart' as _i24;
import 'package:source_parser/page/about.dart' as _i1;
import 'package:source_parser/page/available_source/form.dart' as _i2;
import 'package:source_parser/page/available_source/source.dart' as _i3;
import 'package:source_parser/page/book/form.dart' as _i4;
import 'package:source_parser/page/catalogue/catalogue.dart' as _i5;
import 'package:source_parser/page/home/home.dart' as _i6;
import 'package:source_parser/page/information.dart' as _i7;
import 'package:source_parser/page/layout.dart' as _i8;
import 'package:source_parser/page/reader/reader.dart' as _i9;
import 'package:source_parser/page/search/search.dart' as _i11;
import 'package:source_parser/page/setting.dart' as _i12;
import 'package:source_parser/page/source/advanced.dart' as _i13;
import 'package:source_parser/page/source/catalogue.dart' as _i14;
import 'package:source_parser/page/source/content.dart' as _i15;
import 'package:source_parser/page/source/debugger.dart' as _i16;
import 'package:source_parser/page/source/form.dart' as _i17;
import 'package:source_parser/page/source/information.dart' as _i18;
import 'package:source_parser/page/source/search.dart' as _i20;
import 'package:source_parser/page/source_manager/server.dart' as _i21;
import 'package:source_parser/page/source/source.dart' as _i19;
import 'package:source_parser/page/theme/theme.dart' as _i10;
import 'package:source_parser/page/theme/theme_editor.dart' as _i22;
import 'package:source_parser/schema/book.dart' as _i25;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i23.PageRouteInfo<void> {
  const AboutRoute({List<_i23.PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.AvailableSourceFormPage]
class AvailableSourceFormRoute extends _i23.PageRouteInfo<void> {
  const AvailableSourceFormRoute({List<_i23.PageRouteInfo>? children})
      : super(
          AvailableSourceFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'AvailableSourceFormRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i2.AvailableSourceFormPage();
    },
  );
}

/// generated route for
/// [_i3.AvailableSourceListPage]
class AvailableSourceListRoute extends _i23.PageRouteInfo<void> {
  const AvailableSourceListRoute({List<_i23.PageRouteInfo>? children})
      : super(
          AvailableSourceListRoute.name,
          initialChildren: children,
        );

  static const String name = 'AvailableSourceListRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i3.AvailableSourceListPage();
    },
  );
}

/// generated route for
/// [_i4.BookFormPage]
class BookFormRoute extends _i23.PageRouteInfo<void> {
  const BookFormRoute({List<_i23.PageRouteInfo>? children})
      : super(
          BookFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookFormRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i4.BookFormPage();
    },
  );
}

/// generated route for
/// [_i5.CataloguePage]
class CatalogueRoute extends _i23.PageRouteInfo<CatalogueRouteArgs> {
  CatalogueRoute({
    _i24.Key? key,
    required int index,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          CatalogueRoute.name,
          args: CatalogueRouteArgs(
            key: key,
            index: index,
          ),
          initialChildren: children,
        );

  static const String name = 'CatalogueRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CatalogueRouteArgs>();
      return _i5.CataloguePage(
        key: args.key,
        index: args.index,
      );
    },
  );
}

class CatalogueRouteArgs {
  const CatalogueRouteArgs({
    this.key,
    required this.index,
  });

  final _i24.Key? key;

  final int index;

  @override
  String toString() {
    return 'CatalogueRouteArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [_i6.HomePage]
class HomeRoute extends _i23.PageRouteInfo<void> {
  const HomeRoute({List<_i23.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i6.HomePage();
    },
  );
}

/// generated route for
/// [_i7.InformationPage]
class InformationRoute extends _i23.PageRouteInfo<void> {
  const InformationRoute({List<_i23.PageRouteInfo>? children})
      : super(
          InformationRoute.name,
          initialChildren: children,
        );

  static const String name = 'InformationRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i7.InformationPage();
    },
  );
}

/// generated route for
/// [_i8.ReaderLayoutPage]
class ReaderLayoutRoute extends _i23.PageRouteInfo<void> {
  const ReaderLayoutRoute({List<_i23.PageRouteInfo>? children})
      : super(
          ReaderLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderLayoutRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i8.ReaderLayoutPage();
    },
  );
}

/// generated route for
/// [_i9.ReaderPage]
class ReaderRoute extends _i23.PageRouteInfo<ReaderRouteArgs> {
  ReaderRoute({
    _i24.Key? key,
    required _i25.Book book,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          ReaderRoute.name,
          args: ReaderRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderRouteArgs>();
      return _i9.ReaderPage(
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

  final _i24.Key? key;

  final _i25.Book book;

  @override
  String toString() {
    return 'ReaderRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i10.ReaderThemePage]
class ReaderThemeRoute extends _i23.PageRouteInfo<void> {
  const ReaderThemeRoute({List<_i23.PageRouteInfo>? children})
      : super(
          ReaderThemeRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i10.ReaderThemePage();
    },
  );
}

/// generated route for
/// [_i11.SearchPage]
class SearchRoute extends _i23.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i24.Key? key,
    String? credential,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            credential: credential,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SearchRouteArgs>(orElse: () => const SearchRouteArgs());
      return _i11.SearchPage(
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

  final _i24.Key? key;

  final String? credential;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, credential: $credential}';
  }
}

/// generated route for
/// [_i12.SettingPage]
class SettingRoute extends _i23.PageRouteInfo<void> {
  const SettingRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i12.SettingPage();
    },
  );
}

/// generated route for
/// [_i13.SourceAdvancedConfigurationPage]
class SourceAdvancedConfigurationRoute extends _i23.PageRouteInfo<void> {
  const SourceAdvancedConfigurationRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SourceAdvancedConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceAdvancedConfigurationRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i13.SourceAdvancedConfigurationPage();
    },
  );
}

/// generated route for
/// [_i14.SourceCatalogueConfigurationPage]
class SourceCatalogueConfigurationRoute extends _i23.PageRouteInfo<void> {
  const SourceCatalogueConfigurationRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SourceCatalogueConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceCatalogueConfigurationRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i14.SourceCatalogueConfigurationPage();
    },
  );
}

/// generated route for
/// [_i15.SourceContentConfigurationPage]
class SourceContentConfigurationRoute extends _i23.PageRouteInfo<void> {
  const SourceContentConfigurationRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SourceContentConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceContentConfigurationRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i15.SourceContentConfigurationPage();
    },
  );
}

/// generated route for
/// [_i16.SourceDebuggerPage]
class SourceDebuggerRoute extends _i23.PageRouteInfo<void> {
  const SourceDebuggerRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SourceDebuggerRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceDebuggerRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i16.SourceDebuggerPage();
    },
  );
}

/// generated route for
/// [_i17.SourceFormPage]
class SourceFormRoute extends _i23.PageRouteInfo<SourceFormRouteArgs> {
  SourceFormRoute({
    _i24.Key? key,
    int? id,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          SourceFormRoute.name,
          args: SourceFormRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'SourceFormRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SourceFormRouteArgs>(
          orElse: () => const SourceFormRouteArgs());
      return _i17.SourceFormPage(
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

  final _i24.Key? key;

  final int? id;

  @override
  String toString() {
    return 'SourceFormRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i18.SourceInformationConfigurationPage]
class SourceInformationConfigurationRoute extends _i23.PageRouteInfo<void> {
  const SourceInformationConfigurationRoute(
      {List<_i23.PageRouteInfo>? children})
      : super(
          SourceInformationConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceInformationConfigurationRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i18.SourceInformationConfigurationPage();
    },
  );
}

/// generated route for
/// [_i19.SourceListPage]
class SourceListRoute extends _i23.PageRouteInfo<void> {
  const SourceListRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SourceListRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceListRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i19.SourceListPage();
    },
  );
}

/// generated route for
/// [_i20.SourceSearchConfigurationPage]
class SourceSearchConfigurationRoute extends _i23.PageRouteInfo<void> {
  const SourceSearchConfigurationRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SourceSearchConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceSearchConfigurationRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i20.SourceSearchConfigurationPage();
    },
  );
}

/// generated route for
/// [_i21.SourceServerPage]
class SourceServerRoute extends _i23.PageRouteInfo<void> {
  const SourceServerRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SourceServerRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceServerRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i21.SourceServerPage();
    },
  );
}

/// generated route for
/// [_i22.ThemeEditorPage]
class ThemeEditorRoute extends _i23.PageRouteInfo<void> {
  const ThemeEditorRoute({List<_i23.PageRouteInfo>? children})
      : super(
          ThemeEditorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ThemeEditorRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i22.ThemeEditorPage();
    },
  );
}
