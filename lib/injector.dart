import 'package:get_it/get_it.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/information_entity.dart';
import 'package:source_parser/page/available_source/available_source_view_model.dart';
import 'package:source_parser/page/catalogue/catalogue_view_model.dart';
import 'package:source_parser/page/cover_selector/cover_selector_view_model.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/page/home/home_view_model.dart';
import 'package:source_parser/page/information/information_view_model.dart';
import 'package:source_parser/page/reader/reader_view_model.dart';
import 'package:source_parser/page/search/search_view_model.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_view_model.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

class Injector {
  static void ensureInitialized() {
    var injector = GetIt.instance;
    injector.registerLazySingleton<SourceParserViewModel>(
      () => SourceParserViewModel(),
    );
    injector.registerLazySingleton<HomeViewModel>(
      () => HomeViewModel(),
    );
    injector.registerLazySingleton<BookshelfViewModel>(
      () => BookshelfViewModel(),
    );
    injector.registerFactory(
      () => SearchViewModel(),
    );
    injector
        .registerFactoryParam<InformationViewModel, InformationEntity, Object?>(
      (information, _) => InformationViewModel(information: information),
    );
    injector.registerFactoryParam<CatalogueViewModel, BookEntity, Object?>(
      (book, _) => CatalogueViewModel(book: book),
    );
    injector
        .registerFactoryParam<AvailableSourceViewModel, BookEntity, Object?>(
      (book, _) => AvailableSourceViewModel(book: book),
    );
    injector.registerFactoryParam<ReaderViewModel, BookEntity, Object?>(
      (book, _) => ReaderViewModel(book: book),
    );
    injector.registerFactoryParam<CoverSelectorViewModel, BookEntity, Object?>(
      (book, _) => CoverSelectorViewModel(book: book),
    );
    injector.registerLazySingleton<CloudReaderViewModel>(
      () => CloudReaderViewModel(),
    );
  }
}
