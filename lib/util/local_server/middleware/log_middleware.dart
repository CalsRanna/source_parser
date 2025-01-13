import 'package:shelf/shelf.dart';
import 'package:source_parser/util/logger.dart';

class LogMiddleware {
  LogMiddleware._();

  static LogMiddleware? _instance;

  static LogMiddleware get instance => _instance ??= LogMiddleware._();
  Middleware get middleware => _createMiddleware();

  Middleware _createMiddleware() {
    return createMiddleware(
      requestHandler: (Request request) {
        var message = 'Request: ${request.method} ${request.url}';
        logger.d(message);
        return null;
      },
    );
  }
}
