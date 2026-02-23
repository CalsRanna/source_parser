import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_view_model.dart';
import 'package:source_parser/page/source_page/component/debug_button.dart';
import 'package:source_parser/page/source_page/component/rule_group_label.dart';
import 'package:source_parser/page/source_page/component/rule_tile.dart';

@RoutePage()
class SourceSearchConfigurationPage extends StatelessWidget {
  const SourceSearchConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.instance.get<SourceFormViewModel>();
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('搜索配置')),
      body: Watch((context) {
        final source = viewModel.source.value;
        return ListView(
          children: [
            RuleGroupLabel('基本配置'),
            RuleTile(
              title: '搜索URL',
              value: source.searchUrl,
              onChange: (value) => viewModel.updateSearchUrl(value),
            ),
            RuleTile(
              bordered: false,
              title: '请求方法',
              value: source.searchMethod,
              onTap: () => selectMethod(context, viewModel),
            ),
            RuleGroupLabel('搜索规则'),
            RuleTile(
              bordered: false,
              title: '书籍列表规则',
              value: source.searchBooks,
              onChange: (value) => viewModel.updateSearchBooks(value),
            ),
            RuleTile(
              bordered: false,
              title: '作者规则',
              value: source.searchAuthor,
              onChange: (value) => viewModel.updateSearchAuthor(value),
            ),
            RuleTile(
              bordered: false,
              title: '分类规则',
              value: source.searchCategory,
              onChange: (value) => viewModel.updateSearchCategory(value),
            ),
            RuleTile(
              bordered: false,
              title: '封面规则',
              value: source.searchCover,
              onChange: (value) => viewModel.updateSearchCover(value),
            ),
            RuleTile(
              bordered: false,
              title: '简介规则',
              value: source.searchIntroduction,
              onChange: (value) => viewModel.updateSearchIntroduction(value),
            ),
            RuleTile(
              bordered: false,
              title: '最新章节规则',
              value: source.searchLatestChapter,
              onChange: (value) => viewModel.updateSearchLatestChapter(value),
            ),
            RuleTile(
              bordered: false,
              title: '书名规则',
              value: source.searchName,
              onChange: (value) => viewModel.updateSearchName(value),
            ),
            RuleTile(
              bordered: false,
              title: '详情URL规则',
              value: source.searchInformationUrl,
              onChange: (value) => viewModel.updateSearchInformationUrl(value),
            ),
            RuleTile(
              bordered: false,
              title: '字数规则',
              value: source.searchWordCount,
              onChange: (value) => viewModel.updateSearchWordCount(value),
            ),
            RuleGroupLabel('分页规则'),
            RuleTile(
              title: '下一页URL规则',
              onChange: (value) => {},
            ),
            RuleTile(
              title: '校验规则',
              onChange: (value) => {},
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
                viewModel.updateSearchMethod(methods[index]);
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
