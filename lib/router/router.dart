import 'package:go_router/go_router.dart';
import 'package:source_parser/page/information.dart';
import 'package:source_parser/page/source/advanced.dart';
import 'package:source_parser/page/source/catalogue.dart';
import 'package:source_parser/page/source/content.dart';
import 'package:source_parser/page/source/source.dart';
import 'package:source_parser/page/source/debug.dart';
import 'package:source_parser/page/source/explore.dart';
import 'package:source_parser/page/source/importer.dart';
import 'package:source_parser/page/source/detail.dart';
import 'package:source_parser/page/source/information.dart';
import 'package:source_parser/page/source/search.dart';
import 'package:source_parser/page/catalogue.dart';
import 'package:source_parser/page/developer.dart';
import 'package:source_parser/page/home/home.dart';
import 'package:source_parser/page/reader.dart';
import 'package:source_parser/page/search.dart';
import 'package:source_parser/page/about.dart';
import 'package:source_parser/page/theme.dart';
import 'package:source_parser/page/source.dart';

final router = GoRouter(routes: [
  GoRoute(path: '/', redirect: (context, state) => '/home'),
  GoRoute(
    builder: (context, state) => const HomePage(),
    path: '/home',
  ),
  GoRoute(
    builder: (context, state) => const AvailableSources(),
    path: '/book-available-sources',
  ),
  GoRoute(
    builder: (context, state) => const BookSourceList(),
    path: '/book-source',
  ),
  GoRoute(
      builder: (context, state) => const BookInformation(),
      path: '/book-information'),
  GoRoute(builder: (context, state) => const Reader(), path: '/book-reader'),
  GoRoute(
    builder: (context, state) => const CataloguePage(),
    path: '/book-catalogue',
  ),
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
