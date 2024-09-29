import 'package:flutter/material.dart';
import 'package:source_parser/util/string_extension.dart';
import 'package:source_parser/widget/rule_input.dart';

class RuleTile extends StatelessWidget {
  final bool? bordered;
  final void Function(dynamic)? onChange;
  final void Function()? onTap;
  final String? placeholder;
  final String title;
  final Widget? trailing;
  final String? value;

  const RuleTile({
    super.key,
    this.bordered,
    this.onChange,
    this.onTap,
    this.placeholder,
    required this.title,
    this.trailing,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final defaultTrailing = Icon(
      Icons.arrow_forward_ios_outlined,
      color: onSurfaceVariant,
      size: 16,
    );
    final text = Text(
      value?.plain() ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.end,
    );
    final children = [
      Text(title),
      const SizedBox(width: 8),
      Expanded(child: text),
    ];
    return ListTile(
      onTap: () => handleTap(context),
      title: Row(children: children),
      trailing: trailing ?? defaultTrailing,
    );
  }

  void handleTap(BuildContext context) async {
    if (onTap != null) return onTap!.call();
    final page = RuleInput(
      placeholder: placeholder,
      title: title,
      text: value,
      onChange: onChange,
    );
    final route = MaterialPageRoute(builder: (context) => page);
    Navigator.of(context).push(route);
  }
}
