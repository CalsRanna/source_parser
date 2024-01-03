import 'package:creator/creator.dart';
import 'package:source_parser/creator/setting.dart';
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
  final duration = ref.read(cacheDurationCreator);
  final timeout = ref.read(timeoutCreator);
  final books = await Parser.today(
    Duration(hours: duration.floor()),
    Duration(milliseconds: timeout),
  );
  emit(books);
}, name: 'topSearchEmitter');
