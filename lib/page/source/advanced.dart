import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class SourceAdvancedConfigurationPage extends StatelessWidget {
  const SourceAdvancedConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [DebugButton()],
        title: const Text('高级配置'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final source = ref.watch(formSourceProvider);
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 0,
                child: Column(
                  children: [
                    RuleTile(
                      title: '启用',
                      trailing: SizedBox(
                        height: 14,
                        child: Switch(
                          value: source.enabled,
                          onChanged: (value) => triggerEnabled(ref),
                        ),
                      ),
                      onTap: () => triggerEnabled(ref),
                    ),
                    RuleTile(
                      bordered: false,
                      title: '发现',
                      trailing: SizedBox(
                        height: 14,
                        child: Switch(
                          value: source.exploreEnabled,
                          onChanged: (value) => triggerExploreEnabled(ref),
                        ),
                      ),
                      onTap: () => triggerExploreEnabled(ref),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 0,
                child: Column(
                  children: [
                    RuleTile(
                      title: '备注',
                      value: source.comment,
                      onChange: (value) => updateComment(ref, value),
                    ),
                    RuleTile(
                      title: '请求头',
                      value: source.header,
                      onChange: (value) => updateHeader(ref, value),
                    ),
                    RuleTile(
                      title: '编码',
                      value: source.charset,
                      onTap: () => selectCharset(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void triggerEnabled(WidgetRef ref) async {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(enabled: !source.enabled));
  }

  void triggerExploreEnabled(WidgetRef ref) async {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(exploreEnabled: !source.exploreEnabled));
  }

  void updateComment(WidgetRef ref, String comment) async {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(comment: comment));
  }

  void updateHeader(WidgetRef ref, String header) async {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(header: header));
  }

  void selectCharset(BuildContext context) {
    const encodings = ['utf8', 'gbk'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Consumer(builder: (context, ref, child) {
              return ListTile(
                title: Text(encodings[index]),
                onTap: () => confirmSelect(context, ref, encodings[index]),
              );
            });
          },
          itemCount: encodings.length,
        );
      },
    );
  }

  void confirmSelect(BuildContext context, WidgetRef ref, String charset) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(charset: charset));
    Navigator.of(context).pop();
  }
}
