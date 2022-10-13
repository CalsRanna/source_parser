import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../entity/book_source.dart';
import '../../model/rule.dart';
import '../../state/source.dart';
import '../../widget/bordered_card.dart';
import '../../widget/rule_tile.dart';

class BookSourceSearchConfiguration extends StatelessWidget {
  const BookSourceSearchConfiguration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.push('/book-source/debug');
            },
            icon: const Icon(Icons.bug_report_outlined),
          ),
        ],
        title: const Text('搜索配置'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BorderedCard(
            title: '基础',
            child: Column(
              children: [
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '搜索地址规则',
                    value: ref.watch(bookSourceCreator)?.searchUrl,
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
          BorderedCard(
            title: '配置',
            child: Column(
              children: [
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
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
                    bordered: false,
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
                    bordered: false,
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
                    bordered: false,
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
                    bordered: false,
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
                    bordered: false,
                    title: '最新章节规则',
                    value: ref.watch(searchRuleCreator)?.latestChapter,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
                      (rule) => rule?.copyWith(latestChapter: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
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
                    bordered: false,
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
                    bordered: false,
                    title: '详情URL规则',
                    value: ref.watch(searchRuleCreator)?.url,
                    onChange: (value) => ref.update<SearchRule?>(
                      searchRuleCreator,
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
