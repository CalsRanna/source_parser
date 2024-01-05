import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceInformationConfiguration extends StatelessWidget {
  const BookSourceInformationConfiguration({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('详情配置')),
      body: Watcher((context, ref, child) {
        final source = ref.watch(currentSourceCreator);
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
                    value: source.informationMethod,
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
                    title: '作者规则',
                    value: source.informationAuthor,
                    onChange: (value) =>
                        updateInformationAuthor(context, value),
                  ),
                  RuleTile(
                    title: '目录URL规则',
                    value: source.informationCatalogueUrl,
                    onChange: (value) =>
                        updateInformationCatalogueUrl(context, value),
                  ),
                  RuleTile(
                    title: '分类规则',
                    value: source.informationCategory,
                    onChange: (value) =>
                        updateInformationCategory(context, value),
                  ),
                  RuleTile(
                    title: '封面规则',
                    value: source.informationCover,
                    onChange: (value) => updateInformationCover(context, value),
                  ),
                  RuleTile(
                    title: '简介规则',
                    value: source.informationIntroduction,
                    onChange: (value) =>
                        updateInformationIntroduction(context, value),
                  ),
                  RuleTile(
                    title: '最新章节规则',
                    value: source.informationLatestChapter,
                    onChange: (value) =>
                        updateInformationLatestChapter(context, value),
                  ),
                  RuleTile(
                    title: '书名规则',
                    value: source.informationName,
                    onChange: (value) => updateInformationName(context, value),
                  ),
                  RuleTile(
                    title: '字数规则',
                    value: source.informationWordCount,
                    onChange: (value) =>
                        updateInformationWordCount(context, value),
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
    ref.set(currentSourceCreator, source.copyWith(informationMethod: method));
    Navigator.of(context).pop();
  }

  void updateInformationName(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(informationName: value));
  }

  void updateInformationAuthor(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(informationAuthor: value));
  }

  void updateInformationCategory(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(informationCategory: value));
  }

  void updateInformationWordCount(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(informationWordCount: value));
  }

  void updateInformationLatestChapter(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(
      currentSourceCreator,
      source.copyWith(informationLatestChapter: value),
    );
  }

  void updateInformationIntroduction(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(
      currentSourceCreator,
      source.copyWith(informationIntroduction: value),
    );
  }

  void updateInformationCover(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(informationCover: value));
  }

  void updateInformationCatalogueUrl(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(
      currentSourceCreator,
      source.copyWith(informationCatalogueUrl: value),
    );
  }
}
