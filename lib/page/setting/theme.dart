import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:source_parser/state/global.dart';

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('颜色主题')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const _ThemeChanger(),
          ListTile(
            title: const Text('夜间模式'),
            trailing: CreatorWatcher<bool>(
              builder: (context, darkMode) => Switch(
                value: darkMode,
                onChanged: (value) => handleChange(context, value),
              ),
              creator: darkModeCreator,
            ),
          ),
          const SizedBox(height: 8),
          const _ColorSchemeCard(),
        ],
      ),
    );
  }

  void handleChange(BuildContext context, bool value) {
    context.ref.set(darkModeCreator, value);
  }
}

class _ThemeChanger extends StatelessWidget {
  const _ThemeChanger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
          content: Watcher(
            (context, ref, _) => SingleChildScrollView(
              child: ColorPicker(
                enableAlpha: false,
                labelTypes: const [],
                pickerColor: ref.watch(colorCreator),
                onColorChanged: (color) => handleTap(ref, color),
              ),
            ),
          ),
          // title: const Text('选择颜色'),
        ),
      ),
      child: Watcher((context, ref, _) {
        var color = ref.watch(colorCreator);
        var textColor = Colors.black;
        if (color.computeLuminance() < 0.5) {
          textColor = Colors.white;
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          margin: Theme.of(context).cardTheme.margin ?? const EdgeInsets.all(4),
          padding: const EdgeInsets.all(16),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: textColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('当前主题：（点击切换）'),
                Text(
                  '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  void handleTap(Ref ref, Color color) {
    ref.set(colorCreator, color);
    Hive.box('setting').put('theme', color.value);
  }
}

class _ColorSchemeTile extends StatelessWidget {
  const _ColorSchemeTile({Key? key, required this.color, required this.title})
      : super(key: key);

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    var textColor = Colors.black;
    if (color.computeLuminance() < 0.5) {
      textColor = Colors.white;
    }
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: textColor),
        child: Row(
          children: [
            Text(title),
            const Expanded(child: SizedBox()),
            Text(
              '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
            )
          ],
        ),
      ),
    );
  }
}

class _ColorSchemeCard extends StatelessWidget {
  const _ColorSchemeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _ColorSchemeTile(color: scheme.primary, title: 'primary'),
              _ColorSchemeTile(color: scheme.onPrimary, title: 'onPrimary'),
              _ColorSchemeTile(
                color: scheme.primaryContainer,
                title: 'primaryContainer',
              ),
              _ColorSchemeTile(
                color: scheme.onPrimaryContainer,
                title: 'onPrimaryContainer',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _ColorSchemeTile(color: scheme.secondary, title: 'secondary'),
              _ColorSchemeTile(
                color: scheme.onSecondary,
                title: 'onSecondary',
              ),
              _ColorSchemeTile(
                color: scheme.secondaryContainer,
                title: 'secondaryContainer',
              ),
              _ColorSchemeTile(
                color: scheme.onSecondaryContainer,
                title: 'onSecondaryContainer',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _ColorSchemeTile(color: scheme.tertiary, title: 'tertiary'),
              _ColorSchemeTile(color: scheme.onTertiary, title: 'onTertiary'),
              _ColorSchemeTile(
                color: scheme.tertiaryContainer,
                title: 'tertiaryContainer',
              ),
              _ColorSchemeTile(
                color: scheme.onTertiaryContainer,
                title: 'onTertiaryContainer',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _ColorSchemeTile(color: scheme.error, title: 'error'),
              _ColorSchemeTile(color: scheme.onError, title: 'onError'),
              _ColorSchemeTile(
                color: scheme.errorContainer,
                title: 'errorContainer',
              ),
              _ColorSchemeTile(
                color: scheme.onErrorContainer,
                title: 'onErrorContainer',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _ColorSchemeTile(color: scheme.background, title: 'background'),
              _ColorSchemeTile(
                color: scheme.onBackground,
                title: 'onBackground',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _ColorSchemeTile(color: scheme.surface, title: 'surface'),
              _ColorSchemeTile(color: scheme.onSurface, title: 'onSurface'),
              _ColorSchemeTile(
                color: scheme.surfaceVariant,
                title: 'surfaceVariant',
              ),
              _ColorSchemeTile(
                color: scheme.onSurfaceVariant,
                title: 'onSurfaceVariant',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _ColorSchemeTile(color: scheme.outline, title: 'outline'),
              _ColorSchemeTile(color: scheme.shadow, title: 'shadow'),
              _ColorSchemeTile(
                color: scheme.inverseSurface,
                title: 'inverseSurface',
              ),
              _ColorSchemeTile(
                color: scheme.onInverseSurface,
                title: 'onInverseSurface',
              ),
              _ColorSchemeTile(
                color: scheme.inversePrimary,
                title: 'inversePrimary',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
