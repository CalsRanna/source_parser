import 'package:creator/creator.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/parser.dart';

final booksCreator = Creator<List<Book>>.value(
  [],
  keepAlive: true,
  name: 'booksCreator',
);

final currentBookCreator = Creator.value(
  Book(),
  keepAlive: true,
  name: 'currentBookCreator',
);

final topSearchEmitter = Emitter<List<Book>>((ref, emit) async {
  final books = await Parser.topSearch();
  emit(books);
}, name: 'topSearchEmitter');
