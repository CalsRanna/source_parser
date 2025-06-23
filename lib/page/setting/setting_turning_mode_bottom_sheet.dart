import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SettingTurningModeBottomSheet extends StatelessWidget {
  final int mode;
  final Function(int) onSelected;
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
        trailing: mode & 1 == 1 ? icon : null,
        onTap: () => onSelected(1),
      ),
      ListTile(
        title: Text('点击翻页'),
        trailing: mode & 2 == 2 ? icon : null,
        onTap: () => onSelected(2),
      ),
    ];
    return ListView(children: children);
  }
}
