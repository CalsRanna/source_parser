import 'package:shelf/shelf.dart';

class LocalServerCorsMiddleware {
  LocalServerCorsMiddleware._();

  static LocalServerCorsMiddleware? _instance;

  static LocalServerCorsMiddleware get instance =>
      _instance ??= LocalServerCorsMiddleware._();
  Middleware get middleware => _createMiddleware();

  Middleware _createMiddleware() {
    var corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Max-Age': '1728000',
    };
    return createMiddleware(
      responseHandler: (Response response) {
        var headers = {...response.headers, ...corsHeaders};
        return response.change(headers: headers);
      },
    );
  }
}
