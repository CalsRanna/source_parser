import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_view_model.dart';
import 'package:source_parser/page/source_page/component/debug_button.dart';
import 'package:source_parser/page/source_page/component/rule_tile.dart';

@RoutePage()
class SourceAdvancedConfigurationPage extends StatelessWidget {
  const SourceAdvancedConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.instance<SourceFormViewModel>();
    return Scaffold(
      appBar: AppBar(
        actions: const [DebugButton()],
        title: const Text('高级配置'),
      ),
      body: Watch((context) {
        final source = viewModel.source.value;
        return ListView(
          children: [
            RuleTile(
              title: '启用',
              trailing: SizedBox(
                height: 14,
                child: Switch(
                  value: source.enabled,
                  onChanged: (_) => viewModel.toggleEnabled(),
                ),
              ),
              onTap: () => viewModel.toggleEnabled(),
            ),
            RuleTile(
              bordered: false,
              title: '发现',
              trailing: SizedBox(
                height: 14,
                child: Switch(
                  value: source.exploreEnabled,
                  onChanged: (_) => viewModel.toggleExploreEnabled(),
                ),
              ),
              onTap: () => viewModel.toggleExploreEnabled(),
            ),
            RuleTile(
              title: '备注',
              value: source.comment,
              onChange: (value) => viewModel.updateComment(value),
            ),
            RuleTile(
              title: '请求头',
              value: source.header,
              onChange: (value) => viewModel.updateHeader(value),
            ),
            RuleTile(
              title: '编码',
              value: source.charset,
              onTap: () => selectCharset(context, viewModel),
            ),
          ],
        );
      }),
    );
  }

  void selectCharset(BuildContext context, SourceFormViewModel viewModel) {
    const encodings = ['utf8', 'gbk'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(encodings[index]),
              onTap: () {
                viewModel.updateCharset(encodings[index]);
                Navigator.of(context).pop();
              },
            );
          },
          itemCount: encodings.length,
        );
      },
    );
  }
}
