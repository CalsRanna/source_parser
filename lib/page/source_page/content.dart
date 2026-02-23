import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_view_model.dart';
import 'package:source_parser/page/source_page/component/debug_button.dart';
import 'package:source_parser/page/source_page/component/rule_group_label.dart';
import 'package:source_parser/page/source_page/component/rule_tile.dart';

@RoutePage()
class SourceContentConfigurationPage extends StatelessWidget {
  const SourceContentConfigurationPage({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.instance.get<SourceFormViewModel>();
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('正文配置')),
      body: Watch((context) {
        final source = viewModel.source.value;
        return ListView(
          children: [
            RuleGroupLabel('基本配置'),
            RuleTile(
              title: '请求方法',
              value: source.contentMethod,
              onTap: () => selectMethod(context, viewModel),
            ),
            RuleGroupLabel('正文规则'),
            RuleTile(
              title: '正文规则',
              value: source.contentContent,
              onChange: (value) => viewModel.updateContentContent(value),
            ),
            RuleGroupLabel('分页规则'),
            RuleTile(
              title: '下一页URL规则',
              value: source.contentPagination,
              onChange: (value) => viewModel.updateContentPagination(value),
            ),
            RuleTile(
              title: '校验规则',
              value: source.contentPaginationValidation,
              onChange: (value) =>
                  viewModel.updateContentPaginationValidation(value),
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
                viewModel.updateContentMethod(methods[index]);
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
