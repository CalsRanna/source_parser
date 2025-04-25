import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/available_source/available_source_view_model.dart';
import 'package:source_parser/page/available_source/component/option_bottom_sheet.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/loading.dart';

@RoutePage()
class AvailableSourcePage extends StatefulWidget {
  final BookEntity book;
  const AvailableSourcePage({super.key, required this.book});

  @override
  State<AvailableSourcePage> createState() => _AvailableSourcePageState();
}

class _AvailableSourcePageState extends State<AvailableSourcePage> {
  late final viewModel = GetIt.instance<AvailableSourceViewModel>(
    param1: widget.book,
  );

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

  @override
  Widget build(BuildContext context) {
    var button = IconButton(
      onPressed: () => viewModel.navigateAvailableSourceFormPage(context),
      icon: Icon(HugeIcons.strokeRoundedAdd01),
    );
    return Scaffold(
      appBar: AppBar(actions: [button], title: const Text('可用书源')),
      body: Watch(_buildBody),
    );
  }

  Widget _buildBody(BuildContext context) {
    var listView = ListView.builder(
      itemBuilder: (_, index) => _itemBuilder(index),
      itemCount: viewModel.availableSources.value.length,
      itemExtent: 72,
    );
    return EasyRefresh(
      onRefresh: viewModel.refreshAvailableSources,
      child: listView,
    );
  }

  void openBottomSheet() {
    DialogUtil.openBottomSheet(AvailableSourceOptionBottomSheet());
  }

  void switchSource(BuildContext context, WidgetRef ref, int index) async {
    showDialog(
      barrierDismissible: false,
      builder: (context) => const _SwitchSourceDialog(),
      context: context,
    );
    final notifier = ref.read(bookNotifierProvider.notifier);
    final message = await notifier.refreshSource(index);
    if (!context.mounted) return;
    Message.of(context).show(message);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    var book = ref.read(bookNotifierProvider);
    AutoRouter.of(context).replace(ReaderRoute(book: book));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  Widget _buildSubtitle(int index) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var primary = colorScheme.primary;
    var latestChapter = viewModel.availableSources.value[index].latestChapter;
    if (latestChapter.isEmpty) latestChapter = '未知最新章节';
    final active =
        viewModel.availableSources.value[index].id == widget.book.sourceId;
    return Text(
      latestChapter,
      style: TextStyle(color: active ? primary : null),
    );
  }

  Widget _buildTitle(int index) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var primary = colorScheme.primary;
    var name = viewModel.availableSources.value[index].name;
    if (name.isEmpty) name = '未知书源';
    final active =
        viewModel.availableSources.value[index].id == widget.book.sourceId;
    return Text(name, style: TextStyle(color: active ? primary : null));
  }

  Widget _itemBuilder(int index) {
    final active = viewModel.availableSources.value[index].id ==
        widget.book.availableSourceId;
    return ListTile(
      onLongPress: openBottomSheet,
      // onTap: () => switchSource(context, index),
      subtitle: _buildSubtitle(index),
      title: _buildTitle(index),
      trailing: active ? const Icon(HugeIcons.strokeRoundedTick02) : null,
    );
  }
}

// class _AddSourceDialog extends StatelessWidget {
//   const _AddSourceDialog();

//   @override
//   Widget build(BuildContext context) {
//     const children = [
//       LoadingIndicator(),
//       SizedBox(height: 16),
//       Text('正在添加书源'),
//     ];
//     const column = Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: children,
//     );
//     const dialog = Dialog(
//       insetPadding: EdgeInsets.zero,
//       child: column,
//     );
//     return const UnconstrainedBox(
//       child: SizedBox(height: 160, width: 160, child: dialog),
//     );
//   }
// }

class _SwitchSourceDialog extends StatelessWidget {
  const _SwitchSourceDialog();

  @override
  Widget build(BuildContext context) {
    const children = [
      LoadingIndicator(),
      SizedBox(height: 16),
      Text('正在切换书源'),
    ];
    const column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
    const dialog = Dialog(
      insetPadding: EdgeInsets.zero,
      child: column,
    );
    return const UnconstrainedBox(
      child: SizedBox(height: 160, width: 160, child: dialog),
    );
  }
}
