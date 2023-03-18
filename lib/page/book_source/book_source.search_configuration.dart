import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/source.dart';
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
                    title: '搜索URL',
                    value: source.searchUrl,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '校验关键字',
                    value: source.searchCheckCredential,
                    onChange: (value) {},
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
                    bordered: false,
                    title: '书籍列表规则',
                    value: source.searchBooks,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '书名规则',
                    value: source.searchName,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '作者规则',
                    value: source.searchAuthor,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '分类规则',
                    value: source.searchCategory,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '字数规则',
                    value: source.searchWordCount,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '简介规则',
                    value: source.searchIntroduction,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '封面规则',
                    value: source.searchCover,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '详情URL规则',
                    value: source.searchInformationUrl,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '最新章节规则',
                    value: source.searchLatestChapter,
                    onChange: (value) {},
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
}
