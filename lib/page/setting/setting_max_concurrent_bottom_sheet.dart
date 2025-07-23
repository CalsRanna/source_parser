import 'package:flutter/material.dart';

class SettingMaxConcurrentBottomSheet extends StatelessWidget {
  const SettingMaxConcurrentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: _itemBuilder, itemCount: 8);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final concurrent = (index + 1) * 4;
    return ListTile(
      title: Text('$concurrent线程', textAlign: TextAlign.center),
      onTap: () => Navigator.of(context).pop(concurrent),
    );
  }
}
