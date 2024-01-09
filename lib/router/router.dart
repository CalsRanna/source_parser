import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:source_parser/page/about.dart';
import 'package:source_parser/page/catalogue.dart';
import 'package:source_parser/page/home/home.dart';
import 'package:source_parser/page/information.dart';
import 'package:source_parser/page/reader.dart';
import 'package:source_parser/page/search.dart';
import 'package:source_parser/page/setting.dart';
import 'package:source_parser/page/source.dart';
import 'package:source_parser/page/source/advanced.dart';
import 'package:source_parser/page/source/catalogue.dart';
import 'package:source_parser/page/source/content.dart';
import 'package:source_parser/page/source/debugger.dart';
import 'package:source_parser/page/source/form.dart';
import 'package:source_parser/page/source/information.dart';
import 'package:source_parser/page/source/search.dart';
import 'package:source_parser/page/source/source.dart';
import 'package:source_parser/page/theme.dart';

part 'router.g.dart';

final router = GoRouter(routes: $appRoutes);

@TypedGoRoute<AboutPageRoute>(path: '/setting/about')
class AboutPageRoute extends GoRouteData {
  const AboutPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AboutPage();
}

@TypedGoRoute<BookCataloguePageRoute>(path: '/book-catalogue')
class BookCataloguePageRoute extends GoRouteData {
  final int index;
  const BookCataloguePageRoute({this.index = 0});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CataloguePage(index: index);
  }
}

@TypedGoRoute<BookInformationPageRoute>(path: '/book-information')
class BookInformationPageRoute extends GoRouteData {
  const BookInformationPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InformationPage();
  }
}

@TypedGoRoute<BookReaderPageRoute>(path: '/book-reader')
class BookReaderPageRoute extends GoRouteData {
  const BookReaderPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReaderPage();
  }
}

@TypedGoRoute<BookReaderThemePageRoute>(path: '/book-reader-theme')
class BookReaderThemePageRoute extends GoRouteData {
  const BookReaderThemePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReaderThemePage();
  }
}

@TypedGoRoute<BookSourceListPageRoute>(path: '/book-available-sources')
class BookSourceListPageRoute extends GoRouteData {
  const BookSourceListPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AvailableSourceListPage();
  }
}

@TypedGoRoute<HomePageRoute>(path: '/')
class HomePageRoute extends GoRouteData {
  const HomePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@TypedGoRoute<SearchPageRoute>(path: '/search')
class SearchPageRoute extends GoRouteData {
  final String? credential;
  const SearchPageRoute({this.credential});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SearchPage(credential: credential);
  }
}

@TypedGoRoute<SettingPageRoute>(path: '/setting/advanced')
class SettingPageRoute extends GoRouteData {
  const SettingPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingPage();
  }
}

@TypedGoRoute<SourceCreateFormPageRoute>(path: '/book-source/create')
class SourceCreateFormPageRoute extends GoRouteData {
  const SourceCreateFormPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SourceFormPage();
  }
}

@TypedGoRoute<SourceDebuggerPageRoute>(path: '/book-source/debug')
class SourceDebuggerPageRoute extends GoRouteData {
  const SourceDebuggerPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SourceDebuggerPage();
  }
}

@TypedGoRoute<SourceEditFormPageRoute>(path: '/book-source/:id/edit')
class SourceEditFormPageRoute extends GoRouteData {
  final int id;
  const SourceEditFormPageRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SourceFormPage(id: id);
  }
}

@TypedGoRoute<SourceFormAdvancedConfigurationPageRoute>(
  path: '/book-source/advanced-configuration',
)
class SourceFormAdvancedConfigurationPageRoute extends GoRouteData {
  const SourceFormAdvancedConfigurationPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SourceAdvancedConfigurationPage();
  }
}

@TypedGoRoute<SourceFormCatalogueConfigurationPageRoute>(
  path: '/book-source/catalogue-configuration',
)
class SourceFormCatalogueConfigurationPageRoute extends GoRouteData {
  const SourceFormCatalogueConfigurationPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SourceCatalogueConfigurationPage();
  }
}

@TypedGoRoute<SourceFormContentConfigurationPageRoute>(
  path: '/book-source/content-configuration',
)
class SourceFormContentConfigurationPageRoute extends GoRouteData {
  const SourceFormContentConfigurationPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SourceContentConfigurationPage();
  }
}

@TypedGoRoute<SourceFormInformationConfigurationPageRoute>(
  path: '/book-source/information-configuration',
)
class SourceFormInformationConfigurationPageRoute extends GoRouteData {
  const SourceFormInformationConfigurationPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SourceInformationConfigurationPage();
  }
}

@TypedGoRoute<SourceFormSearchConfigurationPageRoute>(
  path: '/book-source/search-configuration',
)
class SourceFormSearchConfigurationPageRoute extends GoRouteData {
  const SourceFormSearchConfigurationPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SourceSearchConfigurationPage();
  }
}

@TypedGoRoute<SourceListPageRoute>(path: '/book-source')
class SourceListPageRoute extends GoRouteData {
  const SourceListPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SourceListPage();
  }
}
