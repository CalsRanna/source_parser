import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/model/rule.dart';
import 'package:source_parser/state/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceContentConfiguration extends StatelessWidget {
  const BookSourceContentConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('正文配置')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              '基础',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Card(
            child: Column(
              children: [
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '正文规则',
                    value: ref.watch(contentRuleCreator)?.content,
                    onChange: (value) => ref.update<ContentRule?>(
                      contentRuleCreator,
                      (rule) => rule?.copyWith(content: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
                    title: '下一页URL规则',
                    value: ref.watch(contentRuleCreator)?.pagination,
                    onChange: (value) => ref.update<ContentRule?>(
                      contentRuleCreator,
                      (rule) => rule?.copyWith(pagination: value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              '配置',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Card(
            child: Column(
              children: [
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '网页脚本',
                    value: ref.watch(contentRuleCreator)?.script,
                    onChange: (value) => ref.update<ContentRule?>(
                      contentRuleCreator,
                      (rule) => rule?.copyWith(script: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '资源正则',
                    value: ref.watch(contentRuleCreator)?.source,
                    onChange: (value) => ref.update<ContentRule?>(
                      contentRuleCreator,
                      (rule) => rule?.copyWith(source: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '替换规则',
                    value: ref.watch(contentRuleCreator)?.replace,
                    onChange: (value) => ref.update<ContentRule?>(
                      contentRuleCreator,
                      (rule) => rule?.copyWith(replace: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
                    title: '图片样式',
                    value: ref.watch(contentRuleCreator)?.imageStyle,
                    onChange: (value) => ref.update<ContentRule?>(
                      contentRuleCreator,
                      (rule) => rule?.copyWith(imageStyle: value),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
