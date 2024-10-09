import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/page/source/component/debug_button.dart';
import 'package:source_parser/page/source/component/rule_group_label.dart';
import 'package:source_parser/page/source/component/rule_tile.dart';

class SourceInformationConfigurationPage extends StatelessWidget {
  const SourceInformationConfigurationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('详情配置')),
      body: Consumer(builder: (context, ref, child) {
        final source = ref.watch(formSourceProvider);
        return ListView(
          children: [
            RuleGroupLabel('基本配置'),
            RuleTile(
              title: '请求方法',
              value: source.informationMethod,
              onTap: () => selectMethod(context),
            ),
            RuleGroupLabel('详情规则'),
            RuleTile(
              title: '作者规则',
              value: source.informationAuthor,
              onChange: (value) => updateInformationAuthor(ref, value),
            ),
            RuleTile(
              title: '目录URL规则',
              value: source.informationCatalogueUrl,
              onChange: (value) => updateInformationCatalogueUrl(ref, value),
            ),
            RuleTile(
              title: '分类规则',
              value: source.informationCategory,
              onChange: (value) => updateInformationCategory(ref, value),
            ),
            RuleTile(
              title: '封面规则',
              value: source.informationCover,
              onChange: (value) => updateInformationCover(ref, value),
            ),
            RuleTile(
              title: '简介规则',
              value: source.informationIntroduction,
              onChange: (value) => updateInformationIntroduction(ref, value),
            ),
            RuleTile(
              title: '最新章节规则',
              value: source.informationLatestChapter,
              onChange: (value) => updateInformationLatestChapter(ref, value),
            ),
            RuleTile(
              title: '书名规则',
              value: source.informationName,
              onChange: (value) => updateInformationName(ref, value),
            ),
            RuleTile(
              title: '字数规则',
              value: source.informationWordCount,
              onChange: (value) => updateInformationWordCount(ref, value),
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
      BuildContext context, WidgetRef ref, String informationMethod) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(informationMethod: informationMethod));
    Navigator.of(context).pop();
  }

  void updateInformationName(WidgetRef ref, String informationName) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(informationName: informationName));
  }

  void updateInformationAuthor(WidgetRef ref, String informationAuthor) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(informationAuthor: informationAuthor));
  }

  void updateInformationCategory(WidgetRef ref, String informationCategory) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(informationCategory: informationCategory));
  }

  void updateInformationWordCount(WidgetRef ref, String informationWordCount) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier
        .update(source.copyWith(informationWordCount: informationWordCount));
  }

  void updateInformationLatestChapter(
      WidgetRef ref, String informationLatestChapter) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(
        source.copyWith(informationLatestChapter: informationLatestChapter));
  }

  void updateInformationIntroduction(
      WidgetRef ref, String informationIntroduction) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(
        source.copyWith(informationIntroduction: informationIntroduction));
  }

  void updateInformationCover(WidgetRef ref, String informationCover) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(informationCover: informationCover));
  }

  void updateInformationCatalogueUrl(
      WidgetRef ref, String informationCatalogueUrl) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(
        source.copyWith(informationCatalogueUrl: informationCatalogueUrl));
  }
}
