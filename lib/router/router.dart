import 'package:go_router/go_router.dart';
import 'package:source_parser/page/setting/reader_theme.dart';

import '../page/book/book_information.dart';
import '../page/book_source/book_source.advanced_configuration.dart';
import '../page/book_source/book_source.catalogue_configuration.dart';
import '../page/book_source/book_source.content_configuration.dart';
import '../page/book_source/book_source.dart';
import '../page/book_source/book_source.debug.dart';
import '../page/book_source/book_source.explore_configuration.dart';
import '../page/book_source/book_source.import.dart';
import '../page/book_source/book_source.information.dart';
import '../page/book_source/book_source.information_configuration.dart';
import '../page/book_source/book_source.search_configuration.dart';
import '../page/developer/developer.dart';
import '../page/explore/explore.dart';
import '../page/search/search.dart';
import '../page/setting/about.dart';
import '../page/setting/setting.dart';
import '../page/setting/theme.dart';
import '../page/book_shelf/book_shelf.dart';

final router = GoRouter(routes: [
  GoRoute(path: '/', redirect: (state) => '/shelf'),
  GoRoute(builder: (context, state) => BookSourceList(), path: '/book-source'),
  GoRoute(
      builder: (context, state) => const BookInformation(),
      path: '/book-information'),
  GoRoute(
    builder: (context, state) => const BookSourceAdvancedConfiguration(),
    path: '/book-source/advanced-configuration',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceCatalogueConfiguration(),
    path: '/book-source/catalogue-configuration',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceContentConfiguration(),
    path: '/book-source/content-configuration',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceInformation(),
    path: '/book-source/create',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceDebug(),
    path: '/book-source/debug',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceExploreConfiguration(),
    path: '/book-source/explore-configuration',
  ),
  GoRoute(
    builder: (context, state) => BookSourceImport(by: state.queryParams['by']!),
    path: '/book-source/import',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceInformationConfiguration(),
    path: '/book-source/information-configuration',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceInformation(),
    path: '/book-source/information/:id',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceSearchConfiguration(),
    path: '/book-source/search-configuration',
  ),
  GoRoute(
    pageBuilder: (context, state) => NoTransitionPage(
      key: state.pageKey,
      child: const Explore(),
    ),
    path: '/explore',
  ),
  GoRoute(builder: (context, state) => const Search(), path: '/search'),
  GoRoute(
    pageBuilder: (context, state) => NoTransitionPage(
      key: state.pageKey,
      child: const Setting(),
    ),
    path: '/setting',
  ),
  GoRoute(builder: (context, state) => const About(), path: '/setting/about'),
  GoRoute(
    builder: (context, state) => const Developer(),
    path: '/setting/developer',
  ),
  GoRoute(
    builder: (context, state) => const ThemeSetting(),
    path: '/setting/theme',
  ),
  GoRoute(
    builder: (context, state) => const ReaderTheme(),
    path: '/setting/reader-theme',
  ),
  GoRoute(
    pageBuilder: (context, state) => NoTransitionPage(
      key: state.pageKey,
      child: const BookShelf(),
    ),
    path: '/shelf',
  ),
]);
