import 'package:shelf/shelf.dart';
import 'package:source_parser/util/logger.dart';

class LocalServerLogMiddleware {
  LocalServerLogMiddleware._();

  static LocalServerLogMiddleware? _instance;

  static LocalServerLogMiddleware get instance =>
      _instance ??= LocalServerLogMiddleware._();
  Middleware get middleware => _createMiddleware();

  Middleware _createMiddleware() {
    return createMiddleware(
      requestHandler: (Request request) {
        logger.d('${request.method} ${request.url}');
        return null;
      },
    );
  }
}
