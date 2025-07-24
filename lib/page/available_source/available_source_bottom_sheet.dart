import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/util/dialog_util.dart';

class AvailableSourceBottomSheet extends StatelessWidget {
  final void Function()? onDestroy;
  const AvailableSourceBottomSheet({super.key, this.onDestroy});

  @override
  Widget build(BuildContext context) {
    var switchListTile = ListTile(
      title: const Text(StringConfig.change),
      leading: const Icon(HugeIcons.strokeRoundedEdit02),
      onTap: () {},
    );
    var editListTile = ListTile(
      title: const Text(StringConfig.edit),
      leading: const Icon(HugeIcons.strokeRoundedEdit02),
      onTap: () {},
    );
    var destroyListTile = ListTile(
      title: const Text(StringConfig.destroy),
      leading: const Icon(HugeIcons.strokeRoundedDelete02),
      onTap: openDestroyDialog,
    );
    var children = [switchListTile, editListTile, destroyListTile];
    return SafeArea(
      top: false,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  Future<void> openDestroyDialog() async {
    DialogUtil.dismiss();
    var result = await DialogUtil.confirm(StringConfig.destroyAvailableSource);
    if (result == null || !result) return;
    onDestroy?.call();
  }
}
