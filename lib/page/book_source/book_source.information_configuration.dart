import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceInformationConfiguration extends StatelessWidget {
  const BookSourceInformationConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('详情配置')),
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
                    title: '预处理规则',
                    value: source.informationPreprocess,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '书名规则',
                    value: source.informationName,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '作者规则',
                    value: source.informationAuthor,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '分类规则',
                    value: source.informationCategory,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '字数规则',
                    value: source.informationWordCount,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '最新章节规则',
                    value: source.informationLatestChapter,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '简介规则',
                    value: source.informationIntroduction,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '封面规则',
                    value: source.informationCover,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '目录URL规则',
                    value: source.informationCatalogueUrl,
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
