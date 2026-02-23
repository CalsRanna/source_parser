import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/component/reader/reader_turning_mode.dart';

class SettingTurningModeBottomSheet extends StatelessWidget {
  final PageTurnMode mode;
  final Function(PageTurnMode) onSelected;
  const SettingTurningModeBottomSheet({
    super.key,
    required this.mode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    var icon = Icon(HugeIcons.strokeRoundedTick02);
    final children = [
      ListTile(
        title: Text('滑动翻页'),
        trailing: mode == PageTurnMode.slide ? icon : null,
        onTap: () => onSelected(PageTurnMode.slide),
      ),
      ListTile(
        title: Text('覆盖翻页'),
        trailing: mode == PageTurnMode.cover ? icon : null,
        onTap: () => onSelected(PageTurnMode.cover),
      ),
      ListTile(
        title: Text('仿真翻页'),
        trailing: mode == PageTurnMode.curl ? icon : null,
        onTap: () => onSelected(PageTurnMode.curl),
      ),
      ListTile(
        title: Text('无动画'),
        trailing: mode == PageTurnMode.none ? icon : null,
        onTap: () => onSelected(PageTurnMode.none),
      ),
    ];
    return ListView(children: children);
  }
}
