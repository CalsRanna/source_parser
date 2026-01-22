import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_view_model.dart';
import 'package:source_parser/page/source_page/component/debug_button.dart';
import 'package:source_parser/page/source_page/component/rule_group_label.dart';
import 'package:source_parser/page/source_page/component/rule_tile.dart';

@RoutePage()
class SourceInformationConfigurationPage extends StatelessWidget {
  const SourceInformationConfigurationPage({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.instance<SourceFormViewModel>();
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('详情配置')),
      body: Watch((context) {
        final source = viewModel.source.value;
        return ListView(
          children: [
            RuleGroupLabel('基本配置'),
            RuleTile(
              title: '请求方法',
              value: source.informationMethod,
              onTap: () => selectMethod(context, viewModel),
            ),
            RuleGroupLabel('详情规则'),
            RuleTile(
              title: '作者规则',
              value: source.informationAuthor,
              onChange: (value) => viewModel.updateInformationAuthor(value),
            ),
            RuleTile(
              title: '目录URL规则',
              value: source.informationCatalogueUrl,
              onChange: (value) =>
                  viewModel.updateInformationCatalogueUrl(value),
            ),
            RuleTile(
              title: '分类规则',
              value: source.informationCategory,
              onChange: (value) => viewModel.updateInformationCategory(value),
            ),
            RuleTile(
              title: '封面规则',
              value: source.informationCover,
              onChange: (value) => viewModel.updateInformationCover(value),
            ),
            RuleTile(
              title: '简介规则',
              value: source.informationIntroduction,
              onChange: (value) =>
                  viewModel.updateInformationIntroduction(value),
            ),
            RuleTile(
              title: '最新章节规则',
              value: source.informationLatestChapter,
              onChange: (value) =>
                  viewModel.updateInformationLatestChapter(value),
            ),
            RuleTile(
              title: '书名规则',
              value: source.informationName,
              onChange: (value) => viewModel.updateInformationName(value),
            ),
            RuleTile(
              title: '字数规则',
              value: source.informationWordCount,
              onChange: (value) => viewModel.updateInformationWordCount(value),
            ),
          ],
        );
      }),
    );
  }

  void selectMethod(BuildContext context, SourceFormViewModel viewModel) {
    const methods = ['get', 'post'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(methods[index]),
              onTap: () {
                viewModel.updateInformationMethod(methods[index]);
                Navigator.of(context).pop();
              },
            );
          },
          itemCount: methods.length,
        );
      },
    );
  }
}
