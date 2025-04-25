import 'package:flutter/material.dart';

class InformationArchiveView extends StatelessWidget {
  final bool isArchive;
  final void Function()? onTap;
  const InformationArchiveView({
    super.key,
    required this.isArchive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var surfaceTint = colorScheme.surfaceTint;
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    var switchWidget = Switch(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: isArchive,
      onChanged: (value) {},
    );
    var children = [
      const Text('归档', style: boldTextStyle),
      const Spacer(),
      switchWidget
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Row(children: children)],
    );
    var padding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: column,
    );
    var card = Card(
      color: surfaceTint.withValues(alpha: 0.05),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: padding,
    );
    return GestureDetector(onTap: onTap, child: card);
  }
}
