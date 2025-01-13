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
    layout = Layout(
      appBarButtons: [ButtonPosition.cache, ButtonPosition.darkMode],
      bottomBarButtons: [
        ButtonPosition.catalogue,
        ButtonPosition.previousChapter,
        ButtonPosition.nextChapter,
      ],
    );
    await isar.writeTxn(() async {
      await isar.layouts.put(layout!);
    });
    return layout;
  }

  Future<void> updateSlot(ButtonPosition position, {int index = 0}) async {
    final currentLayout = await future;
    var topActions = [...currentLayout.appBarButtons];
    var bottomActions = [...currentLayout.bottomBarButtons];
    if (index < 2) topActions[index] = position;
    if (index >= 2) bottomActions[index - 2] = position;
    currentLayout.appBarButtons = topActions;
    currentLayout.bottomBarButtons = bottomActions;
    await isar.writeTxn(() async {
      await isar.layouts.put(currentLayout);
    });
    ref.invalidateSelf();
  }

  Future<void> updateAppBarButtons(List<ButtonPosition> buttons) async {
    if (buttons.length > 2) return;
    final currentLayout = await future;
    currentLayout.appBarButtons = buttons;
    await isar.writeTxn(() async {
      await isar.layouts.put(currentLayout);
    });
    ref.invalidateSelf();
  }

  Future<void> updateBottomBarButtons(List<ButtonPosition> buttons) async {
    if (buttons.length > 3) return;
    final currentLayout = await future;
    currentLayout.bottomBarButtons = buttons;
    await isar.writeTxn(() async {
      await isar.layouts.put(currentLayout);
    });
    ref.invalidateSelf();
  }
}
