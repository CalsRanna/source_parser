import 'package:flutter/material.dart';

class SettingTimeoutBottomSheet extends StatelessWidget {
  const SettingTimeoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: _itemBuilder, itemCount: 4);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final timeout = (index + 1) * 15;
    return ListTile(
      title: Text('$timeout秒', textAlign: TextAlign.center),
      onTap: () => Navigator.of(context).pop(timeout),
    );
  }
}
