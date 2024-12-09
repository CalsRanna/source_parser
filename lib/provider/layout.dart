import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/layout.dart';

part 'layout.g.dart';

@riverpod
class ReaderLayoutNotifierProvider extends _$ReaderLayoutNotifierProvider {
  @override
  Future<ReaderLayout> build() async {
    var layout = await isar.readerLayouts.where().findFirst();
    if (layout != null) return layout;
    layout = ReaderLayout(
      appBarButtons: [ButtonPosition.cache, ButtonPosition.darkMode],
      bottomBarButtons: [
        ButtonPosition.catalogue,
        ButtonPosition.source,
        ButtonPosition.previousChapter,
        ButtonPosition.nextChapter,
      ],
    );
    await isar.writeTxn(() async {
      await isar.readerLayouts.put(layout!);
    });
    return layout;
  }

  Future<void> updateAppBarButtons(List<ButtonPosition> buttons) async {
    if (buttons.length > 2) return;
    final currentLayout = await future;
    currentLayout.appBarButtons = buttons;
    await isar.writeTxn(() async {
      await isar.readerLayouts.put(currentLayout);
    });
    ref.invalidateSelf();
  }

  Future<void> updateBottomBarButtons(List<ButtonPosition> buttons) async {
    if (buttons.length > 3) return;
    final currentLayout = await future;
    currentLayout.bottomBarButtons = buttons;
    await isar.writeTxn(() async {
      await isar.readerLayouts.put(currentLayout);
    });
    ref.invalidateSelf();
  }
}
