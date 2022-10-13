import 'package:creator/creator.dart';
import 'package:source_parser/state/global.dart';

import '../model/book.dart';
import '../util/parser.dart';

final topSearchBooksCreator = Emitter<List<Book>>(
  (ref, emit) async {
    final books = await Parser.topSearch();
    emit(books);
  },
  // keepAlive: true,
  name: 'topSearchBooks',
);

final searchBooksCreator = Creator<List<Book>?>.value(
  null,
  name: 'searchBooks',
);

final bookCreator = Creator<Book?>.value(
  null,
  name: 'book',
);

final loadingOfBookCreator = Creator.value(true, name: 'loadingOfBookCreator');

final shelfBooksEmitter = Emitter<List<Book>?>(
  (ref, emit) async {
    final database = ref.watch(databaseEmitter.asyncData).data;
    final books = await database?.bookDao.getAllBooks();
    emit(books);
  },
  name: 'shelfBooksEmitter',
);
