import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceExploreConfiguration extends StatelessWidget {
  const BookSourceExploreConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('发现配置')),
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
                    bordered: false,
                    title: 'URL规则',
                    value: source.exploreUrl,
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
                    value: source.exploreBooks,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '书名规则',
                    value: source.exploreName,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '作者规则',
                    value: source.exploreAuthor,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '分类规则',
                    value: source.exploreCategory,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '字数规则',
                    value: source.exploreWordCount,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '最新章节规则',
                    value: source.exploreLatestChapter,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '简介规则',
                    value: source.exploreIntroduction,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '封面规则',
                    value: source.exploreCover,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    bordered: false,
                    title: '详情URL规则',
                    value: source.exploreInformationUrl,
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
