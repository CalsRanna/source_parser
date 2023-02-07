import 'package:flutter/material.dart';
import 'package:source_parser/util/plain_string.dart';
import 'package:source_parser/widget/rule_input.dart';

class RuleTile extends StatelessWidget {
  const RuleTile({
    Key? key,
    this.bordered,
    required this.title,
    this.trailing,
    this.value,
    this.onTap,
    this.onChange,
  }) : super(key: key);

  final bool? bordered;
  final String title;
  final Widget? trailing;
  final String? value;
  final void Function()? onTap;
  final void Function(dynamic)? onChange;

  @override
  Widget build(BuildContext context) {
    var icon = Icon(
      Icons.arrow_forward_ios_outlined,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      size: 16,
    );

    return ListTile(
      title: Text(title),
      trailing: trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text(value?.plain() ?? ''), icon],
          ),
      onTap: () => handleTap(context),
    );
  }

  void handleTap(BuildContext context) async {
    if (onTap != null) {
      onTap?.call();
    } else {
      var newValue = await Navigator.of(context).push(MaterialPageRoute(
        builder: (conext) => RuleInput(title: title, text: value),
      ));
      onChange?.call(newValue);
    }
  }
}
