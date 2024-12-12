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
    var appBarSection = _ButtonSection(
      title: 'AppBar按钮 (最多2个)',
      buttons: layout.appBarButtons,
      onChanged: (positions) => updateAppBarButtons(ref, positions),
    );
    var bottomBarSection = _ButtonSection(
      title: 'BottomBar按钮 (最多3个)',
      buttons: layout.bottomBarButtons,
      onChanged: (positions) => updateBottomBarButtons(ref, positions),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('布局')),
      body: ListView(children: [appBarSection, bottomBarSection]),
    );
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
}

class _ButtonSection extends StatelessWidget {
  final String title;
  final List<ButtonPosition> buttons;
  final ValueChanged<List<ButtonPosition>> onChanged;

  const _ButtonSection({
    required this.title,
    required this.buttons,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var switchListTile = SwitchListTile(
      onChanged: handleChanged,
      title: Text(title),
      value: buttons.isNotEmpty,
    );
    var wrap = Wrap(
      spacing: 16,
      runSpacing: 16,
      children: ButtonPosition.values.map(_toElement).toList(),
    );
    var children = [
      switchListTile,
      Padding(padding: const EdgeInsets.all(16.0), child: wrap),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  void handleChanged(bool value) {
    onChanged.call(value ? ButtonPosition.values : []);
  }

  void handleSelected(ButtonPosition position) {
    var newButtons = List<ButtonPosition>.from(buttons);
    if (newButtons.contains(position)) {
      newButtons.remove(position);
    } else {
      newButtons.add(position);
    }
    newButtons.sort(_compare);
    onChanged(newButtons);
  }

  int _compare(ButtonPosition a, ButtonPosition b) {
    var indexA = ButtonPosition.values.indexOf(a);
    var indexB = ButtonPosition.values.indexOf(b);
    return indexA.compareTo(indexB);
  }

  Widget _toElement(ButtonPosition position) {
    var selected = buttons.contains(position);
    return _Chip(
      onSelected: () => handleSelected(position),
      position: position,
      selected: selected,
    );
  }
}

class _Chip extends StatelessWidget {
  final void Function()? onSelected;
  final ButtonPosition position;
  final bool selected;
  const _Chip({
    this.onSelected,
    required this.position,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      showCheckmark: false,
      selected: selected,
      label: Text(_getButtonLabel(position)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      avatar: Icon(_getButtonIcon(position)),
      onSelected: handleSelected,
    );
  }

  void handleSelected(bool value) {
    onSelected?.call();
  }

  IconData _getButtonIcon(ButtonPosition position) {
    return switch (position) {
      ButtonPosition.audio => HugeIcons.strokeRoundedHeadphones,
      ButtonPosition.cache => HugeIcons.strokeRoundedDownload04,
      ButtonPosition.catalogue => HugeIcons.strokeRoundedMenu01,
      ButtonPosition.darkMode => HugeIcons.strokeRoundedMoon02,
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
      ButtonPosition.information => '信息',
      ButtonPosition.nextChapter => '下一章',
      ButtonPosition.previousChapter => '上一章',
      ButtonPosition.source => '书源',
      ButtonPosition.theme => '主题',
    };
  }
}
