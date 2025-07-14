import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileDarkModeSwitch extends StatelessWidget {
  final bool darkMode;
  final void Function()? onModeChanged;

  const ProfileDarkModeSwitch({
    super.key,
    required this.darkMode,
    this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    var icon = HugeIcons.strokeRoundedMoon02;
    if (darkMode) icon = HugeIcons.strokeRoundedSun03;
    return IconButton(
      icon: Icon(icon),
      onPressed: onModeChanged,
    );
  }
}
