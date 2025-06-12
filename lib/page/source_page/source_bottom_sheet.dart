import 'package:flutter/material.dart';

class SourceBottomSheet extends StatelessWidget {
  final void Function()? onImportNetworkSource;
  final void Function()? onImportLocalSource;
  final void Function()? onExportSource;
  final void Function()? onValidateSources;
  const SourceBottomSheet({
    super.key,
    this.onImportNetworkSource,
    this.onImportLocalSource,
    this.onExportSource,
    this.onValidateSources,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
    return ListView(children: [
      ListTile(
        title: const Text('网络导入'),
        onTap: onImportNetworkSource,
      ),
      ListTile(
        title: const Text('本地导入'),
        onTap: onImportLocalSource,
      ),
      ListTile(
        title: const Text('导出所有书源'),
        onTap: onExportSource,
      ),
      Divider(
        color: surfaceContainerHighest.withValues(alpha: 0.25),
        height: 1,
      ),
      ListTile(
        title: const Text('校验书源'),
        onTap: onValidateSources,
      ),
      Divider(
        color: surfaceContainerHighest.withValues(alpha: 0.25),
        height: 1,
      ),
    ]);
  }
}
