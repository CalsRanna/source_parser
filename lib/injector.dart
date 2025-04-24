import 'package:get_it/get_it.dart';
import 'package:source_parser/page/book/book_cover_selector_view_model.dart';
import 'package:source_parser/view_model/home_view_model.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

class Injector {
  static void ensureInitialized() {
    GetIt.instance.registerLazySingleton<SourceParserViewModel>(
      () => SourceParserViewModel(),
    );
    GetIt.instance.registerLazySingleton<HomeViewModel>(
      () => HomeViewModel(),
    );
    GetIt.instance
        .registerFactoryParam<BookCoverSelectorViewModel, int, Object?>(
      (bookId, _) => BookCoverSelectorViewModel(bookId),
    );
  }
}
