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
    var service = SourceService();
    try {
      var count = await service.countSourceById(int.parse(id));
      if (count == 0) return error('Source not found');
      await service.destroySource(int.parse(id));
      return response({}, statusCode: 204);
    } catch (e) {
      return error(e);
    }
  }

  Future<Response> index(Request request) async {
    final sources = await SourceService().getAllSources();
    return response(sources);
  }

  Future<Response> show(Request request, String id) async {
    try {
      var count = await SourceService().countSourceById(int.parse(id));
      if (count == 0) return response(null);
      final source = await SourceService().getBookSource(int.parse(id));
      return response(source);
    } catch (e) {
      return error(e);
    }
  }

  Future<Response> store(Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      var count = await SourceService().countSourceByNameAndUrl(
        json['name'],
        json['url'],
      );
      if (count > 0) return error('Source already exists');
      final source = SourceEntity.fromJson(json);
      await SourceService().addSources([source]);
      return response(source, statusCode: 201);
    } catch (e) {
      return error(e);
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      var source = await SourceService().getBookSource(int.parse(id));
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      var updatedSource = source.updateWithJson(json);
      await SourceService().updateSource(updatedSource);
      return response(updatedSource);
    } catch (e) {
      return error(e);
    }
  }
}
