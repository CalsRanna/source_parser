import 'package:flutter/material.dart';
import 'package:source_parser/util/string_extension.dart';
import 'package:source_parser/widget/rule_input.dart';

class RuleTile extends StatelessWidget {
  const RuleTile({
    Key? key,
    this.bordered,
    this.placeholder,
    required this.title,
    this.trailing,
    this.value,
    this.onTap,
    this.onChange,
  }) : super(key: key);

  final bool? bordered;
  final String? placeholder;
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

    return GestureDetector(
      onTap: () => handleTap(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(title),
            const SizedBox(width: 8),
            if (trailing != null)
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: trailing!,
                ),
              ),
            if (trailing == null) ...[
              Expanded(
                child: Text(
                  value?.plain() ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 8),
              icon
            ]
          ],
        ),
      ),
    );
  }

  void handleTap(BuildContext context) async {
    if (onTap != null) {
      onTap?.call();
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RuleInput(
          placeholder: placeholder,
          title: title,
          text: value,
          onChange: onChange,
        ),
      ));
    }
  }
}
