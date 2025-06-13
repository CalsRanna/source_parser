import 'dart:convert';

import 'package:shelf/shelf.dart';

mixin LocalServerController {
  Response error(Object data) {
    return _response({'message': data.toString()}, 500);
  }

  Response response(Object? data, {int statusCode = 200}) {
    if (data == null || statusCode == 404) return _notFound();
    if (statusCode == 200) return _ok(data);
    return _response(data, statusCode);
  }

  Response _notFound() {
    var headers = {'Content-Type': 'application/json'};
    return Response.notFound(null, headers: headers);
  }

  Response _ok(Object data) {
    var jsonString = jsonEncode(data);
    var headers = {'Content-Type': 'application/json'};
    return Response.ok(jsonString, headers: headers);
  }

  Response _response(Object data, int statusCode) {
    var jsonString = jsonEncode(data);
    var headers = {'Content-Type': 'application/json'};
    return Response(statusCode, body: jsonString, headers: headers);
  }
}
