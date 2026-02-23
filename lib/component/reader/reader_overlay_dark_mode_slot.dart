import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ReaderOverlayDarkModeSlot extends StatelessWidget {
  final bool isDarkMode;
  final void Function()? onTap;

  const ReaderOverlayDarkModeSlot({
    super.key,
    required this.isDarkMode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var icon = isDarkMode
        ? HugeIcons.strokeRoundedSun03
        : HugeIcons.strokeRoundedMoon02;
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
    );
  }
}
