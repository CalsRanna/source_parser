import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/router/router.gr.dart';

final globalKey = GlobalKey<NavigatorState>();
final routerConfig = AppRouter().config();

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: globalKey);
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: HomeRoute.page, initial: true),
      AutoRoute(page: BookFormRoute.page),
      AutoRoute(page: InformationRoute.page),
      AutoRoute(page: SourceRoute.page),
      AutoRoute(page: ReaderThemeRoute.page),
      AutoRoute(page: SettingRoute.page),
      AutoRoute(page: DeveloperRoute.page),
      AutoRoute(page: AboutRoute.page),
      AutoRoute(page: FileManagerRoute.page),
      AutoRoute(page: ReaderRoute.page),
      AutoRoute(page: SearchRoute.page),
      AutoRoute(page: CatalogueRoute.page),
      AutoRoute(page: AvailableSourceRoute.page),
      AutoRoute(page: AvailableSourceFormRoute.page),
      AutoRoute(page: SourceDebuggerRoute.page),
      AutoRoute(page: SourceAdvancedConfigurationRoute.page),
      AutoRoute(page: SourceSearchConfigurationRoute.page),
      AutoRoute(page: SourceInformationConfigurationRoute.page),
      AutoRoute(page: SourceCatalogueConfigurationRoute.page),
      AutoRoute(page: SourceContentConfigurationRoute.page),
      AutoRoute(page: SourceFormRoute.page),
      AutoRoute(page: SourceFormDebugRoute.page),
      AutoRoute(page: ReaderLayoutRoute.page),
      AutoRoute(page: ReaderThemeEditorRoute.page),
      AutoRoute(page: ReaderThemeEditorColorPickerRoute.page),
      AutoRoute(page: ReaderThemeEditorImageSelectorRoute.page),
      AutoRoute(page: ReaderReplacementRoute.page),
      AutoRoute(page: ReaderReplacementFormRoute.page),
      AutoRoute(page: ReaderReplacementFormInputRoute.page),
      AutoRoute(page: LocalServerRoute.page),
      AutoRoute(page: CloudReaderBookshelfRoute.page),
      AutoRoute(page: CloudReaderReaderRoute.page),
      AutoRoute(page: CloudReaderSearchRoute.page),
      AutoRoute(page: CloudReaderCatalogueRoute.page),
      AutoRoute(page: CloudReaderSourceRoute.page),
      AutoRoute(page: CloudReaderSettingRoute.page),
      AutoRoute(page: CloudReaderBookInfoRoute.page),
      AutoRoute(page: CloudReaderExploreRoute.page),
      AutoRoute(page: CoverSelectorRoute.page),
      AutoRoute(page: DatabaseRoute.page),
      AutoRoute(page: AiSettingRoute.page),
    ];
  }
}
