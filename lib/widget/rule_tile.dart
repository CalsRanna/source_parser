import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/string_extension.dart';

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
    final defaultTrailing = Icon(HugeIcons.strokeRoundedArrowRight01, size: 14);
    final text = Text(
      value?.plain() ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final children = [Flexible(child: text), trailing ?? defaultTrailing];
    final row = Row(mainAxisSize: MainAxisSize.min, children: children);
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final boxConstraints = BoxConstraints(maxWidth: size.width / 3 * 2);
    return ListTile(
      onTap: () => handleTap(context),
      title: Text(title),
      trailing: ConstrainedBox(constraints: boxConstraints, child: row),
    );
  }

  void handleTap(BuildContext context) async {
    if (onTap != null) return onTap!.call();
    RuleInputRoute(
      title: title,
      text: value,
      placeholder: placeholder,
      onChange: onChange,
    ).push(context);
  }
}
