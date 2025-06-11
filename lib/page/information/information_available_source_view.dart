import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/source_entity.dart';

class InformationAvailableSourceView extends StatelessWidget {
  final List<AvailableSourceEntity> availableSources;
  final SourceEntity source;
  final void Function()? onTap;

  const InformationAvailableSourceView({
    super.key,
    required this.availableSources,
    required this.source,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    var name = '';
    if (source.name.isNotEmpty) {
      name = '${source.name} · ';
    }
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var surfaceTint = colorScheme.surfaceTint;
    var text = Text(
      '$name可用${availableSources.length}个',
      textAlign: TextAlign.right,
    );
    var children = [
      const Text('书源', style: boldTextStyle),
      Expanded(child: text),
      const Icon(HugeIcons.strokeRoundedArrowRight01)
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Row(children: children)],
    );
    var card = Card(
      color: surfaceTint.withValues(alpha: 0.05),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: Padding(padding: const EdgeInsets.all(16.0), child: column),
    );
    return GestureDetector(onTap: onTap, child: card);
  }
}
