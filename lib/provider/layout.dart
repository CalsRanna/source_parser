import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/layout.dart';

part 'layout.g.dart';

@riverpod
class ReaderLayoutNotifierProvider extends _$ReaderLayoutNotifierProvider {
  @override
  Future<Layout> build() async {
    var layout = await isar.layouts.where().findFirst();
    if (layout != null) return layout;
    layout = Layout();
    await isar.writeTxn(() async {
      await isar.layouts.put(layout!);
    });
    return layout;
  }

  Future<void> updateSlot(LayoutSlot slot, {int index = 0}) async {
    final layout = await future;
    if (index == 0) layout.slot0 = slot.name;
    if (index == 1) layout.slot1 = slot.name;
    if (index == 2) layout.slot2 = slot.name;
    if (index == 3) layout.slot3 = slot.name;
    if (index == 4) layout.slot4 = slot.name;
    if (index == 5) layout.slot5 = slot.name;
    if (index == 6) layout.slot6 = slot.name;
    await isar.writeTxn(() async {
      await isar.layouts.put(layout);
    });
    ref.invalidateSelf();
  }
}
