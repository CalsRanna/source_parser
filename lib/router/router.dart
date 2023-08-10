import 'package:go_router/go_router.dart';
import 'package:source_parser/page/book/book_information.dart';
import 'package:source_parser/page/book_source/advanced.dart';
import 'package:source_parser/page/book_source/catalogue.dart';
import 'package:source_parser/page/book_source/content.dart';
import 'package:source_parser/page/book_source/book_source.dart';
import 'package:source_parser/page/book_source/debug.dart';
import 'package:source_parser/page/book_source/explore.dart';
import 'package:source_parser/page/book_source/importer.dart';
import 'package:source_parser/page/book_source/detail.dart';
import 'package:source_parser/page/book_source/information.dart';
import 'package:source_parser/page/book_source/search.dart';
import 'package:source_parser/page/developer/developer.dart';
import 'package:source_parser/page/home/home.dart';
import 'package:source_parser/page/search/search.dart';
import 'package:source_parser/page/about.dart';
import 'package:source_parser/page/setting/reader_theme.dart';

final router = GoRouter(routes: [
  GoRoute(path: '/', redirect: (context, state) => '/home'),
  GoRoute(
    builder: (context, state) => const HomePage(),
    path: '/home',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceList(),
    path: '/book-source',
  ),
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
    builder: (context, state) =>
        BookSourceImport(by: state.queryParameters['by']!),
    path: '/book-source/import',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceInformationConfiguration(),
    path: '/book-source/information-configuration',
  ),
  GoRoute(
    builder: (context, state) =>
        BookSourceInformation(id: int.parse(state.pathParameters['id']!)),
    path: '/book-source/information/:id',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceSearchConfiguration(),
    path: '/book-source/search-configuration',
  ),
  GoRoute(builder: (context, state) => const Search(), path: '/search'),
  GoRoute(
      builder: (context, state) => const AboutPage(), path: '/setting/about'),
  GoRoute(
    builder: (context, state) => const Developer(),
    path: '/setting/developer',
  ),
  GoRoute(
    builder: (context, state) => const ReaderTheme(),
    path: '/setting/reader-theme',
  ),
]);
