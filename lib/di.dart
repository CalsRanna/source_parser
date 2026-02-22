import 'package:get_it/get_it.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/page/available_source/available_source_view_model.dart';
import 'package:source_parser/page/catalogue/catalogue_view_model.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_bookshelf_view_model.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_catalogue_view_model.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_explore_view_model.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_reader_view_model.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_search_view_model.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_setting_view_model.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_source_view_model.dart';
import 'package:source_parser/page/cover_selector/cover_selector_view_model.dart';
import 'package:source_parser/page/database_page/database_view_model.dart';
import 'package:source_parser/page/developer_page/developer_view_model.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/page/home/home_view_model.dart';
import 'package:source_parser/page/home/profile_view/profile_view_model.dart';
import 'package:source_parser/page/information/information_view_model.dart';
import 'package:source_parser/page/reader/reader_view_model.dart';
import 'package:source_parser/page/reader_replacement/reader_replacement_view_model.dart';
import 'package:source_parser/page/reader_replacement_form_page/reader_replacement_form_view_model.dart';
import 'package:source_parser/page/search/search_view_model.dart';
import 'package:source_parser/page/setting/setting_view_model.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_debug_view_model.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_view_model.dart';
import 'package:source_parser/page/source_page/source_view_model.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';
import 'package:source_parser/page/reader_theme/reader_theme_editor_view_model.dart';
import 'package:source_parser/page/reader_theme/reader_theme_view_model.dart';
import 'package:source_parser/view_model/app_setting_view_model.dart';
import 'package:source_parser/view_model/app_sources_view_model.dart';
import 'package:source_parser/view_model/app_theme_view_model.dart';
import 'package:source_parser/view_model/layout_view_model.dart';
import 'package:source_parser/view_model/explore_view_model.dart';
import 'package:source_parser/view_model/cache_view_model.dart';
import 'package:source_parser/view_model/reader_helper_view_model.dart';
import 'package:source_parser/view_model/file_view_model.dart';
import 'package:source_parser/view_model/battery_view_model.dart';
import 'package:source_parser/view_model/books_view_model.dart';

class DI {
  static void ensureInitialized() {
    var instance = GetIt.instance;
    instance.registerLazySingleton<SourceParserViewModel>(
      () => SourceParserViewModel(),
    );
    instance.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
    instance.registerLazySingleton<BookshelfViewModel>(
      () => BookshelfViewModel(),
    );
    instance.registerLazySingleton<ProfileViewModel>(() => ProfileViewModel());
    instance.registerFactory<SearchViewModel>(() => SearchViewModel());
    instance.registerFactory<InformationViewModel>(
      () => InformationViewModel(),
    );
    instance.registerFactory<CatalogueViewModel>(() => CatalogueViewModel());
    instance.registerFactory<AvailableSourceViewModel>(
      () => AvailableSourceViewModel(),
    );
    instance.registerFactory<ReaderViewModel>(
      () => ReaderViewModel(book: BookEntity()),
    );
    instance.registerFactory<CoverSelectorViewModel>(
      () => CoverSelectorViewModel(),
    );
    instance.registerFactory<SourceViewModel>(() => SourceViewModel());
    instance.registerLazySingleton<CloudReaderBookshelfViewModel>(
      () => CloudReaderBookshelfViewModel(),
    );
    instance.registerFactory<CloudReaderSearchViewModel>(
      () => CloudReaderSearchViewModel(),
    );
    instance.registerFactoryParam<CloudReaderReaderViewModel, CloudBookEntity,
        void>(
      (book, _) => CloudReaderReaderViewModel(book: book),
    );
    instance.registerFactory<CloudReaderCatalogueViewModel>(
      () => CloudReaderCatalogueViewModel(),
    );
    instance.registerFactory<CloudReaderSourceViewModel>(
      () => CloudReaderSourceViewModel(),
    );
    instance.registerFactory<CloudReaderSettingViewModel>(
      () => CloudReaderSettingViewModel(),
    );
    instance.registerFactory<CloudReaderExploreViewModel>(
      () => CloudReaderExploreViewModel(),
    );
    instance.registerLazySingleton<DeveloperViewModel>(
      () => DeveloperViewModel(),
    );
    instance.registerFactory<DatabaseViewModel>(() => DatabaseViewModel());
    instance.registerLazySingleton<SettingViewModel>(() => SettingViewModel());
    instance.registerFactory<SourceFormViewModel>(() => SourceFormViewModel());
    instance.registerFactory<SourceFormDebugViewModel>(
      () => SourceFormDebugViewModel(),
    );
    instance.registerCachedFactory<ReaderReplacementViewModel>(
      () => ReaderReplacementViewModel(),
    );
    instance.registerFactory<ReaderReplacementFormViewModel>(
      () => ReaderReplacementFormViewModel(),
    );
    instance.registerFactory<ReaderThemeViewModel>(
      () => ReaderThemeViewModel(),
    );
    instance.registerFactory<ReaderThemeEditorViewModel>(
      () => ReaderThemeEditorViewModel(),
    );
    // New ViewModels to replace Riverpod Providers
    instance
        .registerLazySingleton<AppBooksViewModel>(() => AppBooksViewModel());
    instance.registerLazySingleton<AppSourcesViewModel>(
        () => AppSourcesViewModel());
    instance
        .registerLazySingleton<AppThemeViewModel>(() => AppThemeViewModel());
    instance.registerLazySingleton<AppSettingViewModel>(
        () => AppSettingViewModel());
    instance.registerLazySingleton<LayoutViewModel>(() => LayoutViewModel());
    instance.registerLazySingleton<ExploreViewModel>(() => ExploreViewModel());
    instance.registerLazySingleton<CacheViewModel>(() => CacheViewModel());
    instance.registerLazySingleton<ReaderHelperViewModel>(
        () => ReaderHelperViewModel());
    instance.registerLazySingleton<FileViewModel>(() => FileViewModel());
    instance.registerLazySingleton<BatteryViewModel>(() => BatteryViewModel());
  }
}
