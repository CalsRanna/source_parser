import 'package:flutter/material.dart';

class SettingCacheDurationBottomSheet extends StatelessWidget {
  const SettingCacheDurationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: _itemBuilder, itemCount: 7);
  }

  String _getText(int hour) {
    return switch (hour) {
      0 => '不缓存',
      24 => '1天',
      _ => '$hour小时',
    };
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final hour = index * 4;
    return ListTile(
      title: Text(_getText(hour), textAlign: TextAlign.center),
      onTap: () => Navigator.of(context).pop(hour),
    );
  }
}
