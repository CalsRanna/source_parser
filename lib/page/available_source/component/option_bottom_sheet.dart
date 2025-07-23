import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/util/dialog_util.dart';

class AvailableSourceOptionBottomSheet extends StatelessWidget {
  const AvailableSourceOptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    var switchListTile = ListTile(
      title: const Text('切换'),
      leading: const Icon(HugeIcons.strokeRoundedEdit02),
      onTap: switchAvailableSource,
    );
    var editListTile = ListTile(
      title: const Text('编辑'),
      leading: const Icon(HugeIcons.strokeRoundedEdit02),
      onTap: () {},
    );
    var destroyListTile = ListTile(
      title: const Text('删除'),
      leading: const Icon(HugeIcons.strokeRoundedDelete02),
      onTap: openDestroyDialog,
    );
    var children = [switchListTile, editListTile, destroyListTile];
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  Future<void> switchAvailableSource() async {
    DialogUtil.loading();
    await Future.delayed(const Duration(seconds: 1));

    // final notifier = ref.read(bookNotifierProvider.notifier);
    // final message = await notifier.refreshSource(index);
    // if (!context.mounted) return;
    // DialogUtil.snackBar(message);
    // Navigator.of(context).pop();
    // Navigator.of(context).pop();
    // var book = ref.read(bookNotifierProvider);
    // AutoRouter.of(context).replace(ReaderRoute(book: book));
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    DialogUtil.dismiss();
  }

  Future<void> openDestroyDialog() async {
    var result = await DialogUtil.confirm('确定删除这个可用书源吗？');
    if (result == null || !result) return;
  }
}
