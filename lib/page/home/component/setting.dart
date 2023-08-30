import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceVariant = colorScheme.surfaceVariant;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: surfaceVariant,
          elevation: 0,
          child: const Column(
            children: [
              SettingTile(
                icon: Icons.library_books_outlined,
                route: '/book-source',
                title: '书源管理',
              ),
            ],
          ),
        ),
        // const SizedBox(height: 8),
        // Card(
        //   color: surfaceVariant,
        //   elevation: 0,
        //   child: Column(
        //     children: [
        //       SettingTile(
        //         icon: Icons.color_lens_outlined,
        //         title: '主题种子',
        //         onTap: () => handleTap(context),
        //       ),
        //       const SettingTile(
        //         icon: Icons.format_color_text_outlined,
        //         route: '/setting/reader-theme',
        //         title: '阅读主题',
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 8),
        Card(
          color: surfaceVariant,
          elevation: 0,
          child: const Column(
            children: [
              SettingTile(
                icon: Icons.error_outline,
                route: '/setting/about',
                title: '关于元夕',
              ),
              // EmitterWatcher<Setting>(
              //   builder: (context, setting) => setting.debugMode
              //       ? const SettingTile(
              //           icon: Icons.developer_mode_outlined,
              //           route: '/setting/developer',
              //           title: '开发者选项',
              //         )
              //       : const SizedBox(),
              //   emitter: settingEmitter,
              // )
            ],
          ),
        ),
      ],
    );
  }

  // void handleTap(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     clipBehavior: Clip.hardEdge,
  //     builder: (context) => EmitterWatcher<Setting>(
  //       builder: (context, setting) => ColorPicker(
  //         pickerColor: Color(setting.colorSeed),
  //         labelTypes: const [],
  //         enableAlpha: false,
  //         colorPickerWidth: MediaQuery.of(context).size.width,
  //         onColorChanged: (value) => handleColorChange(context, value),
  //       ),
  //       emitter: settingEmitter,
  //     ),
  //   );
  // }

  // void handleColorChange(BuildContext context, Color color) async {
  //   final ref = context.ref;
  //   var setting = await ref.read(settingEmitter);
  //   setting.colorSeed = color.value;
  //   ref.emit(settingEmitter, setting.clone);
  // await isar.writeTxn(() async {
  //   isar.settings.put(setting);
  // });
  // }
}

class SettingTile extends StatelessWidget {
  const SettingTile({
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
