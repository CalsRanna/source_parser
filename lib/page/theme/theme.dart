import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/theme/color_picker.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';

@RoutePage()
class ReaderThemePage extends StatelessWidget {
  const ReaderThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      _HeightTile(),
      _FontSizeTile(),
      _BackgroundTile(),
      _LayoutTile(),
      _ColorGeneratorTile(),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('阅读主题')),
      body: ListView(children: children),
    );
  }
}

class _BackgroundTile extends ConsumerWidget {
  const _BackgroundTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final backgroundColor = setting?.backgroundColor ?? 0xFFFFFFFF;
    final whiteTile = _ColorTile(
      active: backgroundColor == Colors.white.value,
      color: Colors.white,
      onTap: () => handleTap(ref, Colors.white.value),
    );
    final greenTile = _ColorTile(
      active: backgroundColor == 0xFFF0F5E5,
      color: const Color(0xFFF0F5E5),
      onTap: () => handleTap(ref, 0xFFF0F5E5),
    );
    final greyTile = _ColorTile(
      active: backgroundColor == 0xFFC7D2D4,
      color: const Color(0xFFC7D2D4),
      onTap: () => handleTap(ref, 0xFFC7D2D4),
    );
    final brownTile = _ColorTile(
      active: backgroundColor == 0xFFE3BD8D,
      color: const Color(0xFFE3BD8D),
      onTap: () => handleTap(ref, 0xFFE3BD8D),
    );
    final bronzeTile = _ColorTile(
      active: backgroundColor == 0xFFb7ae8f,
      color: const Color(0xFFb7ae8f),
      onTap: () => handleTap(ref, 0xFFb7ae8f),
    );
    final children = [
      whiteTile,
      const SizedBox(width: 8),
      greenTile,
      const SizedBox(width: 8),
      greyTile,
      const SizedBox(width: 8),
      brownTile,
      const SizedBox(width: 8),
      bronzeTile,
    ];
    final row = Row(mainAxisSize: MainAxisSize.min, children: children);
    return ListTile(title: Text('背景'), trailing: row);
  }

  void handleTap(WidgetRef ref, int colorValue) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateBackgroundColor(colorValue);
  }
}

class _ColorGeneratorTile extends StatelessWidget {
  const _ColorGeneratorTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => ColorPicker.pick(context),
      title: Text('Color Generator'),
      trailing: const Icon(HugeIcons.strokeRoundedArrowRight01),
    );
  }
}

class _ColorTile extends StatelessWidget {
  final bool active;

  final Color color;
  final void Function()? onTap;
  const _ColorTile({
    this.active = false,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final outline = colorScheme.outline;
    final borderSide = BorderSide(
      color: active ? primary : outline.withOpacity(0.5),
      width: active ? 2 : 1,
    );
    final shapeDecoration = ShapeDecoration(
      color: color,
      shape: CircleBorder(side: borderSide),
    );
    final container = Container(
      decoration: shapeDecoration,
      height: 28,
      padding: const EdgeInsets.all(1),
      width: 28,
      child: active
          ? Icon(HugeIcons.strokeRoundedTick02, size: 16, color: primary)
          : null,
    );
    return GestureDetector(onTap: onTap, child: container);
  }
}

class _FontSizeTile extends ConsumerWidget {
  const _FontSizeTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final fontSize = setting?.fontSize ?? 18;
    var decreaseButton = OutlinedButton(
      onPressed: () => handleTap(ref, -1),
      child: Icon(HugeIcons.strokeRoundedRemove01),
    );
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium;
    final text = Container(
      alignment: Alignment.center,
      width: 40,
      child: Text(fontSize.toString(), style: style),
    );
    final increaseButton = OutlinedButton(
      onPressed: () => handleTap(ref, 1),
      child: Icon(HugeIcons.strokeRoundedAdd01),
    );
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [decreaseButton, text, increaseButton],
    );
    return ListTile(title: Text('字体大小'), trailing: row);
  }

  void handleTap(WidgetRef ref, int step) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateFontSize(step);
  }
}

class _HeightTile extends ConsumerWidget {
  const _HeightTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final height = setting?.lineSpace ?? 1.0 + 0.618 * 2;
    final largeChip = FilterChip(
      label: Text('较大'),
      onSelected: (_) => handleSelected(ref, 1.0 + 0.618 * 3),
      selected: height == 1.0 + 0.618 * 3,
    );
    final mediumChip = FilterChip(
      label: Text('适中'),
      onSelected: (_) => handleSelected(ref, 1.0 + 0.618 * 2),
      selected: height == 1.0 + 0.618 * 2,
    );
    final smallChip = FilterChip(
      label: Text('较小'),
      onSelected: (_) => handleSelected(ref, 1.0 + 0.618 * 1),
      selected: height == 1.0 + 0.618 * 1,
    );
    final children = [
      largeChip,
      const SizedBox(width: 8),
      mediumChip,
      const SizedBox(width: 8),
      smallChip,
    ];
    final row = Row(mainAxisSize: MainAxisSize.min, children: children);
    return ListTile(title: Text('行间距'), trailing: row);
  }

  void handleSelected(WidgetRef ref, double value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateLineSpace(value);
  }
}

class _LayoutTile extends StatelessWidget {
  const _LayoutTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => AutoRouter.of(context).push(ReaderLayoutRoute()),
      title: Text('布局'),
      trailing: const Icon(HugeIcons.strokeRoundedArrowRight01),
    );
  }
}
