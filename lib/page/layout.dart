import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
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
        actions: _buildActions(context, layout),
        title: const Text('布局'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(children: _buildBottomActions(context, layout)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showActionSheet(context, -1),
        child: const Icon(HugeIcons.strokeRoundedAdd01),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  Future<void> showActionSheet(BuildContext context, int index) async {
    var position = await showModalBottomSheet<ButtonPosition>(
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

  void updateAppBarButtons(WidgetRef ref, List<ButtonPosition> positions) {
    var provider = readerLayoutNotifierProviderProvider;
    var notifier = ref.read(provider.notifier);
    notifier.updateAppBarButtons(positions);
  }

  void updateBottomBarButtons(WidgetRef ref, List<ButtonPosition> positions) {
    var provider = readerLayoutNotifierProviderProvider;
    var notifier = ref.read(provider.notifier);
    notifier.updateBottomBarButtons(positions);
  }

  List<Widget> _buildActions(BuildContext context, Layout layout) {
    var actions = <Widget>[];
    for (var i = 0; i < 2; i++) {
      var layoutIconButton = _LayoutIconButton(
        onTap: () => showActionSheet(context, i),
        position: layout.appBarButtons.elementAtOrNull(i),
      );
      actions.add(layoutIconButton);
    }
    return actions;
  }

  List<Widget> _buildBottomActions(BuildContext context, Layout layout) {
    var actions = <Widget>[];
    for (var i = 0; i < 3; i++) {
      var layoutIconButton = _LayoutIconButton(
        onTap: () => showActionSheet(context, i + 2),
        position: layout.bottomBarButtons.elementAtOrNull(i),
      );
      actions.add(layoutIconButton);
    }
    return actions;
  }
}

class _ButtonPositionBottomSheet extends StatelessWidget {
  const _ButtonPositionBottomSheet();

  @override
  Widget build(BuildContext context) {
    var children = ButtonPosition.values
        .map((position) => _toElement(context, position))
        .toList();
    var wrap = Wrap(spacing: 16, runSpacing: 16, children: children);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: wrap,
    );
  }

  void selectButtonPosition(BuildContext context, ButtonPosition position) {
    Navigator.pop(context, position);
  }

  IconData _getButtonIcon(ButtonPosition position) {
    return switch (position) {
      ButtonPosition.audio => HugeIcons.strokeRoundedHeadphones,
      ButtonPosition.cache => HugeIcons.strokeRoundedDownload04,
      ButtonPosition.catalogue => HugeIcons.strokeRoundedMenu01,
      ButtonPosition.darkMode => HugeIcons.strokeRoundedMoon02,
      ButtonPosition.forceRefresh => HugeIcons.strokeRoundedRefresh,
      ButtonPosition.information => HugeIcons.strokeRoundedBook01,
      ButtonPosition.nextChapter => HugeIcons.strokeRoundedNext,
      ButtonPosition.previousChapter => HugeIcons.strokeRoundedPrevious,
      ButtonPosition.source => HugeIcons.strokeRoundedExchange01,
      ButtonPosition.theme => HugeIcons.strokeRoundedTextFont,
    };
  }

  String _getButtonLabel(ButtonPosition position) {
    return switch (position) {
      ButtonPosition.audio => '朗读',
      ButtonPosition.cache => '缓存',
      ButtonPosition.catalogue => '目录',
      ButtonPosition.darkMode => '夜间模式',
      ButtonPosition.forceRefresh => '强制刷新',
      ButtonPosition.information => '书籍信息',
      ButtonPosition.nextChapter => '下一章',
      ButtonPosition.previousChapter => '上一章',
      ButtonPosition.source => '切换书源',
      ButtonPosition.theme => '主题',
    };
  }

  Widget _toElement(BuildContext context, ButtonPosition position) {
    return FilterChip(
      showCheckmark: false,
      label: Text(_getButtonLabel(position)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      avatar: Icon(_getButtonIcon(position)),
      onSelected: (_) => selectButtonPosition(context, position),
    );
  }
}

class _LayoutIconButton extends StatelessWidget {
  final void Function()? onTap;
  final ButtonPosition? position;
  const _LayoutIconButton({this.onTap, this.position});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onTap, icon: Icon(_getIconData()));
  }

  IconData _getIconData() {
    return switch (position) {
      ButtonPosition.audio => HugeIcons.strokeRoundedHeadphones,
      ButtonPosition.cache => HugeIcons.strokeRoundedDownload04,
      ButtonPosition.catalogue => HugeIcons.strokeRoundedMenu01,
      ButtonPosition.darkMode => HugeIcons.strokeRoundedMoon02,
      ButtonPosition.forceRefresh => HugeIcons.strokeRoundedRefresh,
      ButtonPosition.information => HugeIcons.strokeRoundedBook01,
      ButtonPosition.nextChapter => HugeIcons.strokeRoundedNext,
      ButtonPosition.previousChapter => HugeIcons.strokeRoundedPrevious,
      ButtonPosition.source => HugeIcons.strokeRoundedExchange01,
      ButtonPosition.theme => HugeIcons.strokeRoundedTextFont,
      _ => HugeIcons.strokeRoundedDashedLine02,
    };
  }
}
