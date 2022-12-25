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
    Decoration? decoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
    );
    if (bordered != null && bordered == false) {
      decoration = null;
    }

    var expanded = Expanded(
      child: Text(
        value?.plain() ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
      ),
    );

    var icon = Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey[300]);

    return IconTheme.merge(
      data: const IconThemeData(size: 14),
      child: InkWell(
        onTap: () => handleTap(context),
        child: Container(
          decoration: decoration,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [if (value != null) expanded, trailing ?? icon],
                ),
              ),
            ],
          ),
        ),
      ),
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
