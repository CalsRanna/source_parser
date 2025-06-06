import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/loading.dart';

@RoutePage()
class SourceListPage extends StatefulWidget {
  const SourceListPage({super.key});

  @override
  State<SourceListPage> createState() => _SourceListPageState();
}

class _SourceListPageState extends State<SourceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: importSource,
            icon: const Icon(HugeIcons.strokeRoundedMoreVertical),
          )
        ],
        title: const Text('书源管理'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final provider = ref.watch(sourcesProvider);
          List<Source> sources = switch (provider) {
            AsyncData(:final value) => value,
            _ => [],
          };
          if (sources.isEmpty) return const Center(child: Text('空空如也'));
          return ListView.builder(
            itemCount: sources.length,
            itemBuilder: (context, index) {
              return _SourceTile(
                key: ValueKey('source-$index'),
                source: sources[index],
                onTap: (id) => editSource(ref, id),
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer(builder: (context, ref, child) {
        return FloatingActionButton(
          onPressed: () => createSource(ref),
          child: const Icon(HugeIcons.strokeRoundedAdd01),
        );
      }),
    );
  }

  void confirm(
    WidgetRef ref,
    List<Source> newSources,
    List<Source> oldSources, {
    bool override = false,
  }) async {
    final router = Navigator.of(context);
    final notifier = ref.read(sourcesProvider.notifier);
    await notifier.confirmImport(newSources, oldSources, override: override);
    router.pop();
  }

  void confirmImporting(
    WidgetRef ref,
    String value, {
    String from = 'local',
  }) async {
    final router = Navigator.of(context);
    if (from == 'network') {
      router.pop();
    }
    showDialog(
      barrierDismissible: false,
      builder: (context) {
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
                  Text('正在加载'),
                ],
              ),
            ),
          ),
        );
      },
      context: context,
    );
    final message = Message.of(context);
    try {
      final notifier = ref.read(sourcesProvider.notifier);
      final (newSources, oldSources) = await notifier.importSources(
        from: from,
        value: value,
      );
      router.pop();
      if (oldSources.isNotEmpty) {
        final keepButton = Consumer(builder: (context, ref, child) {
          return TextButton(
            onPressed: () => confirm(ref, newSources, oldSources),
            child: const Text('保持原有'),
          );
        });
        final overrideButton = Consumer(builder: (context, ref, child) {
          return TextButton(
            onPressed: () => confirm(
              ref,
              newSources,
              oldSources,
              override: true,
            ),
            child: const Text('直接覆盖'),
          );
        });
        showDialog(
          builder: (_) {
            return AlertDialog(
              actions: [keepButton, overrideButton],
              title: Text('发现${oldSources.length}个同名书源书源'),
            );
          },
          context: context,
        );
      } else {
        await notifier.confirmImport(newSources, oldSources);
      }
    } catch (error) {
      router.pop();
      message.show(error.toString());
    }
  }

  void createSource(WidgetRef ref) {
    AutoRouter.of(context).push(SourceFormRoute());
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.create();
  }

  void editSource(WidgetRef ref, int id) async {
    AutoRouter.of(context).push(SourceFormRoute(id: id));
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.edit(id);
  }

  void exportSource(BuildContext context) async {
    final router = Navigator.of(context);
    router.pop();
    final sources = await isar.sources.where().findAll();
    final json = sources.map((source) {
      final string = source.toJson();
      string.remove('id');
      return string;
    }).toList();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, 'sources.json');
    await File(filePath).writeAsString(jsonEncode(json));
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      final bytes = await File(filePath).readAsBytes();
      final output = await FilePicker.platform.saveFile(
        dialogTitle: '导出书源',
        fileName: 'sources.json',
      );
      if (output == null) return;
      File(output).writeAsBytes(bytes);
    } else {
      Share.shareXFiles([XFile(filePath)], subject: 'sources.json');
    }
  }

  void importLocalSource(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      confirmImporting(ref, content, from: 'local');
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void importNetworkSource() async {
    Navigator.of(context).pop();
    showModalBottomSheet(
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Consumer(builder: (context, ref, child) {
              return TextField(
                decoration: const InputDecoration(hintText: '导入网络书源'),
                onSubmitted: (value) =>
                    confirmImporting(ref, value, from: 'network'),
              );
            }),
            const SizedBox(height: 8),
            const SelectableText('目前仅支持GitHub仓库中文件的原始地址。'),
          ],
        ),
      ),
      context: context,
    );
    // router.pop();
  }

  void importSource() async {
    showModalBottomSheet(
      showDragHandle: true,
      builder: (_) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
        return ListView(children: [
          ListTile(
            title: const Text('网络导入'),
            onTap: importNetworkSource,
          ),
          Consumer(builder: ((context, ref, child) {
            return ListTile(
              title: const Text('本地导入'),
              onTap: () => importLocalSource(ref),
            );
          })),
          ListTile(
            title: const Text('导出所有书源'),
            onTap: () => exportSource(context),
          ),
          Divider(
              color: surfaceContainerHighest.withValues(alpha: 0.25),
              height: 1),
          Consumer(builder: (_, ref, child) {
            return ListTile(
              title: const Text('校验书源'),
              onTap: () => validateSources(context, ref),
            );
          }),
          Divider(
              color: surfaceContainerHighest.withValues(alpha: 0.25),
              height: 1),
        ]);
      },
      context: context,
    );
  }

  void validateSources(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();
    showDialog(
      barrierDismissible: false,
      builder: (context) {
        return const UnconstrainedBox(
          child: SizedBox(
            height: 160,
            width: 320,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingIndicator(),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('校验书源需要的时间比较长，请耐心等待'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      context: context,
    );
    final notifier = ref.read(sourcesProvider.notifier);
    final stream = await notifier.validate();
    stream.listen(
      (event) {
        if (!context.mounted) return;
      },
      onDone: () {
        if (!context.mounted) return;
        Navigator.of(context).pop();
      },
    );
  }
}

class _SourceTile extends StatelessWidget {
  final Source source;

  final void Function(int)? onTap;
  const _SourceTile({super.key, required this.source, this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var secondaryContainer = colorScheme.secondaryContainer;
    var circleAvatar = CircleAvatar(
      backgroundColor: source.enabled ? null : secondaryContainer,
      child: Text(source.name.substring(0, 1)),
    );
    return ListTile(
      leading: circleAvatar,
      onTap: handleTap,
      title: Text(source.name),
      subtitle: Text(source.url),
    );
  }

  void handleTap() {
    onTap?.call(source.id);
  }
}
