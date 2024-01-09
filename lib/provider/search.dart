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
    return await Parser.today(duration, timeout);
  }
}

@riverpod
class SearchBooks extends _$SearchBooks {
  @override
  Future<Stream<List<Book>>> build(String credential) async {
    final controller = StreamController<List<Book>>();
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = Duration(hours: setting.cacheDuration.floor());
    final timeout = Duration(milliseconds: setting.timeout);
    final maxConcurrent = setting.maxConcurrent.floor();
    final stream =
        await Parser.search(credential, maxConcurrent, duration, timeout);
    List<Book> books = [];
    stream.listen(
      (book) {
        books.add(book);
        controller.add(books);
      },
      onDone: () => controller.close(),
      onError: (error) => controller.close(),
    );
    return controller.stream;
  }
}
