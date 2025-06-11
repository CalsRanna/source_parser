import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/reader/reader_cache_sheet_view.dart';

class ReaderOverlayCacheSlot extends StatelessWidget {
  final void Function(int)? onTap;

  const ReaderOverlayCacheSlot({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showCacheSheet(context),
      icon: Icon(HugeIcons.strokeRoundedDownload04),
    );
  }

  void _showCacheSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReaderCacheSheet(onCached: onTap),
      showDragHandle: true,
    );
  }
}
