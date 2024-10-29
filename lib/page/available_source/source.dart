import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/loading.dart';
import 'package:source_parser/widget/source_tag.dart';

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

  Future<String> getLatestChapter(
    WidgetRef ref,
    String name,
    AvailableSource source,
  ) async {
    final currentSource = await getSource(source.id);
    if (currentSource == null) return '加载失败';
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = setting.cacheDuration;
    final timeout = setting.timeout;
    return Parser.getLatestChapter(
      name,
      source.url,
      currentSource,
      Duration(hours: duration.floor()),
      Duration(milliseconds: timeout),
    );
  }

  Future<Source?> getSource(int id) async {
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(id).findFirst();
    return source;
  }

  Future<void> handleRefresh(BuildContext context, WidgetRef ref) async {
    final message = Message.of(context);
    try {
      final notifier = ref.read(bookNotifierProvider.notifier);
      await notifier.refreshSources();
    } catch (error) {
      message.show(error.toString());
    }
  }

  void reset(WidgetRef ref) async {
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.resetSources();
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

  FutureBuilder<String> _buildSubtitle(WidgetRef ref, Book book, int index) {
    return FutureBuilder(
      builder: _subtitleBuilder,
      future: getLatestChapter(ref, book.name, book.sources[index]),
    );
  }

  FutureBuilder<Source?> _buildTitle(
    BuildContext context,
    Book book,
    int index,
  ) {
    final active = book.sources[index].id == book.sourceId;
    return FutureBuilder(
      future: getSource(book.sources[index].id),
      builder: (context, snapshot) => _titleBuilder(context, snapshot, active),
    );
  }

  Widget _itemBuilder(
    BuildContext context,
    WidgetRef ref,
    Book book,
    int index,
  ) {
    final active = book.sources[index].id == book.sourceId;
    return ListTile(
      subtitle: _buildSubtitle(ref, book, index),
      title: _buildTitle(context, book, index),
      trailing: active ? const Icon(Icons.check) : null,
      onTap: () => switchSource(context, ref, index),
    );
  }

  Widget _subtitleBuilder(
      BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.hasError) return const Text('加载失败');
    if (!snapshot.hasData) return const Text('加载中');
    return Text(snapshot.data!, maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  Widget _titleBuilder(
    BuildContext context,
    AsyncSnapshot<Source?> snapshot,
    bool active,
  ) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var primary = colorScheme.primary;
    var name = snapshot.data?.name ?? '没找到源';
    var comment = snapshot.data?.comment ?? '';
    return Text.rich(
      TextSpan(text: name, children: [WidgetSpan(child: SourceTag(comment))]),
      style: TextStyle(color: active ? primary : null),
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
