import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/source.dart';
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
      body: EmitterWatcher<Source>(
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
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '分组',
                    value: source.group,
                    onChange: (value) => updateGroup(context, value),
                  ),
                  RuleTile(
                    title: '备注',
                    value: source.comment,
                    onChange: (value) => updateComment(context, value),
                  ),
                  RuleTile(
                    title: '登陆URL',
                    value: source.loginUrl,
                    onChange: (value) => updateLoginUrl(context, value),
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
                  RuleTile(
                    bordered: false,
                    title: '权重',
                    value: source.weight.toString(),
                    onChange: (value) => updateWeight(context, value),
                  ),
                ],
              ),
            ),
          ],
        ),
        emitter: sourceEmitter(null),
      ),
    );
  }

  void triggerEnabled(BuildContext context) async {
    final ref = context.ref;
    final source = await ref.read(sourceEmitter(null));
    source.enabled = !source.enabled;
    ref.emit(sourceEmitter(null), source);
  }

  void triggerExploreEnabled(BuildContext context) async {}

  void updateGroup(BuildContext context, String group) async {}
  void updateComment(BuildContext context, String group) async {}
  void updateLoginUrl(BuildContext context, String group) async {}
  void updateHeader(BuildContext context, String group) async {}
  void updateWeight(BuildContext context, String group) async {}

  void selectCharset(BuildContext context) {
    const charsets = ['utf8', 'gbk'];
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 56 * 2 + MediaQuery.of(context).padding.bottom,
        child: Column(
          children: List.generate(
            charsets.length,
            (index) => ListTile(
              title: Text(charsets[index]),
              onTap: () => confirmSelect(context, charsets[index]),
            ),
          ),
        ),
      ),
    );
  }

  void confirmSelect(BuildContext context, String charset) {
    Navigator.of(context).pop();
  }
}
