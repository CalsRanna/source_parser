import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/setting.dart';

class ReaderThemePage extends StatelessWidget {
  const ReaderThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyLarge = textTheme.bodyLarge;
    return Scaffold(
      appBar: AppBar(
        title: const Text('阅读主题'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final provider = ref.watch(settingNotifierProvider);
          final setting = switch (provider) {
            AsyncData(:final value) => value,
            _ => Setting(),
          };
          final lineSpace = setting.lineSpace;
          final fontSize = setting.fontSize;
          final backgroundColor = setting.backgroundColor;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text('行间距', style: bodyLarge),
                    const Spacer(),
                    _ThemeTile(
                      active: lineSpace == 1.0 + 0.618 * 3,
                      label: '较大',
                      onTap: () => updateLineSpace(ref, 1.0 + 0.618 * 3),
                    ),
                    const SizedBox(width: 8),
                    _ThemeTile(
                      active: lineSpace == 1.0 + 0.618 * 2,
                      label: '适中',
                      onTap: () => updateLineSpace(ref, 1.0 + 0.618 * 2),
                    ),
                    const SizedBox(width: 8),
                    _ThemeTile(
                      active: lineSpace == 1.0 + 0.618 * 1,
                      label: '较小',
                      onTap: () => updateLineSpace(ref, 1.0 + 0.618 * 1),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text('字号', style: bodyLarge),
                    const Spacer(),
                    _ThemeTile(
                      label: 'A-',
                      onTap: () => updateFontSize(ref, -1),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 40,
                      child: Text(fontSize.toString()),
                    ),
                    _ThemeTile(
                      label: 'A+',
                      onTap: () => updateFontSize(ref, 1),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text('背景', style: bodyLarge),
                    const Spacer(),
                    _BackgroundTile(
                      active: backgroundColor == Colors.white.value,
                      color: Colors.white,
                      onTap: () => updateBackgroundColor(
                        ref,
                        Colors.white.value,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _BackgroundTile(
                      active: backgroundColor == 0xFFF0F5E5,
                      color: const Color(0xFFF0F5E5),
                      onTap: () => updateBackgroundColor(ref, 0xFFF0F5E5),
                    ),
                    const SizedBox(width: 8),
                    _BackgroundTile(
                      active: backgroundColor == 0xFFC7D2D4,
                      color: const Color(0xFFC7D2D4),
                      onTap: () => updateBackgroundColor(ref, 0xFFC7D2D4),
                    ),
                    const SizedBox(width: 8),
                    _BackgroundTile(
                      active: backgroundColor == 0xFFE3BD8D,
                      color: const Color(0xFFE3BD8D),
                      onTap: () => updateBackgroundColor(ref, 0xFFE3BD8D),
                    ),
                    const SizedBox(width: 8),
                    _BackgroundTile(
                      active: backgroundColor == 0xFFb7ae8f,
                      color: const Color(0xFFb7ae8f),
                      onTap: () => updateBackgroundColor(ref, 0xFFb7ae8f),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void updateLineSpace(WidgetRef ref, double value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateLineSpace(value);
  }

  void updateFontSize(WidgetRef ref, int step) async {}

  void updateBackgroundColor(WidgetRef ref, int colorValue) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateBackgroundColor(colorValue);
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    this.active = false,
    required this.label,
    this.onTap,
  });

  final bool active;
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final outline = colorScheme.outline;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(
              color: active ? primary : outline.withOpacity(0.5),
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text(label),
      ),
    );
  }
}

class _BackgroundTile extends StatelessWidget {
  const _BackgroundTile({
    this.active = false,
    required this.color,
    this.onTap,
  });

  final bool active;
  final Color color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final outline = colorScheme.outline;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: color,
          shape: CircleBorder(
            side:
                BorderSide(color: active ? primary : outline.withOpacity(0.5)),
          ),
        ),
        height: 28,
        padding: const EdgeInsets.all(1),
        width: 28,
      ),
    );
  }
}
