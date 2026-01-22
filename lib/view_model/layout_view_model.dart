import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/layout_service.dart';
import 'package:source_parser/schema/layout.dart';

class LayoutViewModel {
  final layout = signal<Layout>(Layout());
  final loading = signal(false);
  final _layoutService = LayoutService();

  Future<void> initSignals() async {
    loading.value = true;
    await _loadLayout();
    loading.value = false;
  }

  Future<void> _loadLayout() async {
    var currentLayout = await _layoutService.getLayout();
    if (currentLayout == null) {
      currentLayout = Layout()
        ..slot0 = LayoutSlot.cache.name
        ..slot1 = LayoutSlot.darkMode.name
        ..slot2 = LayoutSlot.more.name
        ..slot3 = LayoutSlot.catalogue.name
        ..slot4 = LayoutSlot.previousChapter.name
        ..slot5 = LayoutSlot.nextChapter.name
        ..slot6 = LayoutSlot.source.name;

      await _layoutService.createLayout(currentLayout);
    }
    layout.value = currentLayout;
  }

  Future<void> updateSlot(LayoutSlot slot, {int index = 0}) async {
    final currentLayout = layout.value;

    if (index == 0) currentLayout.slot0 = slot.name;
    if (index == 1) currentLayout.slot1 = slot.name;
    if (index == 2) currentLayout.slot2 = slot.name;
    if (index == 3) currentLayout.slot3 = slot.name;
    if (index == 4) currentLayout.slot4 = slot.name;
    if (index == 5) currentLayout.slot5 = slot.name;
    if (index == 6) currentLayout.slot6 = slot.name;

    await _layoutService.updateLayout(currentLayout);
    layout.value = currentLayout;
  }
}
