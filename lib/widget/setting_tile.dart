import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
