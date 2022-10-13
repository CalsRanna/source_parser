import 'package:creator/creator.dart';
import 'package:flutter/material.dart';

import '../../model/book_source.dart';
import '../../model/rule.dart';
import '../../state/source.dart';
import '../../widget/bordered_card.dart';
import '../../widget/debug_button.dart';
import '../../widget/rule_tile.dart';

class BookSourceExploreConfiguration extends StatelessWidget {
  const BookSourceExploreConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('发现配置')),
      body: ListView(
        children: [
          BorderedCard(
            title: '基础',
            child: Column(
              children: [
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
                    title: 'URL规则',
                    value: ref.watch(bookSourceCreator).exploreUrl,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(exploreUrl: value),
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
                    title: '书籍列表规则',
                    value: ref.watch(exploreRuleCreator)?.books,
                    onChange: (value) => ref.update<ExploreRule?>(
                      exploreRuleCreator,
                      (rule) => rule?.copyWith(books: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '书名规则',
                    value: ref.watch(exploreRuleCreator)?.name,
                    onChange: (value) => ref.update<ExploreRule?>(
                      exploreRuleCreator,
                      (rule) => rule?.copyWith(name: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '作者规则',
                    value: ref.watch(exploreRuleCreator)?.author,
                    onChange: (value) => ref.update<ExploreRule?>(
                      exploreRuleCreator,
                      (rule) => rule?.copyWith(author: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '分类规则',
                    value: ref.watch(exploreRuleCreator)?.category,
                    onChange: (value) => ref.update<ExploreRule?>(
                      exploreRuleCreator,
                      (rule) => rule?.copyWith(category: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '字数规则',
                    value: ref.watch(exploreRuleCreator)?.words,
                    onChange: (value) => ref.update<ExploreRule?>(
                      exploreRuleCreator,
                      (rule) => rule?.copyWith(words: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '最新章节规则',
                    value: ref.watch(exploreRuleCreator)?.latestChapter,
                    onChange: (value) => ref.update<ExploreRule?>(
                      exploreRuleCreator,
                      (rule) => rule?.copyWith(latestChapter: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '简介规则',
                    value: ref.watch(exploreRuleCreator)?.introduction,
                    onChange: (value) => ref.update<ExploreRule?>(
                      exploreRuleCreator,
                      (rule) => rule?.copyWith(introduction: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '封面规则',
                    value: ref.watch(exploreRuleCreator)?.cover,
                    onChange: (value) => ref.update<ExploreRule?>(
                      exploreRuleCreator,
                      (rule) => rule?.copyWith(cover: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
                    title: '详情URL规则',
                    value: ref.watch(exploreRuleCreator)?.url,
                    onChange: (value) => ref.update<ExploreRule?>(
                      exploreRuleCreator,
                      (rule) => rule?.copyWith(url: value),
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
