// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $aboutPageRoute,
      $bookCataloguePageRoute,
      $bookInformationPageRoute,
      $bookReaderPageRoute,
      $bookReaderThemePageRoute,
      $bookSourceListPageRoute,
      $homePageRoute,
      $searchPageRoute,
      $settingPageRoute,
      $sourceCreateFormPageRoute,
      $sourceDebuggerPageRoute,
      $sourceEditFormPageRoute,
      $sourceFormAdvancedConfigurationPageRoute,
      $sourceFormCatalogueConfigurationPageRoute,
      $sourceFormContentConfigurationPageRoute,
      $sourceFormInformationConfigurationPageRoute,
      $sourceFormSearchConfigurationPageRoute,
      $sourceListPageRoute,
    ];

RouteBase get $aboutPageRoute => GoRouteData.$route(
      path: '/setting/about',
      factory: $AboutPageRouteExtension._fromState,
    );

extension $AboutPageRouteExtension on AboutPageRoute {
  static AboutPageRoute _fromState(GoRouterState state) =>
      const AboutPageRoute();

  String get location => GoRouteData.$location(
        '/setting/about',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $bookCataloguePageRoute => GoRouteData.$route(
      path: '/book-catalogue',
      factory: $BookCataloguePageRouteExtension._fromState,
    );

extension $BookCataloguePageRouteExtension on BookCataloguePageRoute {
  static BookCataloguePageRoute _fromState(GoRouterState state) =>
      BookCataloguePageRoute(
        index:
            _$convertMapValue('index', state.uri.queryParameters, int.parse) ??
                0,
      );

  String get location => GoRouteData.$location(
        '/book-catalogue',
        queryParams: {
          if (index != 0) 'index': index.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

RouteBase get $bookInformationPageRoute => GoRouteData.$route(
      path: '/book-information',
      factory: $BookInformationPageRouteExtension._fromState,
    );

extension $BookInformationPageRouteExtension on BookInformationPageRoute {
  static BookInformationPageRoute _fromState(GoRouterState state) =>
      const BookInformationPageRoute();

  String get location => GoRouteData.$location(
        '/book-information',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $bookReaderPageRoute => GoRouteData.$route(
      path: '/book-reader',
      factory: $BookReaderPageRouteExtension._fromState,
    );

extension $BookReaderPageRouteExtension on BookReaderPageRoute {
  static BookReaderPageRoute _fromState(GoRouterState state) =>
      const BookReaderPageRoute();

  String get location => GoRouteData.$location(
        '/book-reader',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $bookReaderThemePageRoute => GoRouteData.$route(
      path: '/book-reader-theme',
      factory: $BookReaderThemePageRouteExtension._fromState,
    );

extension $BookReaderThemePageRouteExtension on BookReaderThemePageRoute {
  static BookReaderThemePageRoute _fromState(GoRouterState state) =>
      const BookReaderThemePageRoute();

  String get location => GoRouteData.$location(
        '/book-reader-theme',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $bookSourceListPageRoute => GoRouteData.$route(
      path: '/book-available-sources',
      factory: $BookSourceListPageRouteExtension._fromState,
    );

extension $BookSourceListPageRouteExtension on BookSourceListPageRoute {
  static BookSourceListPageRoute _fromState(GoRouterState state) =>
      const BookSourceListPageRoute();

  String get location => GoRouteData.$location(
        '/book-available-sources',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homePageRoute => GoRouteData.$route(
      path: '/',
      factory: $HomePageRouteExtension._fromState,
    );

extension $HomePageRouteExtension on HomePageRoute {
  static HomePageRoute _fromState(GoRouterState state) => const HomePageRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $searchPageRoute => GoRouteData.$route(
      path: '/search',
      factory: $SearchPageRouteExtension._fromState,
    );

extension $SearchPageRouteExtension on SearchPageRoute {
  static SearchPageRoute _fromState(GoRouterState state) => SearchPageRoute(
        credential: state.uri.queryParameters['credential'],
      );

  String get location => GoRouteData.$location(
        '/search',
        queryParams: {
          if (credential != null) 'credential': credential,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingPageRoute => GoRouteData.$route(
      path: '/setting/advanced',
      factory: $SettingPageRouteExtension._fromState,
    );

extension $SettingPageRouteExtension on SettingPageRoute {
  static SettingPageRoute _fromState(GoRouterState state) =>
      const SettingPageRoute();

  String get location => GoRouteData.$location(
        '/setting/advanced',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sourceCreateFormPageRoute => GoRouteData.$route(
      path: '/book-source/create',
      factory: $SourceCreateFormPageRouteExtension._fromState,
    );

extension $SourceCreateFormPageRouteExtension on SourceCreateFormPageRoute {
  static SourceCreateFormPageRoute _fromState(GoRouterState state) =>
      const SourceCreateFormPageRoute();

  String get location => GoRouteData.$location(
        '/book-source/create',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sourceDebuggerPageRoute => GoRouteData.$route(
      path: '/book-source/debug',
      factory: $SourceDebuggerPageRouteExtension._fromState,
    );

extension $SourceDebuggerPageRouteExtension on SourceDebuggerPageRoute {
  static SourceDebuggerPageRoute _fromState(GoRouterState state) =>
      const SourceDebuggerPageRoute();

  String get location => GoRouteData.$location(
        '/book-source/debug',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sourceEditFormPageRoute => GoRouteData.$route(
      path: '/book-source/:id/edit',
      factory: $SourceEditFormPageRouteExtension._fromState,
    );

extension $SourceEditFormPageRouteExtension on SourceEditFormPageRoute {
  static SourceEditFormPageRoute _fromState(GoRouterState state) =>
      SourceEditFormPageRoute(
        id: int.parse(state.pathParameters['id']!),
      );

  String get location => GoRouteData.$location(
        '/book-source/${Uri.encodeComponent(id.toString())}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sourceFormAdvancedConfigurationPageRoute => GoRouteData.$route(
      path: '/book-source/advanced-configuration',
      factory: $SourceFormAdvancedConfigurationPageRouteExtension._fromState,
    );

extension $SourceFormAdvancedConfigurationPageRouteExtension
    on SourceFormAdvancedConfigurationPageRoute {
  static SourceFormAdvancedConfigurationPageRoute _fromState(
          GoRouterState state) =>
      const SourceFormAdvancedConfigurationPageRoute();

  String get location => GoRouteData.$location(
        '/book-source/advanced-configuration',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sourceFormCatalogueConfigurationPageRoute => GoRouteData.$route(
      path: '/book-source/catalogue-configuration',
      factory: $SourceFormCatalogueConfigurationPageRouteExtension._fromState,
    );

extension $SourceFormCatalogueConfigurationPageRouteExtension
    on SourceFormCatalogueConfigurationPageRoute {
  static SourceFormCatalogueConfigurationPageRoute _fromState(
          GoRouterState state) =>
      const SourceFormCatalogueConfigurationPageRoute();

  String get location => GoRouteData.$location(
        '/book-source/catalogue-configuration',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sourceFormContentConfigurationPageRoute => GoRouteData.$route(
      path: '/book-source/content-configuration',
      factory: $SourceFormContentConfigurationPageRouteExtension._fromState,
    );

extension $SourceFormContentConfigurationPageRouteExtension
    on SourceFormContentConfigurationPageRoute {
  static SourceFormContentConfigurationPageRoute _fromState(
          GoRouterState state) =>
      const SourceFormContentConfigurationPageRoute();

  String get location => GoRouteData.$location(
        '/book-source/content-configuration',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sourceFormInformationConfigurationPageRoute =>
    GoRouteData.$route(
      path: '/book-source/information-configuration',
      factory: $SourceFormInformationConfigurationPageRouteExtension._fromState,
    );

extension $SourceFormInformationConfigurationPageRouteExtension
    on SourceFormInformationConfigurationPageRoute {
  static SourceFormInformationConfigurationPageRoute _fromState(
          GoRouterState state) =>
      const SourceFormInformationConfigurationPageRoute();

  String get location => GoRouteData.$location(
        '/book-source/information-configuration',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sourceFormSearchConfigurationPageRoute => GoRouteData.$route(
      path: '/book-source/search-configuration',
      factory: $SourceFormSearchConfigurationPageRouteExtension._fromState,
    );

extension $SourceFormSearchConfigurationPageRouteExtension
    on SourceFormSearchConfigurationPageRoute {
  static SourceFormSearchConfigurationPageRoute _fromState(
          GoRouterState state) =>
      const SourceFormSearchConfigurationPageRoute();

  String get location => GoRouteData.$location(
        '/book-source/search-configuration',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sourceListPageRoute => GoRouteData.$route(
      path: '/book-source',
      factory: $SourceListPageRouteExtension._fromState,
    );

extension $SourceListPageRouteExtension on SourceListPageRoute {
  static SourceListPageRoute _fromState(GoRouterState state) =>
      const SourceListPageRoute();

  String get location => GoRouteData.$location(
        '/book-source',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
