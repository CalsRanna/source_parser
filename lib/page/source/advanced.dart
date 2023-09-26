import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceAdvancedConfiguration extends StatelessWidget {
  const BookSourceAdvancedConfiguration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [DebugButton()],
        title: const Text('高级配置'),
      ),
      body: CreatorWatcher<Source>(
        builder: (context, source) => ListView(
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
                        onChanged: (value) => triggerEnabled(context),
                      ),
                    ),
                    onTap: () => triggerEnabled(context),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '发现',
                    trailing: SizedBox(
                      height: 14,
                      child: Switch(
                        value: source.exploreEnabled,
                        onChanged: (value) => triggerExploreEnabled(context),
                      ),
                    ),
                    onTap: () => triggerExploreEnabled(context),
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
                    onChange: (value) => updateComment(context, value),
                  ),
                  RuleTile(
                    title: '请求头',
                    value: source.header,
                    onChange: (value) => updateHeader(context, value),
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
        ),
        creator: currentSourceCreator,
      ),
    );
  }

  void triggerEnabled(BuildContext context) async {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(enabled: !source.enabled));
  }

  void triggerExploreEnabled(BuildContext context) async {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(
      currentSourceCreator,
      source.copyWith(exploreEnabled: !source.exploreEnabled),
    );
  }

  void updateComment(BuildContext context, String value) async {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(comment: value));
  }

  void updateHeader(BuildContext context, String value) async {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(header: value));
  }

  void selectCharset(BuildContext context) {
    const encodings = ['utf8', 'gbk'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(encodings[index]),
              onTap: () => confirmSelect(context, encodings[index]),
            );
          },
          itemCount: encodings.length,
        );
      },
    );
  }

  void confirmSelect(BuildContext context, String charset) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(charset: charset));
    Navigator.of(context).pop();
  }
}
