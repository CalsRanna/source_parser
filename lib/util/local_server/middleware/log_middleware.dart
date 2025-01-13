import 'package:shelf/shelf.dart';
import 'package:source_parser/util/logger.dart';

class LogMiddleware {
  const LogMiddleware._();

  static final LogMiddleware _instance = LogMiddleware._();

  static LogMiddleware get instance => _instance;
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
