import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceCatalogueConfiguration extends StatelessWidget {
  const BookSourceCatalogueConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('目录配置')),
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
                    title: '目录列表规则',
                    value: source.catalogueChapters,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '章节名称规则',
                    value: source.catalogueName,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '章节URL规则',
                    value: source.catalogueUrl,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: 'VIP标识',
                    value: source.catalogueVip,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '更新时间规则',
                    value: source.catalogueUpdatedAt,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '下一页URL规则',
                    value: source.cataloguePagination,
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
