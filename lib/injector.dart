import 'package:get_it/get_it.dart';
import 'package:source_parser/page/cover_selector/cover_selector_view_model.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/page/home/home_view_model.dart';
import 'package:source_parser/page/search/search_view_model.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

class Injector {
  static void ensureInitialized() {
    GetIt.instance.registerLazySingleton<SourceParserViewModel>(
      () => SourceParserViewModel(),
    );
    GetIt.instance.registerLazySingleton<HomeViewModel>(
      () => HomeViewModel(),
    );
    GetIt.instance.registerLazySingleton<BookshelfViewModel>(
      () => BookshelfViewModel(),
    );
    GetIt.instance.registerFactory(
      () => SearchViewModel(),
    );
    GetIt.instance.registerFactoryParam<CoverSelectorViewModel, int, Object?>(
      (bookId, _) => CoverSelectorViewModel(bookId),
    );
  }
}
