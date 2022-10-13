import 'package:creator/creator.dart';
import 'package:flutter/material.dart';

import '../../model/rule.dart';
import '../../state/source.dart';
import '../../widget/bordered_card.dart';
import '../../widget/debug_button.dart';
import '../../widget/rule_tile.dart';

class BookSourceContentConfiguration extends StatelessWidget {
  const BookSourceContentConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('正文配置')),
      body: ListView(
        children: [
          BorderedCard(
            title: '基础',
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
          BorderedCard(
            title: '配置',
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
