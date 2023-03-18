import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceContentConfiguration extends StatelessWidget {
  const BookSourceContentConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('正文配置')),
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
                    title: '正文规则',
                    value: source.contentContent,
                    onChange: (value) {},
                  ),
                  RuleTile(
                    title: '下一页URL规则',
                    value: source.contentPagination,
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
                    title: '替换规则',
                    value: source.contentReplace,
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
