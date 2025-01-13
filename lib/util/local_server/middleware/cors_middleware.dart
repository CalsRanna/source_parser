import 'package:shelf/shelf.dart';

class CorsMiddleware {
  CorsMiddleware._();

  static CorsMiddleware? _instance;

  static CorsMiddleware get instance => _instance ??= CorsMiddleware._();
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
