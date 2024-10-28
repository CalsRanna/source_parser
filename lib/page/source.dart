import 'package:auto_route/auto_route.dart';
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
class AvailableSourceListPage extends StatefulWidget {
  const AvailableSourceListPage({super.key});

  @override
  State<AvailableSourceListPage> createState() {
    return _AvailableSourceListPageState();
  }
}

class _AvailableSourceListPageState extends State<AvailableSourceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   Consumer(builder: (context, ref, child) {
        //     return TextButton(
        //       onPressed: () => reset(ref),
        //       child: const Text('重置'),
        //     );
        //   })
        // ],
        title: const Text('可用书源'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final book = ref.watch(bookNotifierProvider);
        return RefreshIndicator(
          onRefresh: () => handleRefresh(ref),
          child: ListView.builder(
            itemBuilder: (context, index) {
              final active = book.sources[index].id == book.sourceId;
              final primary = Theme.of(context).colorScheme.primary;
              return ListTile(
                subtitle: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('加载失败');
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return const Text('正在加载');
                    }
                  },
                  future: getLatestChapter(ref, book.name, book.sources[index]),
                ),
                title: FutureBuilder(
                  future: getSource(book.sources[index].id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final source = snapshot.data;
                      final name = source?.name ?? '没找到源';
                      final comment = source?.comment ?? '';
                      return Text.rich(
                        TextSpan(
                          text: name,
                          children: [WidgetSpan(child: SourceTag(comment))],
                        ),
                        style: TextStyle(color: active ? primary : null),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                trailing: active ? const Icon(Icons.check) : null,
                onTap: () => switchSource(ref, index),
              );
            },
            itemCount: book.sources.length,
            itemExtent: 72,
          ),
        );
      }),
    );
  }

  void reset(WidgetRef ref) async {
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.resetSources();
  }

  Future<String> getLatestChapter(
      WidgetRef ref, String name, AvailableSource source) async {
    final currentSource = await getSource(source.id);
    if (currentSource != null) {
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
    } else {
      return '加载失败';
    }
  }

  Future<Source?> getSource(int id) async {
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(id).findFirst();
    return source;
  }

  Future<void> handleRefresh(WidgetRef ref) async {
    final message = Message.of(context);
    try {
      final notifier = ref.read(bookNotifierProvider.notifier);
      await notifier.refreshSources();
    } catch (error) {
      message.show(error.toString());
    }
  }

  void switchSource(WidgetRef ref, int index) async {
    showDialog(
      barrierDismissible: false,
      builder: (context) => const _SwitchSourceDialog(),
      context: context,
    );
    final notifier = ref.read(bookNotifierProvider.notifier);
    final message = await notifier.refreshSource(index);
    if (!mounted) return;
    Message.of(context).show(message);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    AutoRouter.of(context).replace(ReaderRoute());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
}

class _SwitchSourceDialog extends StatelessWidget {
  const _SwitchSourceDialog();

  @override
  Widget build(BuildContext context) {
    return const UnconstrainedBox(
      child: SizedBox(
        height: 160,
        width: 160,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingIndicator(),
              SizedBox(height: 16),
              Text('正在切换书源'),
            ],
          ),
        ),
      ),
    );
  }
}
