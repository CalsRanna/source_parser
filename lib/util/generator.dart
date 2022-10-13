import 'dart:convert';

import 'package:source_parser/database/database.dart';

class Generator {
  static Future<String> sourcesJson(AppDatabase database) async {
    final sources = await database.bookSourceDao.getAllBookSources();
    var list = <Map<String, dynamic>>[];
    for (var source in sources) {
      final rules = await database.ruleDao.getRulesBySourceId(source.id!);
      var map = source.toJson();
      for (var rule in rules) {
        map[rule.name] = rule.value;
      }
      list.add(map);
    }
    return const JsonCodec().encode(list);
  }
}
