import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/parser.dart';

part 'search.g.dart';

@riverpod
class TopSearchBooks extends _$TopSearchBooks {
  @override
  Future<List<Book>> build() async {
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = Duration(hours: setting.cacheDuration.floor());
    final timeout = Duration(milliseconds: setting.timeout);
    return await Parser.topSearch(duration, timeout);
  }
}
