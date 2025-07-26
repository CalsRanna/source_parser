// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i32;
import 'package:flutter/material.dart' as _i33;
import 'package:source_parser/model/available_source_entity.dart' as _i34;
import 'package:source_parser/model/book_entity.dart' as _i35;
import 'package:source_parser/model/chapter_entity.dart' as _i36;
import 'package:source_parser/model/information_entity.dart' as _i37;
import 'package:source_parser/model/source_entity.dart' as _i39;
import 'package:source_parser/page/about.dart' as _i1;
import 'package:source_parser/page/available_source/available_source_form_page.dart'
    as _i2;
import 'package:source_parser/page/available_source/available_source_page.dart'
    as _i3;
import 'package:source_parser/page/book/form.dart' as _i4;
import 'package:source_parser/page/catalogue/catalogue_page.dart' as _i5;
import 'package:source_parser/page/cloud_reader/cloud_reader.dart' as _i6;
import 'package:source_parser/page/cloud_reader/simple_cloud_reader.dart'
    as _i22;
import 'package:source_parser/page/cover_selector/cover_selector_page.dart'
    as _i7;
import 'package:source_parser/page/database_page/database_page.dart' as _i8;
import 'package:source_parser/page/developer_page/developer_page.dart' as _i9;
import 'package:source_parser/page/file_manager.dart' as _i10;
import 'package:source_parser/page/home/home_page.dart' as _i11;
import 'package:source_parser/page/information/information_page.dart' as _i12;
import 'package:source_parser/page/layout.dart' as _i14;
import 'package:source_parser/page/local_server_page/local_server_page.dart'
    as _i13;
import 'package:source_parser/page/reader/reader_page.dart' as _i15;
import 'package:source_parser/page/reader_theme/reader_theme_editor_color_picker_page.dart'
    as _i16;
import 'package:source_parser/page/reader_theme/reader_theme_editor_image_selector_page.dart'
    as _i17;
import 'package:source_parser/page/reader_theme/reader_theme_editor_page.dart'
    as _i18;
import 'package:source_parser/page/reader_theme/reader_theme_page.dart' as _i19;
import 'package:source_parser/page/search/search_page.dart' as _i20;
import 'package:source_parser/page/setting/setting_page.dart' as _i21;
import 'package:source_parser/page/source_form_page.dart/source_form_debug_page.dart'
    as _i27;
import 'package:source_parser/page/source_form_page.dart/source_form_page.dart'
    as _i28;
import 'package:source_parser/page/source_page/advanced.dart' as _i23;
import 'package:source_parser/page/source_page/catalogue.dart' as _i24;
import 'package:source_parser/page/source_page/content.dart' as _i25;
import 'package:source_parser/page/source_page/debugger.dart' as _i26;
import 'package:source_parser/page/source_page/information.dart' as _i29;
import 'package:source_parser/page/source_page/search.dart' as _i31;
import 'package:source_parser/page/source_page/source_page.dart' as _i30;
import 'package:source_parser/schema/theme.dart' as _i38;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i32.PageRouteInfo<void> {
  const AboutRoute({List<_i32.PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.AvailableSourceFormPage]
class AvailableSourceFormRoute extends _i32.PageRouteInfo<void> {
  const AvailableSourceFormRoute({List<_i32.PageRouteInfo>? children})
      : super(
          AvailableSourceFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'AvailableSourceFormRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i2.AvailableSourceFormPage();
    },
  );
}

/// generated route for
/// [_i3.AvailableSourcePage]
class AvailableSourceRoute
    extends _i32.PageRouteInfo<AvailableSourceRouteArgs> {
  AvailableSourceRoute({
    _i33.Key? key,
    List<_i34.AvailableSourceEntity>? availableSources,
    required _i35.BookEntity book,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
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

  final _i33.Key? key;

  final List<_i34.AvailableSourceEntity>? availableSources;

  final _i35.BookEntity book;

  @override
  String toString() {
    return 'AvailableSourceRouteArgs{key: $key, availableSources: $availableSources, book: $book}';
  }
}

/// generated route for
/// [_i4.BookFormPage]
class BookFormRoute extends _i32.PageRouteInfo<void> {
  const BookFormRoute({List<_i32.PageRouteInfo>? children})
      : super(
          BookFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookFormRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i4.BookFormPage();
    },
  );
}

/// generated route for
/// [_i5.CataloguePage]
class CatalogueRoute extends _i32.PageRouteInfo<CatalogueRouteArgs> {
  CatalogueRoute({
    _i33.Key? key,
    required _i35.BookEntity book,
    List<_i36.ChapterEntity>? chapters,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
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

  final _i33.Key? key;

  final _i35.BookEntity book;

  final List<_i36.ChapterEntity>? chapters;

  @override
  String toString() {
    return 'CatalogueRouteArgs{key: $key, book: $book, chapters: $chapters}';
  }
}

/// generated route for
/// [_i6.CloudReaderPage]
class CloudReaderRoute extends _i32.PageRouteInfo<void> {
  const CloudReaderRoute({List<_i32.PageRouteInfo>? children})
      : super(
          CloudReaderRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i6.CloudReaderPage();
    },
  );
}

/// generated route for
/// [_i7.CoverSelectorPage]
class CoverSelectorRoute extends _i32.PageRouteInfo<CoverSelectorRouteArgs> {
  CoverSelectorRoute({
    _i33.Key? key,
    required _i35.BookEntity book,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          CoverSelectorRoute.name,
          args: CoverSelectorRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CoverSelectorRoute';

  static _i32.PageInfo page = _i32.PageInfo(
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

  final _i33.Key? key;

  final _i35.BookEntity book;

  @override
  String toString() {
    return 'CoverSelectorRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i8.DatabasePage]
class DatabaseRoute extends _i32.PageRouteInfo<void> {
  const DatabaseRoute({List<_i32.PageRouteInfo>? children})
      : super(
          DatabaseRoute.name,
          initialChildren: children,
        );

  static const String name = 'DatabaseRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i8.DatabasePage();
    },
  );
}

/// generated route for
/// [_i9.DeveloperPage]
class DeveloperRoute extends _i32.PageRouteInfo<void> {
  const DeveloperRoute({List<_i32.PageRouteInfo>? children})
      : super(
          DeveloperRoute.name,
          initialChildren: children,
        );

  static const String name = 'DeveloperRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i9.DeveloperPage();
    },
  );
}

/// generated route for
/// [_i10.FileManagerPage]
class FileManagerRoute extends _i32.PageRouteInfo<void> {
  const FileManagerRoute({List<_i32.PageRouteInfo>? children})
      : super(
          FileManagerRoute.name,
          initialChildren: children,
        );

  static const String name = 'FileManagerRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i10.FileManagerPage();
    },
  );
}

/// generated route for
/// [_i11.HomePage]
class HomeRoute extends _i32.PageRouteInfo<void> {
  const HomeRoute({List<_i32.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i11.HomePage();
    },
  );
}

/// generated route for
/// [_i12.InformationPage]
class InformationRoute extends _i32.PageRouteInfo<InformationRouteArgs> {
  InformationRoute({
    _i33.Key? key,
    required _i37.InformationEntity information,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          InformationRoute.name,
          args: InformationRouteArgs(
            key: key,
            information: information,
          ),
          initialChildren: children,
        );

  static const String name = 'InformationRoute';

  static _i32.PageInfo page = _i32.PageInfo(
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

  final _i33.Key? key;

  final _i37.InformationEntity information;

  @override
  String toString() {
    return 'InformationRouteArgs{key: $key, information: $information}';
  }
}

/// generated route for
/// [_i13.LocalServerPage]
class LocalServerRoute extends _i32.PageRouteInfo<void> {
  const LocalServerRoute({List<_i32.PageRouteInfo>? children})
      : super(
          LocalServerRoute.name,
          initialChildren: children,
        );

  static const String name = 'LocalServerRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i13.LocalServerPage();
    },
  );
}

/// generated route for
/// [_i14.ReaderLayoutPage]
class ReaderLayoutRoute extends _i32.PageRouteInfo<void> {
  const ReaderLayoutRoute({List<_i32.PageRouteInfo>? children})
      : super(
          ReaderLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderLayoutRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i14.ReaderLayoutPage();
    },
  );
}

/// generated route for
/// [_i15.ReaderPage]
class ReaderRoute extends _i32.PageRouteInfo<ReaderRouteArgs> {
  ReaderRoute({
    _i33.Key? key,
    required _i35.BookEntity book,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          ReaderRoute.name,
          args: ReaderRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderRoute';

  static _i32.PageInfo page = _i32.PageInfo(
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

  final _i33.Key? key;

  final _i35.BookEntity book;

  @override
  String toString() {
    return 'ReaderRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i16.ReaderThemeEditorColorPickerPage]
class ReaderThemeEditorColorPickerRoute extends _i32.PageRouteInfo<void> {
  const ReaderThemeEditorColorPickerRoute({List<_i32.PageRouteInfo>? children})
      : super(
          ReaderThemeEditorColorPickerRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeEditorColorPickerRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i16.ReaderThemeEditorColorPickerPage();
    },
  );
}

/// generated route for
/// [_i17.ReaderThemeEditorImageSelectorPage]
class ReaderThemeEditorImageSelectorRoute extends _i32.PageRouteInfo<void> {
  const ReaderThemeEditorImageSelectorRoute(
      {List<_i32.PageRouteInfo>? children})
      : super(
          ReaderThemeEditorImageSelectorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeEditorImageSelectorRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i17.ReaderThemeEditorImageSelectorPage();
    },
  );
}

/// generated route for
/// [_i18.ReaderThemeEditorPage]
class ReaderThemeEditorRoute
    extends _i32.PageRouteInfo<ReaderThemeEditorRouteArgs> {
  ReaderThemeEditorRoute({
    _i33.Key? key,
    required _i38.Theme theme,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          ReaderThemeEditorRoute.name,
          args: ReaderThemeEditorRouteArgs(
            key: key,
            theme: theme,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderThemeEditorRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderThemeEditorRouteArgs>();
      return _i18.ReaderThemeEditorPage(
        key: args.key,
        theme: args.theme,
      );
    },
  );
}

class ReaderThemeEditorRouteArgs {
  const ReaderThemeEditorRouteArgs({
    this.key,
    required this.theme,
  });

  final _i33.Key? key;

  final _i38.Theme theme;

  @override
  String toString() {
    return 'ReaderThemeEditorRouteArgs{key: $key, theme: $theme}';
  }
}

/// generated route for
/// [_i19.ReaderThemePage]
class ReaderThemeRoute extends _i32.PageRouteInfo<void> {
  const ReaderThemeRoute({List<_i32.PageRouteInfo>? children})
      : super(
          ReaderThemeRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i19.ReaderThemePage();
    },
  );
}

/// generated route for
/// [_i20.SearchPage]
class SearchRoute extends _i32.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i33.Key? key,
    String? credential,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            credential: credential,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SearchRouteArgs>(orElse: () => const SearchRouteArgs());
      return _i20.SearchPage(
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

  final _i33.Key? key;

  final String? credential;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, credential: $credential}';
  }
}

/// generated route for
/// [_i21.SettingPage]
class SettingRoute extends _i32.PageRouteInfo<void> {
  const SettingRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i21.SettingPage();
    },
  );
}

/// generated route for
/// [_i22.SimpleCloudReaderPage]
class SimpleCloudReaderRoute extends _i32.PageRouteInfo<void> {
  const SimpleCloudReaderRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SimpleCloudReaderRoute.name,
          initialChildren: children,
        );

  static const String name = 'SimpleCloudReaderRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i22.SimpleCloudReaderPage();
    },
  );
}

/// generated route for
/// [_i23.SourceAdvancedConfigurationPage]
class SourceAdvancedConfigurationRoute extends _i32.PageRouteInfo<void> {
  const SourceAdvancedConfigurationRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SourceAdvancedConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceAdvancedConfigurationRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i23.SourceAdvancedConfigurationPage();
    },
  );
}

/// generated route for
/// [_i24.SourceCatalogueConfigurationPage]
class SourceCatalogueConfigurationRoute extends _i32.PageRouteInfo<void> {
  const SourceCatalogueConfigurationRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SourceCatalogueConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceCatalogueConfigurationRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i24.SourceCatalogueConfigurationPage();
    },
  );
}

/// generated route for
/// [_i25.SourceContentConfigurationPage]
class SourceContentConfigurationRoute extends _i32.PageRouteInfo<void> {
  const SourceContentConfigurationRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SourceContentConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceContentConfigurationRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i25.SourceContentConfigurationPage();
    },
  );
}

/// generated route for
/// [_i26.SourceDebuggerPage]
class SourceDebuggerRoute extends _i32.PageRouteInfo<void> {
  const SourceDebuggerRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SourceDebuggerRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceDebuggerRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i26.SourceDebuggerPage();
    },
  );
}

/// generated route for
/// [_i27.SourceFormDebugPage]
class SourceFormDebugRoute
    extends _i32.PageRouteInfo<SourceFormDebugRouteArgs> {
  SourceFormDebugRoute({
    _i33.Key? key,
    required _i39.SourceEntity source,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          SourceFormDebugRoute.name,
          args: SourceFormDebugRouteArgs(
            key: key,
            source: source,
          ),
          initialChildren: children,
        );

  static const String name = 'SourceFormDebugRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SourceFormDebugRouteArgs>();
      return _i27.SourceFormDebugPage(
        key: args.key,
        source: args.source,
      );
    },
  );
}

class SourceFormDebugRouteArgs {
  const SourceFormDebugRouteArgs({
    this.key,
    required this.source,
  });

  final _i33.Key? key;

  final _i39.SourceEntity source;

  @override
  String toString() {
    return 'SourceFormDebugRouteArgs{key: $key, source: $source}';
  }
}

/// generated route for
/// [_i28.SourceFormPage]
class SourceFormRoute extends _i32.PageRouteInfo<SourceFormRouteArgs> {
  SourceFormRoute({
    _i33.Key? key,
    _i39.SourceEntity? source,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          SourceFormRoute.name,
          args: SourceFormRouteArgs(
            key: key,
            source: source,
          ),
          initialChildren: children,
        );

  static const String name = 'SourceFormRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SourceFormRouteArgs>(
          orElse: () => const SourceFormRouteArgs());
      return _i28.SourceFormPage(
        key: args.key,
        source: args.source,
      );
    },
  );
}

class SourceFormRouteArgs {
  const SourceFormRouteArgs({
    this.key,
    this.source,
  });

  final _i33.Key? key;

  final _i39.SourceEntity? source;

  @override
  String toString() {
    return 'SourceFormRouteArgs{key: $key, source: $source}';
  }
}

/// generated route for
/// [_i29.SourceInformationConfigurationPage]
class SourceInformationConfigurationRoute extends _i32.PageRouteInfo<void> {
  const SourceInformationConfigurationRoute(
      {List<_i32.PageRouteInfo>? children})
      : super(
          SourceInformationConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceInformationConfigurationRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i29.SourceInformationConfigurationPage();
    },
  );
}

/// generated route for
/// [_i30.SourcePage]
class SourceRoute extends _i32.PageRouteInfo<void> {
  const SourceRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SourceRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i30.SourcePage();
    },
  );
}

/// generated route for
/// [_i31.SourceSearchConfigurationPage]
class SourceSearchConfigurationRoute extends _i32.PageRouteInfo<void> {
  const SourceSearchConfigurationRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SourceSearchConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceSearchConfigurationRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i31.SourceSearchConfigurationPage();
    },
  );
}
