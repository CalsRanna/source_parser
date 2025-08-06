import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/model/replacement_entity.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/dialog_util.dart';

class ReaderReplacementBottomSheet extends StatelessWidget {
  final ReplacementEntity replacement;
  final void Function()? onDelete;
  const ReaderReplacementBottomSheet(
      {super.key, required this.replacement, this.onDelete});

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
    ReaderReplacementFormRoute().push(context);
  }

  void openDestroyDialog(BuildContext context) {
    DialogUtil.dismiss();
    DialogUtil.openDialog(
        _DestroyDialog(replacement: replacement, onDelete: onDelete));
  }
}

class _DestroyDialog extends StatelessWidget {
  final ReplacementEntity replacement;
  final void Function()? onDelete;
  const _DestroyDialog({required this.replacement, required this.onDelete});

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
      content: Text(StringConfig.confirmDeleteReplacement),
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
