import 'package:creator/creator.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/schema/book.dart';

Emitter<Book> bookEmitter(int? id) {
  return Emitter((ref, emit) async {
    final book =
        await isar.books.filter().idEqualTo(id ?? 0).findFirst() ?? Book();
    emit(book);
  }, args: ['book', id], name: 'bookEmitter_$id');
}
