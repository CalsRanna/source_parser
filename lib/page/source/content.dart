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
                    title: '请求方法',
                    value: source.contentMethod,
                    onTap: () => selectMethod(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '下一页URL规则',
                    value: source.contentPagination,
                    onChange: (value) =>
                        updateContentPagination(context, value),
                  ),
                  RuleTile(
                    title: '正文规则',
                    value: source.contentContent,
                    onChange: (value) => updateContentContent(context, value),
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

  void selectMethod(BuildContext context) {
    const methods = ['get', 'post'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(methods[index]),
              onTap: () => confirmSelect(context, methods[index]),
            );
          },
          itemCount: methods.length,
        );
      },
    );
  }

  void confirmSelect(BuildContext context, String method) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(contentMethod: method));
    Navigator.of(context).pop();
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
}
