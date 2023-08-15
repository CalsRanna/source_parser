import 'package:creator/creator.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/util/parser.dart';

final hotHistoriesEmitter = Emitter<List<Book>>((ref, emit) async {
  final histories = await Parser.topSearch();
  emit(histories);
}, name: 'hotHistoriesEmitter');

final historyCreator = Creator<History>.value(
  History(),
  name: 'historyCreator',
);
