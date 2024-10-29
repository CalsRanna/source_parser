import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/loading.dart';

@RoutePage()
class AvailableSourceListPage extends ConsumerWidget {
  const AvailableSourceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var book = ref.watch(bookNotifierProvider);
    var listView = ListView.builder(
      itemBuilder: (context, index) => _itemBuilder(context, ref, book, index),
      itemCount: book.sources.length,
      itemExtent: 72,
    );
    var body = EasyRefresh(
      onRefresh: () => handleRefresh(context, ref),
      child: listView,
    );
    return Scaffold(appBar: AppBar(title: const Text('可用书源')), body: body);
  }

  Future<void> handleRefresh(BuildContext context, WidgetRef ref) async {
    try {
      var provider = bookNotifierProvider;
      final notifier = ref.read(provider.notifier);
      await notifier.refreshSources();
    } catch (error) {
      if (!context.mounted) return;
      final message = Message.of(context);
      message.show(error.toString());
    }
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
    AutoRouter.of(context).replace(ReaderRoute());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  Widget _buildSubtitle(BuildContext context, Book book, int index) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var primary = colorScheme.primary;
    var latestChapter = book.sources[index].latestChapter;
    if (latestChapter.isEmpty) latestChapter = '未知最新章节';
    final active = book.sources[index].id == book.sourceId;
    return Text(
      latestChapter,
      style: TextStyle(color: active ? primary : null),
    );
  }

  Widget _buildTitle(BuildContext context, Book book, int index) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var primary = colorScheme.primary;
    var name = book.sources[index].name;
    if (name.isEmpty) name = '未知书源';
    final active = book.sources[index].id == book.sourceId;
    return Text(name, style: TextStyle(color: active ? primary : null));
  }

  Widget _itemBuilder(
    BuildContext context,
    WidgetRef ref,
    Book book,
    int index,
  ) {
    final active = book.sources[index].id == book.sourceId;
    return ListTile(
      subtitle: _buildSubtitle(context, book, index),
      title: _buildTitle(context, book, index),
      trailing: active ? const Icon(Icons.check) : null,
      onTap: () => switchSource(context, ref, index),
    );
  }
}

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
