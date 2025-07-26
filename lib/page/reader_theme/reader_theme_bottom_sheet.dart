import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/theme.dart' as schema;
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/string_extension.dart';

class ReaderThemeBottomSheet extends StatelessWidget {
  final schema.Theme theme;
  final void Function()? onDelete;
  const ReaderThemeBottomSheet({super.key, required this.theme, this.onDelete});

  @override
  Widget build(BuildContext context) {
    var editListTile = ListTile(
      title: const Text(StringConfig.edit),
      leading: const Icon(HugeIcons.strokeRoundedEdit02),
      onTap: () => navigateReaderThemeEditorPage(context),
    );
    var destroyListTile = ListTile(
      title: const Text(StringConfig.destroy),
      leading: const Icon(HugeIcons.strokeRoundedDelete02),
      onTap: () => openDestroyDialog(context),
    );
    var children = [editListTile, destroyListTile];
    return SafeArea(
      top: false,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  void navigateReaderThemeEditorPage(BuildContext context) {
    DialogUtil.dismiss();
    ReaderThemeEditorRoute(theme: theme).push(context);
  }

  void openDestroyDialog(BuildContext context) {
    DialogUtil.dismiss();
    DialogUtil.openDialog(_DestroyDialog(theme: theme, onDelete: onDelete));
  }
}

class _DestroyDialog extends StatelessWidget {
  final schema.Theme theme;
  final void Function()? onDelete;
  const _DestroyDialog({required this.theme, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    var actions = [
      TextButton(
        onPressed: () => cancelDelete(context),
        child: const Text(StringConfig.cancel),
      ),
      TextButton(
        onPressed: () => confirmDelete(context),
        child: const Text(StringConfig.destroy),
      )
    ];
    return AlertDialog(
      title: Text(StringConfig.destroyTheme),
      content: Text(StringConfig.confirmDeleteTheme.format([theme.name])),
      actions: actions,
    );
  }

  void cancelDelete(BuildContext context) {
    DialogUtil.dismiss();
  }

  Future<void> confirmDelete(BuildContext context) async {
    DialogUtil.dismiss();
    onDelete?.call();
  }
}
