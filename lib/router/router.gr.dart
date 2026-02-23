// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i46;
import 'package:flutter/material.dart' as _i47;
import 'package:source_parser/model/available_source_entity.dart' as _i48;
import 'package:source_parser/model/book_entity.dart' as _i49;
import 'package:source_parser/model/chapter_entity.dart' as _i50;
import 'package:source_parser/model/cloud_book_entity.dart' as _i52;
import 'package:source_parser/model/cloud_search_book_entity.dart' as _i51;
import 'package:source_parser/model/information_entity.dart' as _i54;
import 'package:source_parser/model/source_entity.dart' as _i56;
import 'package:source_parser/page/about.dart' as _i1;
import 'package:source_parser/page/available_source/available_source_form_page.dart'
    as _i3;
import 'package:source_parser/page/available_source/available_source_page.dart'
    as _i4;
import 'package:source_parser/page/book/form.dart' as _i5;
import 'package:source_parser/page/catalogue/catalogue_page.dart' as _i6;
import 'package:source_parser/page/cloud_reader/cloud_reader_book_info_page.dart'
    as _i7;
import 'package:source_parser/page/cloud_reader/cloud_reader_bookshelf_page.dart'
    as _i8;
import 'package:source_parser/page/cloud_reader/cloud_reader_catalogue_page.dart'
    as _i9;
import 'package:source_parser/page/cloud_reader/cloud_reader_explore_page.dart'
    as _i10;
import 'package:source_parser/page/cloud_reader/cloud_reader_reader_page.dart'
    as _i11;
import 'package:source_parser/page/cloud_reader/cloud_reader_search_page.dart'
    as _i12;
import 'package:source_parser/page/cloud_reader/cloud_reader_setting_page.dart'
    as _i13;
import 'package:source_parser/page/cloud_reader/cloud_reader_source_page.dart'
    as _i14;
import 'package:source_parser/page/cover_selector/cover_selector_page.dart'
    as _i15;
import 'package:source_parser/page/database_page/database_page.dart' as _i16;
import 'package:source_parser/page/debug/json_data_page.dart' as _i22;
import 'package:source_parser/page/debug/raw_data_page.dart' as _i24;
import 'package:source_parser/page/developer_page/developer_page.dart' as _i17;
import 'package:source_parser/page/explore.dart' as _i18;
import 'package:source_parser/page/file_manager.dart' as _i19;
import 'package:source_parser/page/home/home_page.dart' as _i20;
import 'package:source_parser/page/information/information_page.dart' as _i21;
import 'package:source_parser/page/layout.dart' as _i25;
import 'package:source_parser/page/local_server_page/local_server_page.dart'
    as _i23;
import 'package:source_parser/page/reader/reader_page.dart' as _i26;
import 'package:source_parser/page/reader_replacement/reader_replacement_page.dart'
    as _i29;
import 'package:source_parser/page/reader_replacement_form_page/reader_replacement_form_input_page.dart'
    as _i27;
import 'package:source_parser/page/reader_replacement_form_page/reader_replacement_form_page.dart'
    as _i28;
import 'package:source_parser/page/reader_theme/reader_theme_editor_color_picker_page.dart'
    as _i30;
import 'package:source_parser/page/reader_theme/reader_theme_editor_image_selector_page.dart'
    as _i31;
import 'package:source_parser/page/reader_theme/reader_theme_editor_page.dart'
    as _i32;
import 'package:source_parser/page/reader_theme/reader_theme_page.dart' as _i33;
import 'package:source_parser/page/search/search_page.dart' as _i35;
import 'package:source_parser/page/setting/ai_setting_page.dart' as _i2;
import 'package:source_parser/page/setting/setting_page.dart' as _i36;
import 'package:source_parser/page/source_form_page.dart/source_form_debug_page.dart'
    as _i41;
import 'package:source_parser/page/source_form_page.dart/source_form_page.dart'
    as _i42;
import 'package:source_parser/page/source_page/advanced.dart' as _i37;
import 'package:source_parser/page/source_page/catalogue.dart' as _i38;
import 'package:source_parser/page/source_page/content.dart' as _i39;
import 'package:source_parser/page/source_page/debugger.dart' as _i40;
import 'package:source_parser/page/source_page/information.dart' as _i43;
import 'package:source_parser/page/source_page/rule_input.dart' as _i34;
import 'package:source_parser/page/source_page/search.dart' as _i45;
import 'package:source_parser/page/source_page/source_page.dart' as _i44;
import 'package:source_parser/schema/book.dart' as _i53;
import 'package:source_parser/schema/theme.dart' as _i55;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i46.PageRouteInfo<void> {
  const AboutRoute({List<_i46.PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.AiSettingPage]
class AiSettingRoute extends _i46.PageRouteInfo<void> {
  const AiSettingRoute({List<_i46.PageRouteInfo>? children})
      : super(
          AiSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'AiSettingRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i2.AiSettingPage();
    },
  );
}

/// generated route for
/// [_i3.AvailableSourceFormPage]
class AvailableSourceFormRoute extends _i46.PageRouteInfo<void> {
  const AvailableSourceFormRoute({List<_i46.PageRouteInfo>? children})
      : super(
          AvailableSourceFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'AvailableSourceFormRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i3.AvailableSourceFormPage();
    },
  );
}

/// generated route for
/// [_i4.AvailableSourcePage]
class AvailableSourceRoute
    extends _i46.PageRouteInfo<AvailableSourceRouteArgs> {
  AvailableSourceRoute({
    _i47.Key? key,
    List<_i48.AvailableSourceEntity>? availableSources,
    required _i49.BookEntity book,
    List<_i46.PageRouteInfo>? children,
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

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AvailableSourceRouteArgs>();
      return _i4.AvailableSourcePage(
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

  final _i47.Key? key;

  final List<_i48.AvailableSourceEntity>? availableSources;

  final _i49.BookEntity book;

  @override
  String toString() {
    return 'AvailableSourceRouteArgs{key: $key, availableSources: $availableSources, book: $book}';
  }
}

/// generated route for
/// [_i5.BookFormPage]
class BookFormRoute extends _i46.PageRouteInfo<void> {
  const BookFormRoute({List<_i46.PageRouteInfo>? children})
      : super(
          BookFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookFormRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i5.BookFormPage();
    },
  );
}

/// generated route for
/// [_i6.CataloguePage]
class CatalogueRoute extends _i46.PageRouteInfo<CatalogueRouteArgs> {
  CatalogueRoute({
    _i47.Key? key,
    required _i49.BookEntity book,
    List<_i50.ChapterEntity>? chapters,
    List<_i46.PageRouteInfo>? children,
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

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CatalogueRouteArgs>();
      return _i6.CataloguePage(
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

  final _i47.Key? key;

  final _i49.BookEntity book;

  final List<_i50.ChapterEntity>? chapters;

  @override
  String toString() {
    return 'CatalogueRouteArgs{key: $key, book: $book, chapters: $chapters}';
  }
}

/// generated route for
/// [_i7.CloudReaderBookInfoPage]
class CloudReaderBookInfoRoute
    extends _i46.PageRouteInfo<CloudReaderBookInfoRouteArgs> {
  CloudReaderBookInfoRoute({
    _i47.Key? key,
    required _i51.CloudSearchBookEntity book,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          CloudReaderBookInfoRoute.name,
          args: CloudReaderBookInfoRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CloudReaderBookInfoRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CloudReaderBookInfoRouteArgs>();
      return _i7.CloudReaderBookInfoPage(
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

  final _i47.Key? key;

  final _i51.CloudSearchBookEntity book;

  @override
  String toString() {
    return 'CloudReaderBookInfoRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i8.CloudReaderBookshelfPage]
class CloudReaderBookshelfRoute extends _i46.PageRouteInfo<void> {
  const CloudReaderBookshelfRoute({List<_i46.PageRouteInfo>? children})
      : super(
          CloudReaderBookshelfRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderBookshelfRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i8.CloudReaderBookshelfPage();
    },
  );
}

/// generated route for
/// [_i9.CloudReaderCataloguePage]
class CloudReaderCatalogueRoute
    extends _i46.PageRouteInfo<CloudReaderCatalogueRouteArgs> {
  CloudReaderCatalogueRoute({
    _i47.Key? key,
    required String bookUrl,
    required int currentIndex,
    List<_i46.PageRouteInfo>? children,
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

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CloudReaderCatalogueRouteArgs>();
      return _i9.CloudReaderCataloguePage(
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

  final _i47.Key? key;

  final String bookUrl;

  final int currentIndex;

  @override
  String toString() {
    return 'CloudReaderCatalogueRouteArgs{key: $key, bookUrl: $bookUrl, currentIndex: $currentIndex}';
  }
}

/// generated route for
/// [_i10.CloudReaderExplorePage]
class CloudReaderExploreRoute extends _i46.PageRouteInfo<void> {
  const CloudReaderExploreRoute({List<_i46.PageRouteInfo>? children})
      : super(
          CloudReaderExploreRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderExploreRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i10.CloudReaderExplorePage();
    },
  );
}

/// generated route for
/// [_i11.CloudReaderReaderPage]
class CloudReaderReaderRoute
    extends _i46.PageRouteInfo<CloudReaderReaderRouteArgs> {
  CloudReaderReaderRoute({
    _i47.Key? key,
    required _i52.CloudBookEntity book,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          CloudReaderReaderRoute.name,
          args: CloudReaderReaderRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CloudReaderReaderRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CloudReaderReaderRouteArgs>();
      return _i11.CloudReaderReaderPage(
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

  final _i47.Key? key;

  final _i52.CloudBookEntity book;

  @override
  String toString() {
    return 'CloudReaderReaderRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i12.CloudReaderSearchPage]
class CloudReaderSearchRoute extends _i46.PageRouteInfo<void> {
  const CloudReaderSearchRoute({List<_i46.PageRouteInfo>? children})
      : super(
          CloudReaderSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderSearchRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i12.CloudReaderSearchPage();
    },
  );
}

/// generated route for
/// [_i13.CloudReaderSettingPage]
class CloudReaderSettingRoute extends _i46.PageRouteInfo<void> {
  const CloudReaderSettingRoute({List<_i46.PageRouteInfo>? children})
      : super(
          CloudReaderSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'CloudReaderSettingRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i13.CloudReaderSettingPage();
    },
  );
}

/// generated route for
/// [_i14.CloudReaderSourcePage]
class CloudReaderSourceRoute
    extends _i46.PageRouteInfo<CloudReaderSourceRouteArgs> {
  CloudReaderSourceRoute({
    _i47.Key? key,
    required String bookUrl,
    required String currentOrigin,
    List<_i46.PageRouteInfo>? children,
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

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CloudReaderSourceRouteArgs>();
      return _i14.CloudReaderSourcePage(
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

  final _i47.Key? key;

  final String bookUrl;

  final String currentOrigin;

  @override
  String toString() {
    return 'CloudReaderSourceRouteArgs{key: $key, bookUrl: $bookUrl, currentOrigin: $currentOrigin}';
  }
}

/// generated route for
/// [_i15.CoverSelectorPage]
class CoverSelectorRoute extends _i46.PageRouteInfo<CoverSelectorRouteArgs> {
  CoverSelectorRoute({
    _i47.Key? key,
    required _i49.BookEntity book,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          CoverSelectorRoute.name,
          args: CoverSelectorRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'CoverSelectorRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CoverSelectorRouteArgs>();
      return _i15.CoverSelectorPage(
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

  final _i47.Key? key;

  final _i49.BookEntity book;

  @override
  String toString() {
    return 'CoverSelectorRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i16.DatabasePage]
class DatabaseRoute extends _i46.PageRouteInfo<void> {
  const DatabaseRoute({List<_i46.PageRouteInfo>? children})
      : super(
          DatabaseRoute.name,
          initialChildren: children,
        );

  static const String name = 'DatabaseRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i16.DatabasePage();
    },
  );
}

/// generated route for
/// [_i17.DeveloperPage]
class DeveloperRoute extends _i46.PageRouteInfo<void> {
  const DeveloperRoute({List<_i46.PageRouteInfo>? children})
      : super(
          DeveloperRoute.name,
          initialChildren: children,
        );

  static const String name = 'DeveloperRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i17.DeveloperPage();
    },
  );
}

/// generated route for
/// [_i18.ExploreListPage]
class ExploreListRoute extends _i46.PageRouteInfo<ExploreListRouteArgs> {
  ExploreListRoute({
    _i47.Key? key,
    required List<_i53.Book> books,
    required String title,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          ExploreListRoute.name,
          args: ExploreListRouteArgs(
            key: key,
            books: books,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'ExploreListRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ExploreListRouteArgs>();
      return _i18.ExploreListPage(
        key: args.key,
        books: args.books,
        title: args.title,
      );
    },
  );
}

class ExploreListRouteArgs {
  const ExploreListRouteArgs({
    this.key,
    required this.books,
    required this.title,
  });

  final _i47.Key? key;

  final List<_i53.Book> books;

  final String title;

  @override
  String toString() {
    return 'ExploreListRouteArgs{key: $key, books: $books, title: $title}';
  }
}

/// generated route for
/// [_i19.FileManagerPage]
class FileManagerRoute extends _i46.PageRouteInfo<void> {
  const FileManagerRoute({List<_i46.PageRouteInfo>? children})
      : super(
          FileManagerRoute.name,
          initialChildren: children,
        );

  static const String name = 'FileManagerRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i19.FileManagerPage();
    },
  );
}

/// generated route for
/// [_i20.HomePage]
class HomeRoute extends _i46.PageRouteInfo<void> {
  const HomeRoute({List<_i46.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i20.HomePage();
    },
  );
}

/// generated route for
/// [_i21.InformationPage]
class InformationRoute extends _i46.PageRouteInfo<InformationRouteArgs> {
  InformationRoute({
    _i47.Key? key,
    required _i54.InformationEntity information,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          InformationRoute.name,
          args: InformationRouteArgs(
            key: key,
            information: information,
          ),
          initialChildren: children,
        );

  static const String name = 'InformationRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InformationRouteArgs>();
      return _i21.InformationPage(
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

  final _i47.Key? key;

  final _i54.InformationEntity information;

  @override
  String toString() {
    return 'InformationRouteArgs{key: $key, information: $information}';
  }
}

/// generated route for
/// [_i22.JsonDataPage]
class JsonDataRoute extends _i46.PageRouteInfo<JsonDataRouteArgs> {
  JsonDataRoute({
    _i47.Key? key,
    required String data,
    String? title,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          JsonDataRoute.name,
          args: JsonDataRouteArgs(
            key: key,
            data: data,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'JsonDataRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<JsonDataRouteArgs>();
      return _i22.JsonDataPage(
        key: args.key,
        data: args.data,
        title: args.title,
      );
    },
  );
}

class JsonDataRouteArgs {
  const JsonDataRouteArgs({
    this.key,
    required this.data,
    this.title,
  });

  final _i47.Key? key;

  final String data;

  final String? title;

  @override
  String toString() {
    return 'JsonDataRouteArgs{key: $key, data: $data, title: $title}';
  }
}

/// generated route for
/// [_i23.LocalServerPage]
class LocalServerRoute extends _i46.PageRouteInfo<void> {
  const LocalServerRoute({List<_i46.PageRouteInfo>? children})
      : super(
          LocalServerRoute.name,
          initialChildren: children,
        );

  static const String name = 'LocalServerRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i23.LocalServerPage();
    },
  );
}

/// generated route for
/// [_i24.RawDataPage]
class RawDataRoute extends _i46.PageRouteInfo<RawDataRouteArgs> {
  RawDataRoute({
    _i47.Key? key,
    required String data,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          RawDataRoute.name,
          args: RawDataRouteArgs(
            key: key,
            data: data,
          ),
          initialChildren: children,
        );

  static const String name = 'RawDataRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RawDataRouteArgs>();
      return _i24.RawDataPage(
        key: args.key,
        data: args.data,
      );
    },
  );
}

class RawDataRouteArgs {
  const RawDataRouteArgs({
    this.key,
    required this.data,
  });

  final _i47.Key? key;

  final String data;

  @override
  String toString() {
    return 'RawDataRouteArgs{key: $key, data: $data}';
  }
}

/// generated route for
/// [_i25.ReaderLayoutPage]
class ReaderLayoutRoute extends _i46.PageRouteInfo<void> {
  const ReaderLayoutRoute({List<_i46.PageRouteInfo>? children})
      : super(
          ReaderLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderLayoutRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i25.ReaderLayoutPage();
    },
  );
}

/// generated route for
/// [_i26.ReaderPage]
class ReaderRoute extends _i46.PageRouteInfo<ReaderRouteArgs> {
  ReaderRoute({
    _i47.Key? key,
    required _i49.BookEntity book,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          ReaderRoute.name,
          args: ReaderRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderRouteArgs>();
      return _i26.ReaderPage(
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

  final _i47.Key? key;

  final _i49.BookEntity book;

  @override
  String toString() {
    return 'ReaderRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i27.ReaderReplacementFormInputPage]
class ReaderReplacementFormInputRoute
    extends _i46.PageRouteInfo<ReaderReplacementFormInputRouteArgs> {
  ReaderReplacementFormInputRoute({
    _i47.Key? key,
    required String title,
    required String value,
    List<_i46.PageRouteInfo>? children,
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

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderReplacementFormInputRouteArgs>();
      return _i27.ReaderReplacementFormInputPage(
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

  final _i47.Key? key;

  final String title;

  final String value;

  @override
  String toString() {
    return 'ReaderReplacementFormInputRouteArgs{key: $key, title: $title, value: $value}';
  }
}

/// generated route for
/// [_i28.ReaderReplacementFormPage]
class ReaderReplacementFormRoute extends _i46.PageRouteInfo<void> {
  const ReaderReplacementFormRoute({List<_i46.PageRouteInfo>? children})
      : super(
          ReaderReplacementFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderReplacementFormRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i28.ReaderReplacementFormPage();
    },
  );
}

/// generated route for
/// [_i29.ReaderReplacementPage]
class ReaderReplacementRoute
    extends _i46.PageRouteInfo<ReaderReplacementRouteArgs> {
  ReaderReplacementRoute({
    _i47.Key? key,
    required _i49.BookEntity book,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          ReaderReplacementRoute.name,
          args: ReaderReplacementRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderReplacementRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderReplacementRouteArgs>();
      return _i29.ReaderReplacementPage(
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

  final _i47.Key? key;

  final _i49.BookEntity book;

  @override
  String toString() {
    return 'ReaderReplacementRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i30.ReaderThemeEditorColorPickerPage]
class ReaderThemeEditorColorPickerRoute extends _i46.PageRouteInfo<void> {
  const ReaderThemeEditorColorPickerRoute({List<_i46.PageRouteInfo>? children})
      : super(
          ReaderThemeEditorColorPickerRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeEditorColorPickerRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i30.ReaderThemeEditorColorPickerPage();
    },
  );
}

/// generated route for
/// [_i31.ReaderThemeEditorImageSelectorPage]
class ReaderThemeEditorImageSelectorRoute extends _i46.PageRouteInfo<void> {
  const ReaderThemeEditorImageSelectorRoute(
      {List<_i46.PageRouteInfo>? children})
      : super(
          ReaderThemeEditorImageSelectorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeEditorImageSelectorRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i31.ReaderThemeEditorImageSelectorPage();
    },
  );
}

/// generated route for
/// [_i32.ReaderThemeEditorPage]
class ReaderThemeEditorRoute
    extends _i46.PageRouteInfo<ReaderThemeEditorRouteArgs> {
  ReaderThemeEditorRoute({
    _i47.Key? key,
    required _i55.Theme theme,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          ReaderThemeEditorRoute.name,
          args: ReaderThemeEditorRouteArgs(
            key: key,
            theme: theme,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderThemeEditorRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderThemeEditorRouteArgs>();
      return _i32.ReaderThemeEditorPage(
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

  final _i47.Key? key;

  final _i55.Theme theme;

  @override
  String toString() {
    return 'ReaderThemeEditorRouteArgs{key: $key, theme: $theme}';
  }
}

/// generated route for
/// [_i33.ReaderThemePage]
class ReaderThemeRoute extends _i46.PageRouteInfo<void> {
  const ReaderThemeRoute({List<_i46.PageRouteInfo>? children})
      : super(
          ReaderThemeRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderThemeRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i33.ReaderThemePage();
    },
  );
}

/// generated route for
/// [_i34.RuleInputPage]
class RuleInputRoute extends _i46.PageRouteInfo<RuleInputRouteArgs> {
  RuleInputRoute({
    _i47.Key? key,
    void Function(String)? onChange,
    String? placeholder,
    String? text,
    required String title,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          RuleInputRoute.name,
          args: RuleInputRouteArgs(
            key: key,
            onChange: onChange,
            placeholder: placeholder,
            text: text,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'RuleInputRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RuleInputRouteArgs>();
      return _i34.RuleInputPage(
        key: args.key,
        onChange: args.onChange,
        placeholder: args.placeholder,
        text: args.text,
        title: args.title,
      );
    },
  );
}

class RuleInputRouteArgs {
  const RuleInputRouteArgs({
    this.key,
    this.onChange,
    this.placeholder,
    this.text,
    required this.title,
  });

  final _i47.Key? key;

  final void Function(String)? onChange;

  final String? placeholder;

  final String? text;

  final String title;

  @override
  String toString() {
    return 'RuleInputRouteArgs{key: $key, onChange: $onChange, placeholder: $placeholder, text: $text, title: $title}';
  }
}

/// generated route for
/// [_i35.SearchPage]
class SearchRoute extends _i46.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i47.Key? key,
    String? credential,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            credential: credential,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SearchRouteArgs>(orElse: () => const SearchRouteArgs());
      return _i35.SearchPage(
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

  final _i47.Key? key;

  final String? credential;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, credential: $credential}';
  }
}

/// generated route for
/// [_i36.SettingPage]
class SettingRoute extends _i46.PageRouteInfo<void> {
  const SettingRoute({List<_i46.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i36.SettingPage();
    },
  );
}

/// generated route for
/// [_i37.SourceAdvancedConfigurationPage]
class SourceAdvancedConfigurationRoute extends _i46.PageRouteInfo<void> {
  const SourceAdvancedConfigurationRoute({List<_i46.PageRouteInfo>? children})
      : super(
          SourceAdvancedConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceAdvancedConfigurationRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i37.SourceAdvancedConfigurationPage();
    },
  );
}

/// generated route for
/// [_i38.SourceCatalogueConfigurationPage]
class SourceCatalogueConfigurationRoute extends _i46.PageRouteInfo<void> {
  const SourceCatalogueConfigurationRoute({List<_i46.PageRouteInfo>? children})
      : super(
          SourceCatalogueConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceCatalogueConfigurationRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i38.SourceCatalogueConfigurationPage();
    },
  );
}

/// generated route for
/// [_i39.SourceContentConfigurationPage]
class SourceContentConfigurationRoute extends _i46.PageRouteInfo<void> {
  const SourceContentConfigurationRoute({List<_i46.PageRouteInfo>? children})
      : super(
          SourceContentConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceContentConfigurationRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i39.SourceContentConfigurationPage();
    },
  );
}

/// generated route for
/// [_i40.SourceDebuggerPage]
class SourceDebuggerRoute extends _i46.PageRouteInfo<void> {
  const SourceDebuggerRoute({List<_i46.PageRouteInfo>? children})
      : super(
          SourceDebuggerRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceDebuggerRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i40.SourceDebuggerPage();
    },
  );
}

/// generated route for
/// [_i41.SourceFormDebugPage]
class SourceFormDebugRoute
    extends _i46.PageRouteInfo<SourceFormDebugRouteArgs> {
  SourceFormDebugRoute({
    _i47.Key? key,
    required _i56.SourceEntity source,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          SourceFormDebugRoute.name,
          args: SourceFormDebugRouteArgs(
            key: key,
            source: source,
          ),
          initialChildren: children,
        );

  static const String name = 'SourceFormDebugRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SourceFormDebugRouteArgs>();
      return _i41.SourceFormDebugPage(
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

  final _i47.Key? key;

  final _i56.SourceEntity source;

  @override
  String toString() {
    return 'SourceFormDebugRouteArgs{key: $key, source: $source}';
  }
}

/// generated route for
/// [_i42.SourceFormPage]
class SourceFormRoute extends _i46.PageRouteInfo<SourceFormRouteArgs> {
  SourceFormRoute({
    _i47.Key? key,
    _i56.SourceEntity? source,
    List<_i46.PageRouteInfo>? children,
  }) : super(
          SourceFormRoute.name,
          args: SourceFormRouteArgs(
            key: key,
            source: source,
          ),
          initialChildren: children,
        );

  static const String name = 'SourceFormRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SourceFormRouteArgs>(
          orElse: () => const SourceFormRouteArgs());
      return _i42.SourceFormPage(
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

  final _i47.Key? key;

  final _i56.SourceEntity? source;

  @override
  String toString() {
    return 'SourceFormRouteArgs{key: $key, source: $source}';
  }
}

/// generated route for
/// [_i43.SourceInformationConfigurationPage]
class SourceInformationConfigurationRoute extends _i46.PageRouteInfo<void> {
  const SourceInformationConfigurationRoute(
      {List<_i46.PageRouteInfo>? children})
      : super(
          SourceInformationConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceInformationConfigurationRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i43.SourceInformationConfigurationPage();
    },
  );
}

/// generated route for
/// [_i44.SourcePage]
class SourceRoute extends _i46.PageRouteInfo<void> {
  const SourceRoute({List<_i46.PageRouteInfo>? children})
      : super(
          SourceRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i44.SourcePage();
    },
  );
}

/// generated route for
/// [_i45.SourceSearchConfigurationPage]
class SourceSearchConfigurationRoute extends _i46.PageRouteInfo<void> {
  const SourceSearchConfigurationRoute({List<_i46.PageRouteInfo>? children})
      : super(
          SourceSearchConfigurationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SourceSearchConfigurationRoute';

  static _i46.PageInfo page = _i46.PageInfo(
    name,
    builder: (data) {
      return const _i45.SourceSearchConfigurationPage();
    },
  );
}
