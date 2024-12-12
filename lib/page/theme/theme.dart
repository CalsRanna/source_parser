import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/provider/theme.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/message.dart';

@RoutePage()
class ReaderThemePage extends ConsumerWidget {
  const ReaderThemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = themesNotifierProvider;
    var state = ref.watch(provider);
    var child = switch (state) {
      AsyncData(:final value) => _buildData(value),
      _ => const SizedBox(),
    };
    return Scaffold(appBar: AppBar(title: const Text('主题')), body: child);
  }

  Widget _buildData(List<Theme> themes) {
    var delegate = SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);
    return GridView.builder(
      gridDelegate: delegate,
      itemBuilder: (_, index) => _ThemeCard(theme: themes[index]),
      itemCount: themes.length,
      padding: EdgeInsets.all(16),
    );
  }
}

class _Dialog extends ConsumerWidget {
  final Theme theme;
  const _Dialog({required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var actions = [
      TextButton(
        onPressed: () => cancelDelete(context),
        child: const Text('取消'),
      ),
      TextButton(
        onPressed: () => confirmDelete(context, ref),
        child: const Text('删除'),
      )
    ];
    return AlertDialog(
      title: Text('删除主题'),
      content: Text('确定要删除${theme.name}吗?'),
      actions: actions,
    );
  }

  void cancelDelete(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> confirmDelete(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();
    try {
      await ref.read(themesNotifierProvider.notifier).delete(theme);
    } catch (error) {
      if (!context.mounted) return;
      Message.of(context).show(error.toString());
    }
  }
}

class _ThemeCard extends ConsumerWidget {
  final Theme theme;
  const _ThemeCard({required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var setting = ref.watch(settingNotifierProvider).valueOrNull;
    setting ??= Setting();
    var selected = setting.themeId == theme.id;
    var color = Color(theme.contentColor);
    var icon = Icon(HugeIcons.strokeRoundedTick01, color: color);
    var style = TextStyle(color: color);
    var children = [
      Container(color: Color(theme.backgroundColor)),
      if (theme.backgroundImage.isNotEmpty) Image.asset(theme.backgroundImage),
      Center(child: Text(theme.name, style: style)),
      if (selected) Positioned(bottom: 16, right: 16, child: icon)
    ];
    var clipRRect = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(children: children),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => handleLongPress(context),
      onTap: () => handleTap(context, ref),
      child: clipRRect,
    );
  }

  void handleLongPress(BuildContext context) {
    HapticFeedback.heavyImpact();
    showDialog(context: context, builder: (_) => _Dialog(theme: theme));
  }

  void handleTap(BuildContext context, WidgetRef ref) {
    var provider = settingNotifierProvider;
    var notifier = ref.read(provider.notifier);
    notifier.selectTheme(theme);
    AutoRouter.of(context).push(ThemeEditorRoute());
  }
}
