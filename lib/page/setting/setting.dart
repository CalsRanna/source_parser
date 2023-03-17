import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/model/setting.dart';
import 'package:source_parser/state/global.dart';
import 'package:source_parser/widget/bottom_bar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          EmitterWatcher<Setting>(
            builder: (context, setting) => IconButton(
              icon: Icon(setting.darkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined),
              onPressed: () => triggerDarkMode(context),
            ),
            emitter: settingEmitter,
          ),
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
        centerTitle: true,
        title: const Text('我的'),
      ),
      // backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
            child: Column(
              children: const [
                _SettingTile(
                  icon: Icons.library_books_outlined,
                  route: '/book-source',
                  title: '书源管理',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
            child: Column(
              children: [
                _SettingTile(
                  icon: Icons.color_lens_outlined,
                  title: '主题种子',
                  onTap: () => handleTap(context),
                ),
                const _SettingTile(
                  icon: Icons.format_color_text_outlined,
                  route: '/setting/reader-theme',
                  title: '阅读主题',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
            child: Column(
              children: [
                const _SettingTile(
                  icon: Icons.error_outline,
                  route: '/setting/about',
                  title: '关于元夕',
                ),
                CreatorWatcher<bool>(
                  builder: (context, debugMode) => debugMode
                      ? const _SettingTile(
                          icon: Icons.developer_mode_outlined,
                          route: '/setting/developer',
                          title: '开发者选项',
                        )
                      : const SizedBox(),
                  creator: debugModeCreator,
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  void triggerDarkMode(BuildContext context) async {
    final ref = context.ref;
    final isar = await ref.read(isarEmitter);
    await isar.writeTxn(() async {
      var setting = await isar.settings.where().findFirst() ?? Setting();
      setting.darkMode = !setting.darkMode;
      isar.settings.put(setting);
      ref.emit(settingEmitter, setting);
    });
  }

  void handleTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (context) => EmitterWatcher<Setting>(
        builder: (context, setting) => ColorPicker(
          pickerColor: Color(setting.colorSeed),
          labelTypes: const [],
          enableAlpha: false,
          colorPickerWidth: MediaQuery.of(context).size.width,
          onColorChanged: (value) => handleColorChange(context, value),
        ),
        emitter: settingEmitter,
      ),
    );
  }

  void handleColorChange(BuildContext context, Color color) async {
    final ref = context.ref;
    var setting = await ref.read(settingEmitter);
    setting.colorSeed = color.value;
    ref.emit(settingEmitter, setting);
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    Key? key,
    this.icon,
    this.route,
    required this.title,
    this.onTap,
  }) : super(key: key);

  final IconData? icon;
  final String? route;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var leading = icon != null
        ? Icon(icon, color: Theme.of(context).colorScheme.primary)
        : null;

    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 16,
      ),
      onTap: () => handleTap(context),
    );
  }

  void handleTap(BuildContext context) {
    if (route != null) {
      context.push(route!);
    } else {
      onTap?.call();
    }
  }
}
