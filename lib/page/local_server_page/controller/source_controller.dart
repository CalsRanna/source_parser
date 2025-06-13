import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/page/local_server_page/controller/controller.dart';

class LocalServerSourceController with LocalServerController {
  static LocalServerSourceController? _instance;

  static LocalServerSourceController get instance =>
      _instance ??= LocalServerSourceController._();

  LocalServerSourceController._();

  Future<Response> destroy(Request request, String id) async {
    await SourceService().destroySource(int.parse(id));
    return response({}, statusCode: 204);
  }

  Future<Response> index(Request request) async {
    final sources = await SourceService().getAllSources();
    return response(sources);
  }

  Future<Response> show(Request request, String id) async {
    try {
      final source = await SourceService().getBookSource(int.parse(id));
      return response(source);
    } catch (error) {
      return response(null);
    }
  }

  Future<Response> store(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    final source = SourceEntity.fromJson(json);
    await SourceService().addSources([source]);
    return response(source, statusCode: 201);
  }

  Future<Response> update(Request request, String id) async {
    try {
      var source = await SourceService().getBookSource(int.parse(id));
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      var updatedSource = source.updateWithJson(json);
      await SourceService().updateSource(updatedSource);
      return response(updatedSource);
    } catch (error) {
      return response({"message": error.toString()}, statusCode: 500);
    }
  }
}
