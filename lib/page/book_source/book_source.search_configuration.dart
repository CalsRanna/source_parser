import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/model/book_source.dart';
import 'package:source_parser/model/rule.dart';
import 'package:source_parser/state/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceSearchConfiguration extends StatelessWidget {
  const BookSourceSearchConfiguration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [DebugButton()],
        title: const Text('搜索配置'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
            child: Column(
              children: [
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '搜索URL',
                    value: ref.watch(bookSourceCreator).searchUrl,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(searchUrl: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
                    title: '校验关键字',
                    value: ref.watch(searchRuleCreator)?.checkKeyWord,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(checkKeyWord: value),
                    ),
                  ),
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
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '书籍列表规则',
                    value: ref.watch(searchRuleCreator)?.books,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(books: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '书名规则',
                    value: ref.watch(searchRuleCreator)?.name,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(name: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '作者规则',
                    value: ref.watch(searchRuleCreator)?.author,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(author: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '分类规则',
                    value: ref.watch(searchRuleCreator)?.category,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(category: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '字数规则',
                    value: ref.watch(searchRuleCreator)?.words,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(words: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '简介规则',
                    value: ref.watch(searchRuleCreator)?.introduction,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(introduction: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '封面规则',
                    value: ref.watch(searchRuleCreator)?.cover,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(cover: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '详情URL规则',
                    value: ref.watch(searchRuleCreator)?.url,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(url: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
                    title: '最新章节规则',
                    value: ref.watch(searchRuleCreator)?.latestChapter,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(latestChapter: value),
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
