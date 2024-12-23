import 'package:auto_route/auto_route.dart';
import 'package:source_parser/router/router.gr.dart';

final routerConfig = AppRouter().config();

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: HomeRoute.page, initial: true),
      AutoRoute(page: BookFormRoute.page),
      AutoRoute(page: InformationRoute.page),
      AutoRoute(page: SourceListRoute.page),
      AutoRoute(page: ReaderThemeRoute.page),
      AutoRoute(page: SettingRoute.page),
      AutoRoute(page: AboutRoute.page),
      AutoRoute(page: ReaderRoute.page),
      AutoRoute(page: SearchRoute.page),
      AutoRoute(page: CatalogueRoute.page),
      AutoRoute(page: AvailableSourceListRoute.page),
      AutoRoute(page: AvailableSourceFormRoute.page),
      AutoRoute(page: SourceDebuggerRoute.page),
      AutoRoute(page: SourceAdvancedConfigurationRoute.page),
      AutoRoute(page: SourceSearchConfigurationRoute.page),
      AutoRoute(page: SourceInformationConfigurationRoute.page),
      AutoRoute(page: SourceCatalogueConfigurationRoute.page),
      AutoRoute(page: SourceContentConfigurationRoute.page),
      AutoRoute(page: SourceFormRoute.page),
      AutoRoute(page: ReaderLayoutRoute.page),
      AutoRoute(page: ThemeEditorRoute.page),
      AutoRoute(page: SourceServerRoute.page),
    ];
  }
}
