import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:shelf/shelf.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/local_server/controller/controller.dart';

class LocalServerSourceController with LocalServerController {
  static LocalServerSourceController? _instance;

  static LocalServerSourceController get instance =>
      _instance ??= LocalServerSourceController._();

  LocalServerSourceController._();

  Future<Response> destroy(Request request, String id) async {
    final source = await isar.sources.get(int.parse(id));
    if (source == null) return response(null);
    await isar.writeTxn(() async {
      return await isar.sources.delete(int.parse(id));
    });
    return response(source, statusCode: 204);
  }

  Future<Response> index(Request request) async {
    final sources = await isar.sources.where().findAll();
    return response(sources);
  }

  Future<Response> show(Request request, String id) async {
    final source = await isar.sources.get(int.parse(id));
    return response(source);
  }

  Future<Response> store(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final source = Source.fromJson(data);
    await isar.writeTxn(() async {
      await isar.sources.put(source);
    });
    return response(source, statusCode: 201);
  }

  Future<Response> update(Request request, String id) async {
    final source = await isar.sources.get(int.parse(id));
    if (source == null) return response(null);
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    var newSource = source.copyWithMap(data);
    await isar.writeTxn(() async {
      await isar.sources.put(newSource);
    });
    return response(newSource);
  }
}
