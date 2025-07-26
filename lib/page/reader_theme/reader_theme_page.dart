import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/reader_theme/reader_theme_bottom_sheet.dart';
import 'package:source_parser/page/reader_theme/reader_theme_view_model.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/string_extension.dart';

@RoutePage()
class ReaderThemePage extends StatefulWidget {
  const ReaderThemePage({super.key});

  @override
  State<ReaderThemePage> createState() => _ReaderThemePageState();
}

class _ReaderThemePageState extends State<ReaderThemePage> {
  final viewModel = GetIt.instance.get<ReaderThemeViewModel>();

  @override
  Widget build(BuildContext context) {
    var child = Watch((_) => _buildData());
    return Scaffold(appBar: AppBar(title: const Text('阅读器主题')), body: child);
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignal();
  }

  Widget _buildData() {
    var delegate = SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);
    return GridView.builder(
      gridDelegate: delegate,
      itemBuilder: (_, index) => _ThemeCard(
          theme: viewModel.themes.value[index],
          onDelete: () =>
              viewModel.destroyTheme(viewModel.themes.value[index])),
      itemCount: viewModel.themes.value.length,
      padding: EdgeInsets.all(16),
    );
  }
}

class _ThemeCard extends ConsumerWidget {
  final Theme theme;
  final void Function()? onDelete;
  const _ThemeCard({required this.theme, this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var setting = ref.watch(settingNotifierProvider).valueOrNull;
    setting ??= Setting();
    var selected = setting.themeId == theme.id;
    var color = theme.contentColor.toColor();
    var icon = Icon(HugeIcons.strokeRoundedTick01, color: color);
    var style = TextStyle(color: color);
    var children = [
      Container(color: theme.backgroundColor.toColor()),
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
    DialogUtil.openBottomSheet(
      ReaderThemeBottomSheet(theme: theme, onDelete: onDelete),
    );
  }

  void handleTap(BuildContext context, WidgetRef ref) {
    var provider = settingNotifierProvider;
    var notifier = ref.read(provider.notifier);
    notifier.selectTheme(theme);
  }
}
