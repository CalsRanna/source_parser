import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/source/rule_input.dart';
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
    final defaultTrailing = Icon(HugeIcons.strokeRoundedArrowRight01);
    return ListTile(
      onTap: () => handleTap(context),
      subtitle: _buildSubtitle(),
      title: Text(title),
      trailing: trailing ?? defaultTrailing,
    );
  }

  void handleTap(BuildContext context) async {
    if (onTap != null) return onTap!.call();
    final page = RuleInputPage(
      placeholder: placeholder,
      title: title,
      text: value,
      onChange: onChange,
    );
    final route = MaterialPageRoute(builder: (context) => page);
    Navigator.of(context).push(route);
  }

  Widget? _buildSubtitle() {
    final subtitle = _getSubtitle();
    if (subtitle == null) return null;
    return Text(
      subtitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String? _getSubtitle() {
    final placeholder = this.placeholder?.plain();
    final subtitle = value?.plain();
    if (subtitle == null) return placeholder;
    if (subtitle.isEmpty) return placeholder;
    return subtitle;
  }
}
