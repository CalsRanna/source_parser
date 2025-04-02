import 'package:isar/isar.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/schema/available_source.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';

class AvailableSourceViewModel {
  final Book book;

  AvailableSourceViewModel({required this.book});

  late final availableSources = signal(<AvailableSource>[]);

  Future<void> getAvailableSources() async {
    var queryBuilder = isar.availableSources.filter().bookIdEqualTo(book.id);
    final sources = await queryBuilder.findAll();
    availableSources.value = sources;
  }

  Future<void> destroyAvailableSource(AvailableSource source) async {
    availableSources.value.remove(source);
    await isar.writeTxn(() async {
      await isar.availableSources.delete(source.id);
    });
  }
}
