import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileSettingListTile extends StatelessWidget {
  final IconData? icon;
  final void Function()? onTap;
  final String title;

  const ProfileSettingListTile({
    super.key,
    this.icon,
    this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final leading = icon != null ? Icon(icon, color: primary) : null;
    final trailing = Icon(HugeIcons.strokeRoundedArrowRight01);
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
