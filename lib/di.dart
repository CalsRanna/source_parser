import 'package:get_it/get_it.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/available_source/available_source_view_model.dart';
import 'package:source_parser/page/catalogue/catalogue_view_model.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_view_model.dart';
import 'package:source_parser/page/cover_selector/cover_selector_view_model.dart';
import 'package:source_parser/page/database_page/database_view_model.dart';
import 'package:source_parser/page/developer_page/developer_view_model.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/page/home/home_view_model.dart';
import 'package:source_parser/page/home/profile_view/profile_view_model.dart';
import 'package:source_parser/page/information/information_view_model.dart';
import 'package:source_parser/page/reader/reader_view_model.dart';
import 'package:source_parser/page/search/search_view_model.dart';
import 'package:source_parser/page/setting/setting_view_model.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_view_model.dart';
import 'package:source_parser/page/source_page/source_view_model.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';

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
    instance.registerFactoryParam<ReaderViewModel, BookEntity, Object?>(
      (book, _) => ReaderViewModel(book: book),
    );
    instance.registerFactoryParam<CoverSelectorViewModel, BookEntity, Object?>(
      (book, _) => CoverSelectorViewModel(book: book),
    );
    instance.registerFactory<SourceViewModel>(() => SourceViewModel());
    instance.registerLazySingleton<CloudReaderViewModel>(
      () => CloudReaderViewModel(),
    );
    instance.registerLazySingleton<DeveloperViewModel>(
      () => DeveloperViewModel(),
    );
    instance.registerFactory<DatabaseViewModel>(() => DatabaseViewModel());
    instance.registerLazySingleton<SettingViewModel>(() => SettingViewModel());
    instance.registerFactory<SourceFormViewModel>(() => SourceFormViewModel());
  }
}
