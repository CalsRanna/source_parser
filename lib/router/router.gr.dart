// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i41;
import 'package:flutter/material.dart' as _i42;
import 'package:source_parser/model/available_source_entity.dart' as _i43;
import 'package:source_parser/model/book_entity.dart' as _i44;
import 'package:source_parser/model/chapter_entity.dart' as _i45;
import 'package:source_parser/model/cloud_book_entity.dart' as _i47;
import 'package:source_parser/model/cloud_search_book_entity.dart' as _i46;
import 'package:source_parser/model/information_entity.dart' as _i48;
import 'package:source_parser/model/source_entity.dart' as _i50;
import 'package:source_parser/page/about.dart' as _i1;
import 'package:source_parser/page/available_source/available_source_form_page.dart'
    as _i2;
import 'package:source_parser/page/available_source/available_source_page.dart'
    as _i3;
import 'package:source_parser/page/book/form.dart' as _i4;
import 'package:source_parser/page/catalogue/catalogue_page.dart' as _i5;
import 'package:source_parser/page/cloud_reader/cloud_reader_book_info_page.dart'
    as _i6;
import 'package:source_parser/page/cloud_reader/cloud_reader_bookshelf_page.dart'
    as _i7;
import 'package:source_parser/page/cloud_reader/cloud_reader_catalogue_page.dart'
    as _i8;
import 'package:source_parser/page/cloud_reader/cloud_reader_explore_page.dart'
    as _i9;
import 'package:source_parser/page/cloud_reader/cloud_reader_reader_page.dart'
    as _i10;
import 'package:source_parser/page/cloud_reader/cloud_reader_search_page.dart'
    as _i11;
import 'package:source_parser/page/cloud_reader/cloud_reader_setting_page.dart'
    as _i12;
import 'package:source_parser/page/cloud_reader/cloud_reader_source_page.dart'
    as _i13;
import 'package:source_parser/page/cover_selector/cover_selector_page.dart'
    as _i14;
import 'package:source_parser/page/database_page/database_page.dart' as _i15;
import 'package:source_parser/page/developer_page/developer_page.dart' as _i16;
import 'package:source_parser/page/file_manager.dart' as _i17;
import 'package:source_parser/page/home/home_page.dart' as _i18;
import 'package:source_parser/page/information/information_page.dart' as _i19;
import 'package:source_parser/page/layout.dart' as _i21;
import 'package:source_parser/page/local_server_page/local_server_page.dart'
    as _i20;
import 'package:source_parser/page/reader/reader_page.dart' as _i22;
import 'package:source_parser/page/reader_replacement/reader_replacement_page.dart'
    as _i25;
import 'package:source_parser/page/reader_replacement_form_page/reader_replacement_form_input_page.dart'
    as _i23;
import 'package:source_parser/page/reader_replacement_form_page/reader_replacement_form_page.dart'
    as _i24;
import 'package:source_parser/page/reader_theme/reader_theme_editor_color_picker_page.dart'
    as _i26;
import 'package:source_parser/page/reader_theme/reader_theme_editor_image_selector_page.dart'
    as _i27;
import 'package:source_parser/page/reader_theme/reader_theme_editor_page.dart'
    as _i28;
import 'package:source_parser/page/reader_theme/reader_theme_page.dart' as _i29;
import 'package:source_parser/page/search/search_page.dart' as _i30;
import 'package:source_parser/page/setting/setting_page.dart' as _i31;
import 'package:source_parser/page/source_form_page.dart/source_form_debug_page.dart'
    as _i36;
import 'package:source_parser/page/source_form_page.dart/source_form_page.dart'
    as _i37;
import 'package:source_parser/page/source_page/advanced.dart' as _i32;
import 'package:source_parser/page/source_page/catalogue.dart' as _i33;
import 'package:source_parser/page/source_page/content.dart' as _i34;
import 'package:source_parser/page/source_page/debugger.dart' as _i35;
import 'package:source_parser/page/source_page/information.dart' as _i38;
import 'package:source_parser/page/source_page/search.dart' as _i40;
import 'package:source_parser/page/source_page/source_page.dart' as _i39;
import 'package:source_parser/schema/theme.dart' as _i49;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i41.PageRouteInfo<void> {
  const AboutRoute({List<_i41.PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.AvailableSourceFormPage]
class AvailableSourceFormRoute extends _i41.PageRouteInfo<void> {
  const AvailableSourceFormRoute({List<_i41.PageRouteInfo>? children})
      : super(
          AvailableSourceFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'AvailableSourceFormRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i2.AvailableSourceFormPage();
    },
  );
}

/// generated route for
/// [_i3.AvailableSourcePage]
class AvailableSourceRoute
    extends _i41.PageRouteInfo<AvailableSourceRouteArgs> {
  AvailableSourceRoute({
    _i42.Key? key,
    List<_i43.AvailableSourceEntity>? availableSources,
    required _i44.BookEntity book,
    List<_i41.PageRouteInfo>? children,
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

  static _i41.PageInfo page = _i41.PageInfo(
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

  final _i42.Key? key;

  final List<_i43.AvailableSourceEntity>? availableSources;

  final _i44.BookEntity book;

  @override
  String toString() {
    return 'AvailableSourceRouteArgs{key: $key, availableSources: $availableSources, book: $book}';
  }
}

/// generated route for
/// [_i4.BookFormPage]
class BookFormRoute extends _i41.PageRouteInfo<void> {
  const BookFormRoute({List<_i41.PageRouteInfo>? children})
      : super(
          BookFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookFormRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i4.BookFormPage();
    },
  );
}

/// generated route for
/// [_i5.CataloguePage]
class CatalogueRoute extends _i41.PageRouteInfo<CatalogueRouteArgs> {
  CatalogueRoute({
    _i42.Key? key,
    required _i44.BookEntity book,
    List<_i45.ChapterEntity>? chapters,
    List<_i41.PageRouteInfo>? children,
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

  static _i41.PageInfo page = _i41.PageInfo(
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

  final _i42.Key? key;

  final _i44.BookEntity book;

  final List<_i45.ChapterEntity>? chapters;

  @override
  String toString() {
    return 'CatalogueRouteArgs{key: $key, book: $book, chapters: $chapters}';
  }
}

/// generated route for
/// [_i6.CloudReaderBookInfoPage]
class CloudReaderBookInfoRoute
    extends _i41.PageRouteInfo<CloudReaderBookInfoRouteArgs> {
  CloudReaderBookInfoRoute({
    _i42.Key? key,
    required _i46.CloudSearchBookEntity book,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          CloudReaderBookInfoRoute.name,
          args: CloudReaderBookInfoRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CloudReaderBookInfoRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CloudReaderBookInfoRouteArgs>();
      return _i6.CloudReaderBookInfoPage(
        key: args.key,
        book: args.book,
      );
    },
  );
}

class CloudReaderBookInfoRouteArgs {
  const CloudReaderBookInfoRouteArgs({
    this.key,
    required this.book,
  });

  final _i42.Key? key;

  final _i46.CloudSearchBookEntity book;

  @override
  String toString() {
    return 'CloudReaderBookInfoRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i7.CloudReaderBookshelfPage]
class CloudReaderBookshelfRoute extends _i41.PageRouteInfo<void> {
  const CloudReaderBookshelfRoute({List<_i41.PageRouteInfo>? children})
      : super(
          CloudReaderBookshelfRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderBookshelfRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i7.CloudReaderBookshelfPage();
    },
  );
}

/// generated route for
/// [_i8.CloudReaderCataloguePage]
class CloudReaderCatalogueRoute
    extends _i41.PageRouteInfo<CloudReaderCatalogueRouteArgs> {
  CloudReaderCatalogueRoute({
    _i42.Key? key,
    required String bookUrl,
    required int currentIndex,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          CloudReaderCatalogueRoute.name,
          args: CloudReaderCatalogueRouteArgs(
            key: key,
            bookUrl: bookUrl,
            currentIndex: currentIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'CloudReaderCatalogueRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CloudReaderCatalogueRouteArgs>();
      return _i8.CloudReaderCataloguePage(
        key: args.key,
        bookUrl: args.bookUrl,
        currentIndex: args.currentIndex,
      );
    },
  );
}

class CloudReaderCatalogueRouteArgs {
  const CloudReaderCatalogueRouteArgs({
    this.key,
    required this.bookUrl,
    required this.currentIndex,
  });

  final _i42.Key? key;

  final String bookUrl;

  final int currentIndex;

  @override
  String toString() {
    return 'CloudReaderCatalogueRouteArgs{key: $key, bookUrl: $bookUrl, currentIndex: $currentIndex}';
  }
}

/// generated route for
/// [_i9.CloudReaderExplorePage]
class CloudReaderExploreRoute extends _i41.PageRouteInfo<void> {
  const CloudReaderExploreRoute({List<_i41.PageRouteInfo>? children})
      : super(
          CloudReaderExploreRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderExploreRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i9.CloudReaderExplorePage();
    },
  );
}

/// generated route for
/// [_i10.CloudReaderReaderPage]
class CloudReaderReaderRoute
    extends _i41.PageRouteInfo<CloudReaderReaderRouteArgs> {
  CloudReaderReaderRoute({
    _i42.Key? key,
    required _i47.CloudBookEntity book,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          CloudReaderReaderRoute.name,
          args: CloudReaderReaderRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CloudReaderReaderRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CloudReaderReaderRouteArgs>();
      return _i10.CloudReaderReaderPage(
        key: args.key,
        book: args.book,
      );
    },
  );
}

class CloudReaderReaderRouteArgs {
  const CloudReaderReaderRouteArgs({
    this.key,
    required this.book,
  });

  final _i42.Key? key;

  final _i47.CloudBookEntity book;

  @override
  String toString() {
    return 'CloudReaderReaderRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i11.CloudReaderSearchPage]
class CloudReaderSearchRoute extends _i41.PageRouteInfo<void> {
  const CloudReaderSearchRoute({List<_i41.PageRouteInfo>? children})
      : super(
          CloudReaderSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderSearchRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i11.CloudReaderSearchPage();
    },
  );
}

/// generated route for
/// [_i12.CloudReaderSettingPage]
class CloudReaderSettingRoute extends _i41.PageRouteInfo<void> {
  const CloudReaderSettingRoute({List<_i41.PageRouteInfo>? children})
      : super(
          CloudReaderSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderSettingRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i12.CloudReaderSettingPage();
    },
  );
}

/// generated route for
/// [_i13.CloudReaderSourcePage]
class CloudReaderSourceRoute
    extends _i41.PageRouteInfo<CloudReaderSourceRouteArgs> {
  CloudReaderSourceRoute({
    _i42.Key? key,
    required String bookUrl,
    required String currentOrigin,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          CloudReaderSourceRoute.name,
          args: CloudReaderSourceRouteArgs(
            key: key,
            bookUrl: bookUrl,
            currentOrigin: currentOrigin,
          ),
          initialChildren: children,
        );

  static const String name = 'CloudReaderSourceRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CloudReaderSourceRouteArgs>();
      return _i13.CloudReaderSourcePage(
        key: args.key,
        bookUrl: args.bookUrl,
        currentOrigin: args.currentOrigin,
      );
    },
  );
}

class CloudReaderSourceRouteArgs {
  const CloudReaderSourceRouteArgs({
    this.key,
    required this.bookUrl,
    required this.currentOrigin,
  });

  final _i42.Key? key;

  final String bookUrl;

  final String currentOrigin;

  @override
  String toString() {
    return 'CloudReaderSourceRouteArgs{key: $key, bookUrl: $bookUrl, currentOrigin: $currentOrigin}';
  }
}

/// generated route for
/// [_i14.CoverSelectorPage]
class CoverSelectorRoute extends _i41.PageRouteInfo<CoverSelectorRouteArgs> {
  CoverSelectorRoute({
    _i42.Key? key,
    required _i44.BookEntity book,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          CoverSelectorRoute.name,
          args: CoverSelectorRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CoverSelectorRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CoverSelectorRouteArgs>();
      return _i14.CoverSelectorPage(
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

  final _i42.Key? key;

  final _i44.BookEntity book;

  @override
  String toString() {
    return 'CoverSelectorRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i15.DatabasePage]
class DatabaseRoute extends _i41.PageRouteInfo<void> {
  const DatabaseRoute({List<_i41.PageRouteInfo>? children})
      : super(
          DatabaseRoute.name,
          initialChildren: children,
        );

  static const String name = 'DatabaseRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i15.DatabasePage();
    },
  );
}

/// generated route for
/// [_i16.DeveloperPage]
class DeveloperRoute extends _i41.PageRouteInfo<void> {
  const DeveloperRoute({List<_i41.PageRouteInfo>? children})
      : super(
          DeveloperRoute.name,
          initialChildren: children,
        );

  static const String name = 'DeveloperRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i16.DeveloperPage();
    },
  );
}

/// generated route for
/// [_i17.FileManagerPage]
class FileManagerRoute extends _i41.PageRouteInfo<void> {
  const FileManagerRoute({List<_i41.PageRouteInfo>? children})
      : super(
          FileManagerRoute.name,
          initialChildren: children,
        );

  static const String name = 'FileManagerRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i17.FileManagerPage();
    },
  );
}

/// generated route for
/// [_i18.HomePage]
class HomeRoute extends _i41.PageRouteInfo<void> {
  const HomeRoute({List<_i41.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i18.HomePage();
    },
  );
}

/// generated route for
/// [_i19.InformationPage]
class InformationRoute extends _i41.PageRouteInfo<InformationRouteArgs> {
  InformationRoute({
    _i42.Key? key,
    required _i48.InformationEntity information,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          InformationRoute.name,
          args: InformationRouteArgs(
            key: key,
            information: information,
          ),
          initialChildren: children,
        );

  static const String name = 'InformationRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InformationRouteArgs>();
      return _i19.InformationPage(
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

  final _i42.Key? key;

  final _i48.InformationEntity information;

  @override
  String toString() {
    return 'InformationRouteArgs{key: $key, information: $information}';
  }
}

/// generated route for
/// [_i20.LocalServerPage]
class LocalServerRoute extends _i41.PageRouteInfo<void> {
  const LocalServerRoute({List<_i41.PageRouteInfo>? children})
      : super(
          LocalServerRoute.name,
          initialChildren: children,
        );

  static const String name = 'LocalServerRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i20.LocalServerPage();
    },
  );
}

/// generated route for
/// [_i21.ReaderLayoutPage]
class ReaderLayoutRoute extends _i41.PageRouteInfo<void> {
  const ReaderLayoutRoute({List<_i41.PageRouteInfo>? children})
      : super(
          ReaderLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderLayoutRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i21.ReaderLayoutPage();
    },
  );
}

/// generated route for
/// [_i22.ReaderPage]
class ReaderRoute extends _i41.PageRouteInfo<ReaderRouteArgs> {
  ReaderRoute({
    _i42.Key? key,
    required _i44.BookEntity book,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          ReaderRoute.name,
          args: ReaderRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderRouteArgs>();
      return _i22.ReaderPage(
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

  final _i42.Key? key;

  final _i44.BookEntity book;

  @override
  String toString() {
    return 'ReaderRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i23.ReaderReplacementFormInputPage]
class ReaderReplacementFormInputRoute
    extends _i41.PageRouteInfo<ReaderReplacementFormInputRouteArgs> {
  ReaderReplacementFormInputRoute({
    _i42.Key? key,
    required String title,
    required String value,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          ReaderReplacementFormInputRoute.name,
          args: ReaderReplacementFormInputRouteArgs(
            key: key,
            title: title,
            value: value,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderReplacementFormInputRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderReplacementFormInputRouteArgs>();
      return _i23.ReaderReplacementFormInputPage(
        key: args.key,
        title: args.title,
        value: args.value,
      );
    },
  );
}

class ReaderReplacementFormInputRouteArgs {
  const ReaderReplacementFormInputRouteArgs({
    this.key,
    required this.title,
    required this.value,
  });

  final _i42.Key? key;

  final String title;

  final String value;

  @override
  String toString() {
    return 'ReaderReplacementFormInputRouteArgs{key: $key, title: $title, value: $value}';
  }
}

/// generated route for
/// [_i24.ReaderReplacementFormPage]
class ReaderReplacementFormRoute extends _i41.PageRouteInfo<void> {
  const ReaderReplacementFormRoute({List<_i41.PageRouteInfo>? children})
      : super(
          ReaderReplacementFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderReplacementFormRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i24.ReaderReplacementFormPage();
    },
  );
}

/// generated route for
/// [_i25.ReaderReplacementPage]
class ReaderReplacementRoute
    extends _i41.PageRouteInfo<ReaderReplacementRouteArgs> {
  ReaderReplacementRoute({
    _i42.Key? key,
    required _i44.BookEntity book,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          ReaderReplacementRoute.name,
          args: ReaderReplacementRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderReplacementRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderReplacementRouteArgs>();
      return _i25.ReaderReplacementPage(
        key: args.key,
        book: args.book,
      );
    },
  );
}

class ReaderReplacementRouteArgs {
  const ReaderReplacementRouteArgs({
    this.key,
    required this.book,
  });

  final _i42.Key? key;

  final _i44.BookEntity book;

  @override
  String toString() {
    return 'ReaderReplacementRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i26.ReaderThemeEditorColorPickerPage]
class ReaderThemeEditorColorPickerRoute extends _i41.PageRouteInfo<void> {
  const ReaderThemeEditorColorPickerRoute({List<_i41.PageRouteInfo>? children})
      : super(
          ReaderThemeEditorColorPickerRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeEditorColorPickerRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i26.ReaderThemeEditorColorPickerPage();
    },
  );
}

/// generated route for
/// [_i27.ReaderThemeEditorImageSelectorPage]
class ReaderThemeEditorImageSelectorRoute extends _i41.PageRouteInfo<void> {
  const ReaderThemeEditorImageSelectorRoute(
      {List<_i41.PageRouteInfo>? children})
      : super(
          ReaderThemeEditorImageSelectorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeEditorImageSelectorRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i27.ReaderThemeEditorImageSelectorPage();
    },
  );
}

/// generated route for
/// [_i28.ReaderThemeEditorPage]
class ReaderThemeEditorRoute
    extends _i41.PageRouteInfo<ReaderThemeEditorRouteArgs> {
  ReaderThemeEditorRoute({
    _i42.Key? key,
    required _i49.Theme theme,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          ReaderThemeEditorRoute.name,
          args: ReaderThemeEditorRouteArgs(
            key: key,
            theme: theme,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderThemeEditorRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderThemeEditorRouteArgs>();
      return _i28.ReaderThemeEditorPage(
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

  final _i42.Key? key;

  final _i49.Theme theme;

  @override
  String toString() {
    return 'ReaderThemeEditorRouteArgs{key: $key, theme: $theme}';
  }
}

/// generated route for
/// [_i29.ReaderThemePage]
class ReaderThemeRoute extends _i41.PageRouteInfo<void> {
  const ReaderThemeRoute({List<_i41.PageRouteInfo>? children})
      : super(
          ReaderThemeRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i29.ReaderThemePage();
    },
  );
}

/// generated route for
/// [_i30.SearchPage]
class SearchRoute extends _i41.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i42.Key? key,
    String? credential,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            credential: credential,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SearchRouteArgs>(orElse: () => const SearchRouteArgs());
      return _i30.SearchPage(
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

  final _i42.Key? key;

  final String? credential;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, credential: $credential}';
  }
}

/// generated route for
/// [_i31.SettingPage]
class SettingRoute extends _i41.PageRouteInfo<void> {
  const SettingRoute({List<_i41.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i31.SettingPage();
    },
  );
}

/// generated route for
/// [_i32.SourceAdvancedConfigurationPage]
class SourceAdvancedConfigurationRoute extends _i41.PageRouteInfo<void> {
  const SourceAdvancedConfigurationRoute({List<_i41.PageRouteInfo>? children})
      : super(
          SourceAdvancedConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceAdvancedConfigurationRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i32.SourceAdvancedConfigurationPage();
    },
  );
}

/// generated route for
/// [_i33.SourceCatalogueConfigurationPage]
class SourceCatalogueConfigurationRoute extends _i41.PageRouteInfo<void> {
  const SourceCatalogueConfigurationRoute({List<_i41.PageRouteInfo>? children})
      : super(
          SourceCatalogueConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceCatalogueConfigurationRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i33.SourceCatalogueConfigurationPage();
    },
  );
}

/// generated route for
/// [_i34.SourceContentConfigurationPage]
class SourceContentConfigurationRoute extends _i41.PageRouteInfo<void> {
  const SourceContentConfigurationRoute({List<_i41.PageRouteInfo>? children})
      : super(
          SourceContentConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceContentConfigurationRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i34.SourceContentConfigurationPage();
    },
  );
}

/// generated route for
/// [_i35.SourceDebuggerPage]
class SourceDebuggerRoute extends _i41.PageRouteInfo<void> {
  const SourceDebuggerRoute({List<_i41.PageRouteInfo>? children})
      : super(
          SourceDebuggerRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceDebuggerRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i35.SourceDebuggerPage();
    },
  );
}

/// generated route for
/// [_i36.SourceFormDebugPage]
class SourceFormDebugRoute
    extends _i41.PageRouteInfo<SourceFormDebugRouteArgs> {
  SourceFormDebugRoute({
    _i42.Key? key,
    required _i50.SourceEntity source,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          SourceFormDebugRoute.name,
          args: SourceFormDebugRouteArgs(
            key: key,
            source: source,
          ),
          initialChildren: children,
        );

  static const String name = 'SourceFormDebugRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SourceFormDebugRouteArgs>();
      return _i36.SourceFormDebugPage(
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

  final _i42.Key? key;

  final _i50.SourceEntity source;

  @override
  String toString() {
    return 'SourceFormDebugRouteArgs{key: $key, source: $source}';
  }
}

/// generated route for
/// [_i37.SourceFormPage]
class SourceFormRoute extends _i41.PageRouteInfo<SourceFormRouteArgs> {
  SourceFormRoute({
    _i42.Key? key,
    _i50.SourceEntity? source,
    List<_i41.PageRouteInfo>? children,
  }) : super(
          SourceFormRoute.name,
          args: SourceFormRouteArgs(
            key: key,
            source: source,
          ),
          initialChildren: children,
        );

  static const String name = 'SourceFormRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SourceFormRouteArgs>(
          orElse: () => const SourceFormRouteArgs());
      return _i37.SourceFormPage(
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

  final _i42.Key? key;

  final _i50.SourceEntity? source;

  @override
  String toString() {
    return 'SourceFormRouteArgs{key: $key, source: $source}';
  }
}

/// generated route for
/// [_i38.SourceInformationConfigurationPage]
class SourceInformationConfigurationRoute extends _i41.PageRouteInfo<void> {
  const SourceInformationConfigurationRoute(
      {List<_i41.PageRouteInfo>? children})
      : super(
          SourceInformationConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceInformationConfigurationRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i38.SourceInformationConfigurationPage();
    },
  );
}

/// generated route for
/// [_i39.SourcePage]
class SourceRoute extends _i41.PageRouteInfo<void> {
  const SourceRoute({List<_i41.PageRouteInfo>? children})
      : super(
          SourceRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i39.SourcePage();
    },
  );
}

/// generated route for
/// [_i40.SourceSearchConfigurationPage]
class SourceSearchConfigurationRoute extends _i41.PageRouteInfo<void> {
  const SourceSearchConfigurationRoute({List<_i41.PageRouteInfo>? children})
      : super(
          SourceSearchConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceSearchConfigurationRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i40.SourceSearchConfigurationPage();
    },
  );
}
