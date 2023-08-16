import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceContentConfiguration extends StatelessWidget {
  const BookSourceContentConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('正文配置')),
      body: CreatorWatcher<Source>(
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
                    onChange: (value) => updateContentContent(context, value),
                  ),
                  RuleTile(
                    title: '下一页URL规则',
                    value: source.contentPagination,
                    onChange: (value) =>
                        updateContentPagination(context, value),
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
                    onChange: (value) => updateContentReplace(context, value),
                  ),
                ],
              ),
            ),
          ],
        ),
        creator: currentSourceCreator,
      ),
    );
  }

  void updateContentContent(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(contentContent: value));
  }

  void updateContentPagination(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(contentPagination: value));
  }

  void updateContentReplace(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(contentReplace: value));
  }
}
