import 'package:creator/creator.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/parser.dart';

final hotHistoriesEmitter = Emitter<List<Book>>((ref, emit) async {
  final histories = await Parser.topSearch();
  emit(histories);
}, name: 'hotHistoriesEmitter');

final historiesCreator = Creator<List<Book>>.value(
  [],
  keepAlive: true,
  name: 'historiesCreator',
);
