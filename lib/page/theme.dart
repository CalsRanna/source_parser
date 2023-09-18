import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';

class ReaderTheme extends StatelessWidget {
  const ReaderTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyLarge = textTheme.bodyLarge;
    return Scaffold(
      appBar: AppBar(
        title: const Text('阅读主题'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Watcher((context, ref, child) {
            final lineSpace = ref.watch(lineSpaceCreator);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text('行间距', style: bodyLarge),
                  const Spacer(),
                  _ThemeTile(
                    active: lineSpace == 1.0 + 0.618 * 3,
                    label: '较大',
                    onTap: () => updateLineSpace(context, 1.0 + 0.618 * 3),
                  ),
                  const SizedBox(width: 8),
                  _ThemeTile(
                    active: lineSpace == 1.0 + 0.618 * 2,
                    label: '适中',
                    onTap: () => updateLineSpace(context, 1.0 + 0.618 * 2),
                  ),
                  const SizedBox(width: 8),
                  _ThemeTile(
                    active: lineSpace == 1.0 + 0.618 * 1,
                    label: '较小',
                    onTap: () => updateLineSpace(context, 1.0 + 0.618 * 1),
                  ),
                ],
              ),
            );
          }),
          Watcher((context, ref, child) {
            final fontSize = ref.watch(fontSizeCreator);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text('字号', style: bodyLarge),
                  const Spacer(),
                  _ThemeTile(
                    label: 'A-',
                    onTap: () => updateFontSize(context, -1),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 40,
                    child: Text(fontSize.toString()),
                  ),
                  _ThemeTile(
                    label: 'A+',
                    onTap: () => updateFontSize(context, 1),
                  ),
                ],
              ),
            );
          }),
          Watcher((context, ref, child) {
            final backgroundColor = ref.watch(backgroundColorCreator);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text('背景', style: bodyLarge),
                  const Spacer(),
                  _BackgroundTile(
                    active: backgroundColor == Colors.white.value,
                    color: Colors.white,
                    onTap: () => updateBackgroundColor(
                      context,
                      Colors.white.value,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _BackgroundTile(
                    active: backgroundColor == 0xFFF0F5E5,
                    color: const Color(0xFFF0F5E5),
                    onTap: () => updateBackgroundColor(context, 0xFFF0F5E5),
                  ),
                  const SizedBox(width: 8),
                  _BackgroundTile(
                    active: backgroundColor == 0xFFC7D2D4,
                    color: const Color(0xFFC7D2D4),
                    onTap: () => updateBackgroundColor(context, 0xFFC7D2D4),
                  ),
                  const SizedBox(width: 8),
                  _BackgroundTile(
                    active: backgroundColor == 0xFFE3BD8D,
                    color: const Color(0xFFE3BD8D),
                    onTap: () => updateBackgroundColor(context, 0xFFE3BD8D),
                  ),
                  const SizedBox(width: 8),
                  _BackgroundTile(
                    active: backgroundColor == 0xFFb7ae8f,
                    color: const Color(0xFFb7ae8f),
                    onTap: () => updateBackgroundColor(context, 0xFFb7ae8f),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void updateLineSpace(BuildContext context, double value) async {
    context.ref.set(lineSpaceCreator, value);
    var setting = await isar.settings.where().findFirst();
    if (setting != null) {
      setting.lineSpace = value;
      await isar.writeTxn(() async {
        isar.settings.put(setting);
      });
    }
  }

  void updateFontSize(BuildContext context, int step) async {
    final ref = context.ref;
    var fontSize = ref.watch(fontSizeCreator);
    fontSize = (fontSize + step).clamp(12, 48);
    ref.set(fontSizeCreator, fontSize);
    var setting = await isar.settings.where().findFirst();
    if (setting != null) {
      setting.fontSize = fontSize;
      await isar.writeTxn(() async {
        isar.settings.put(setting);
      });
    }
  }

  void updateBackgroundColor(BuildContext context, int colorValue) async {
    final ref = context.ref;
    ref.set(backgroundColorCreator, colorValue);
    var setting = await isar.settings.where().findFirst();
    if (setting != null) {
      setting.backgroundColor = colorValue;
      await isar.writeTxn(() async {
        isar.settings.put(setting);
      });
    }
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
