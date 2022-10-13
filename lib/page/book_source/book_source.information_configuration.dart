import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/widget/debug_button.dart';

import '../../model/rule.dart';
import '../../state/source.dart';
import '../../widget/bordered_card.dart';
import '../../widget/rule_tile.dart';

class BookSourceInformationConfiguration extends StatelessWidget {
  const BookSourceInformationConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('详情配置')),
      body: ListView(
        children: [
          BorderedCard(
            title: '配置',
            child: Column(
              children: [
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '预处理规则',
                    value: ref.watch(informationRuleCreator)?.preprocess,
                    onChange: (value) => ref.update<InformationRule?>(
                      informationRuleCreator,
                      (rule) => rule?.copyWith(preprocess: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '书名规则',
                    value: ref.watch(informationRuleCreator)?.name,
                    onChange: (value) => ref.update<InformationRule?>(
                      informationRuleCreator,
                      (rule) => rule?.copyWith(name: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '作者规则',
                    value: ref.watch(informationRuleCreator)?.author,
                    onChange: (value) => ref.update<InformationRule?>(
                      informationRuleCreator,
                      (rule) => rule?.copyWith(author: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '分类规则',
                    value: ref.watch(informationRuleCreator)?.category,
                    onChange: (value) => ref.update<InformationRule?>(
                      informationRuleCreator,
                      (rule) => rule?.copyWith(category: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '字数规则',
                    value: ref.watch(informationRuleCreator)?.words,
                    onChange: (value) => ref.update<InformationRule?>(
                      informationRuleCreator,
                      (rule) => rule?.copyWith(words: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '最新章节规则',
                    value: ref.watch(informationRuleCreator)?.latestChapter,
                    onChange: (value) => ref.update<InformationRule?>(
                      informationRuleCreator,
                      (rule) => rule?.copyWith(latestChapter: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '简介规则',
                    value: ref.watch(informationRuleCreator)?.introduction,
                    onChange: (value) => ref.update<InformationRule?>(
                      informationRuleCreator,
                      (rule) => rule?.copyWith(introduction: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '封面规则',
                    value: ref.watch(informationRuleCreator)?.cover,
                    onChange: (value) => ref.update<InformationRule?>(
                      informationRuleCreator,
                      (rule) => rule?.copyWith(cover: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
                    title: '目录URL规则',
                    value: ref.watch(informationRuleCreator)?.catalogueUrl,
                    onChange: (value) => ref.update<InformationRule?>(
                      informationRuleCreator,
                      (rule) => rule?.copyWith(catalogueUrl: value),
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
