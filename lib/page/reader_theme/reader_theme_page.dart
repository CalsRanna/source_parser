import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/reader_theme/reader_theme_bottom_sheet.dart';
import 'package:source_parser/page/reader_theme/reader_theme_view_model.dart';
import 'package:source_parser/view_model/app_setting_view_model.dart';
import 'package:source_parser/view_model/app_theme_view_model.dart';
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
  final settingViewModel = GetIt.instance.get<AppSettingViewModel>();
  final themeViewModel = GetIt.instance.get<AppThemeViewModel>();

  @override
  Widget build(BuildContext context) {
    var child = Watch((_) => _buildData());
    return Scaffold(appBar: AppBar(title: const Text('阅读器主题')), body: child);
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignal();
    settingViewModel.initSignals();
    themeViewModel.initSignals();
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

class _ThemeCard extends StatelessWidget {
  final Theme theme;
  final void Function()? onDelete;
  const _ThemeCard({required this.theme, this.onDelete});

  @override
  Widget build(BuildContext context) {
    var currentTheme =
        GetIt.instance.get<AppThemeViewModel>().currentTheme.value;
    var selected = currentTheme.id == theme.id;
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
      onTap: () => handleTap(context),
      child: clipRRect,
    );
  }

  void handleLongPress(BuildContext context) {
    HapticFeedback.heavyImpact();
    DialogUtil.openBottomSheet(
      ReaderThemeBottomSheet(theme: theme, onDelete: onDelete),
    );
  }

  void handleTap(BuildContext context) async {
    final themeViewModel = GetIt.instance.get<AppThemeViewModel>();
    await themeViewModel.selectTheme(theme);
  }
}
