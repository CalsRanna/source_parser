import 'package:shelf/shelf.dart';

class CorsMiddleware {
  const CorsMiddleware._();

  static final CorsMiddleware _instance = CorsMiddleware._();

  static CorsMiddleware get instance => _instance;
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
