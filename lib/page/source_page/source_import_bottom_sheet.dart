import 'package:flutter/material.dart';

class SourceImportBottomSheet extends StatelessWidget {
  final void Function(String)? onConfirm;
  const SourceImportBottomSheet({super.key, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: '导入网络书源'),
            onSubmitted: (value) => onConfirm?.call(value),
          ),
          const SizedBox(height: 8),
          const SelectableText('目前仅支持GitHub仓库中文件的原始地址。'),
        ],
      ),
    );
  }
}
