import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class SourceContentConfigurationPage extends StatelessWidget {
  const SourceContentConfigurationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('正文配置')),
      body: Consumer(builder: (context, ref, child) {
        final source = ref.watch(formSourceProvider);
        return ListView(
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
                    title: '正文规则',
                    value: source.contentContent,
                    onChange: (value) => updateContentContent(ref, value),
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
                    onChange: (value) => updateContentPagination(ref, value),
                  ),
                  RuleTile(
                    title: '校验规则',
                    value: source.contentPaginationValidation,
                    onChange: (value) =>
                        updateContentPaginationValidation(ref, value),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void selectMethod(BuildContext context) {
    const methods = ['get', 'post'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Consumer(builder: (context, ref, child) {
              return ListTile(
                title: Text(methods[index]),
                onTap: () => confirmSelect(context, ref, methods[index]),
              );
            });
          },
          itemCount: methods.length,
        );
      },
    );
  }

  void confirmSelect(
      BuildContext context, WidgetRef ref, String contentMethod) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(contentMethod: contentMethod));
    Navigator.of(context).pop();
  }

  void updateContentContent(WidgetRef ref, String contentContent) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(contentContent: contentContent));
  }

  void updateContentPagination(WidgetRef ref, String contentPagination) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(contentPagination: contentPagination));
  }

  void updateContentPaginationValidation(
      WidgetRef ref, String contentPaginationValidation) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(
        contentPaginationValidation: contentPaginationValidation));
  }
}
