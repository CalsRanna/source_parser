import 'package:flutter/material.dart';

class SettingClearCacheDialog extends StatelessWidget {
  const SettingClearCacheDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cancelButton = TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('取消'),
    );
    final confirmButton = TextButton(
      onPressed: () => Navigator.of(context).pop(true),
      child: const Text('确认'),
    );
    return AlertDialog(
      actions: [cancelButton, confirmButton],
      content: const Text('确定清空所有已缓存的内容？'),
      title: const Text('清空缓存'),
    );
  }
}
