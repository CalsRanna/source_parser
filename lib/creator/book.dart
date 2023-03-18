import 'package:creator/creator.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/state/global.dart';

final bookEmitter = Emitter.arg1<Book, int?>((ref, id, emit) async {
  final isar = await ref.watch(isarEmitter);
  final book =
      await isar.books.filter().idEqualTo(id ?? 0).findFirst() ?? Book();
  emit(book);
}, name: (id) => 'bookEmitter_$id');
