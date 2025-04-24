import 'package:get_it/get_it.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

class Injector {
  static void ensureInitialized() {
    GetIt.instance.registerLazySingleton<SourceParserViewModel>(
      () => SourceParserViewModel(),
    );
  }
}
