import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_view_model.dart';
import 'package:source_parser/page/source_page/component/debug_button.dart';
import 'package:source_parser/page/source_page/component/rule_group_label.dart';
import 'package:source_parser/page/source_page/component/rule_tile.dart';

@RoutePage()
class SourceCatalogueConfigurationPage extends StatelessWidget {
  const SourceCatalogueConfigurationPage({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.instance<SourceFormViewModel>();
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('目录配置')),
      body: Watch((context) {
        final source = viewModel.source.value;
        return ListView(
          children: [
            RuleGroupLabel('基本配置'),
            RuleTile(
              title: '请求方法',
              value: source.catalogueMethod,
              onTap: () => selectMethod(context, viewModel),
            ),
            RuleTile(
              placeholder: '解析后的值使用{{preset}}代替，仅章节URL规则可用',
              title: '预设',
              value: source.cataloguePreset,
              onChange: (value) => viewModel.updateCataloguePreset(value),
            ),
            RuleGroupLabel('目录规则'),
            RuleTile(
              title: '目录列表规则',
              value: source.catalogueChapters,
              onChange: (value) => viewModel.updateCatalogueChapters(value),
            ),
            RuleTile(
              title: '章节名称规则',
              value: source.catalogueName,
              onChange: (value) => viewModel.updateCatalogueName(value),
            ),
            RuleTile(
              title: '更新时间规则',
              value: source.catalogueUpdatedAt,
              onChange: (value) => viewModel.updateCatalogueUpdatedAt(value),
            ),
            RuleTile(
              title: '章节URL规则',
              value: source.catalogueUrl,
              onChange: (value) => viewModel.updateCatalogueUrl(value),
            ),
            RuleGroupLabel('分页规则'),
            RuleTile(
              title: '下一页URL规则',
              value: source.cataloguePagination,
              onChange: (value) => viewModel.updateCataloguePagination(value),
            ),
            RuleTile(
              title: '校验规则',
              value: source.cataloguePaginationValidation,
              onChange: (value) =>
                  viewModel.updateCataloguePaginationValidation(value),
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
                viewModel.updateCatalogueMethod(methods[index]);
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
