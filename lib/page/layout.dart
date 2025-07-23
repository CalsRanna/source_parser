import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/provider/layout.dart';
import 'package:source_parser/schema/layout.dart';

@RoutePage()
class ReaderLayoutPage extends ConsumerWidget {
  const ReaderLayoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(readerLayoutNotifierProviderProvider).valueOrNull;
    if (layout == null) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        actions: _buildTopSlots(context, layout),
        title: const Text('布局'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(children: _buildBottomSlots(context, layout)),
      ),
      floatingActionButton: _buildFloatingSlot(context, layout),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  Future<void> showSlotSheet(BuildContext context, int index) async {
    var position = await showModalBottomSheet<LayoutSlot>(
      builder: (_) => _ButtonPositionBottomSheet(),
      context: context,
      showDragHandle: true,
    );
    if (position == null) return;
    if (!context.mounted) return;
    var container = ProviderScope.containerOf(context);
    var provider = readerLayoutNotifierProviderProvider;
    var notifier = container.read(provider.notifier);
    notifier.updateSlot(position, index: index);
  }

  List<Widget> _buildBottomSlots(BuildContext context, Layout layout) {
    var slot2 = _LayoutSlot(
      onTap: () => showSlotSheet(context, 2),
      slot: layout.slot2,
    );
    var slot3 = _LayoutSlot(
      onTap: () => showSlotSheet(context, 3),
      slot: layout.slot3,
    );
    var slot4 = _LayoutSlot(
      onTap: () => showSlotSheet(context, 4),
      slot: layout.slot4,
    );
    var slot5 = _LayoutSlot(
      onTap: () => showSlotSheet(context, 5),
      slot: layout.slot5,
    );
    return [slot2, slot3, slot4, slot5];
  }

  Widget _buildFloatingSlot(BuildContext context, Layout layout) {
    return FloatingActionButton(
      onPressed: () => showSlotSheet(context, 6),
      child: _LayoutSlot(slot: layout.slot6),
    );
  }

  List<Widget> _buildTopSlots(BuildContext context, Layout layout) {
    var slot0 = _LayoutSlot(
      onTap: () => showSlotSheet(context, 0),
      slot: layout.slot0,
    );
    var slot1 = _LayoutSlot(
      onTap: () => showSlotSheet(context, 1),
      slot: layout.slot1,
    );
    return [slot0, slot1];
  }
}

class _ButtonPositionBottomSheet extends StatelessWidget {
  const _ButtonPositionBottomSheet();

  @override
  Widget build(BuildContext context) {
    var children = LayoutSlot.values
        .map((position) => _toElement(context, position))
        .toList();
    var wrap = Wrap(spacing: 16, runSpacing: 16, children: children);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: wrap,
    );
  }

  void selectButtonPosition(BuildContext context, LayoutSlot position) {
    Navigator.pop(context, position);
  }

  IconData _getButtonIcon(LayoutSlot position) {
    return switch (position) {
      LayoutSlot.audio => HugeIcons.strokeRoundedHeadphones,
      LayoutSlot.cache => HugeIcons.strokeRoundedDownload04,
      LayoutSlot.catalogue => HugeIcons.strokeRoundedMenu01,
      LayoutSlot.darkMode => HugeIcons.strokeRoundedMoon02,
      LayoutSlot.forceRefresh => HugeIcons.strokeRoundedRefresh,
      LayoutSlot.information => HugeIcons.strokeRoundedBook01,
      LayoutSlot.more => HugeIcons.strokeRoundedMoreVertical,
      LayoutSlot.nextChapter => HugeIcons.strokeRoundedNext,
      LayoutSlot.previousChapter => HugeIcons.strokeRoundedPrevious,
      LayoutSlot.source => HugeIcons.strokeRoundedExchange01,
      LayoutSlot.theme => HugeIcons.strokeRoundedTextFont,
    };
  }

  String _getButtonLabel(LayoutSlot position) {
    return switch (position) {
      LayoutSlot.audio => '朗读',
      LayoutSlot.cache => '缓存',
      LayoutSlot.catalogue => '目录',
      LayoutSlot.darkMode => '夜间模式',
      LayoutSlot.forceRefresh => '强制刷新',
      LayoutSlot.information => '书籍信息',
      LayoutSlot.more => StringConfig.more,
      LayoutSlot.nextChapter => '下一章',
      LayoutSlot.previousChapter => '上一章',
      LayoutSlot.source => '切换书源',
      LayoutSlot.theme => '主题',
    };
  }

  Widget _toElement(BuildContext context, LayoutSlot position) {
    return FilterChip(
      showCheckmark: false,
      label: Text(_getButtonLabel(position)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      avatar: Icon(_getButtonIcon(position)),
      onSelected: (_) => selectButtonPosition(context, position),
    );
  }
}

class _LayoutSlot extends StatelessWidget {
  final void Function()? onTap;
  final String slot;
  const _LayoutSlot({this.onTap, required this.slot});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onTap, icon: Icon(_getIconData()));
  }

  IconData _getIconData() {
    if (slot.isEmpty) return HugeIcons.strokeRoundedDashedLine02;
    var values = LayoutSlot.values;
    var layoutSlot = values.firstWhere((value) => value.name == slot);
    return switch (layoutSlot) {
      LayoutSlot.audio => HugeIcons.strokeRoundedHeadphones,
      LayoutSlot.cache => HugeIcons.strokeRoundedDownload04,
      LayoutSlot.catalogue => HugeIcons.strokeRoundedMenu01,
      LayoutSlot.darkMode => HugeIcons.strokeRoundedMoon02,
      LayoutSlot.forceRefresh => HugeIcons.strokeRoundedRefresh,
      LayoutSlot.information => HugeIcons.strokeRoundedBook01,
      LayoutSlot.more => HugeIcons.strokeRoundedMoreVertical,
      LayoutSlot.nextChapter => HugeIcons.strokeRoundedNext,
      LayoutSlot.previousChapter => HugeIcons.strokeRoundedPrevious,
      LayoutSlot.source => HugeIcons.strokeRoundedExchange01,
      LayoutSlot.theme => HugeIcons.strokeRoundedTextFont,
    };
  }
}
