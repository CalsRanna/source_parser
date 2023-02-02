import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/model/rule.dart';
import 'package:source_parser/state/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceCatalogueConfiguration extends StatelessWidget {
  const BookSourceCatalogueConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('目录配置')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
            child: Column(
              children: [
                Watcher(
                  (contex, ref, _) => RuleTile(
                    title: '目录列表规则',
                    value: ref.watch(catalogueRuleCreator)?.chapters,
                    onChange: (value) => ref.update<CatalogueRule?>(
                      catalogueRuleCreator,
                      (rule) => rule?.copyWith(chapters: value),
                    ),
                  ),
                ),
                Watcher(
                  (contex, ref, _) => RuleTile(
                    title: '章节名称规则',
                    value: ref.watch(catalogueRuleCreator)?.name,
                    onChange: (value) => ref.update<CatalogueRule?>(
                      catalogueRuleCreator,
                      (rule) => rule?.copyWith(name: value),
                    ),
                  ),
                ),
                Watcher(
                  (contex, ref, _) => RuleTile(
                    title: '章节URL规则',
                    value: ref.watch(catalogueRuleCreator)?.url,
                    onChange: (value) => ref.update<CatalogueRule?>(
                      catalogueRuleCreator,
                      (rule) => rule?.copyWith(url: value),
                    ),
                  ),
                ),
                Watcher(
                  (contex, ref, _) => RuleTile(
                    title: 'VIP标识',
                    value: ref.watch(catalogueRuleCreator)?.vip,
                    onChange: (value) => ref.update<CatalogueRule?>(
                      catalogueRuleCreator,
                      (rule) => rule?.copyWith(vip: value),
                    ),
                  ),
                ),
                Watcher(
                  (contex, ref, _) => RuleTile(
                    title: '更新时间规则',
                    value: ref.watch(catalogueRuleCreator)?.updatedAt,
                    onChange: (value) => ref.update<CatalogueRule?>(
                      catalogueRuleCreator,
                      (rule) => rule?.copyWith(updatedAt: value),
                    ),
                  ),
                ),
                Watcher(
                  (contex, ref, _) => RuleTile(
                    bordered: false,
                    title: '目录下一页规则',
                    value: ref.watch(catalogueRuleCreator)?.pagination,
                    onChange: (value) => ref.update<CatalogueRule?>(
                      catalogueRuleCreator,
                      (rule) => rule?.copyWith(pagination: value),
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
