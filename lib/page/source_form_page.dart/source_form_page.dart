import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_view_model.dart';
import 'package:source_parser/page/source_page/component/rule_group_label.dart';
import 'package:source_parser/page/source_page/component/rule_tile.dart';

@RoutePage()
class SourceFormPage extends StatefulWidget {
  final SourceEntity? source;

  const SourceFormPage({super.key, this.source});

  @override
  State<SourceFormPage> createState() => _SourceFormPageState();
}

class _SourceFormPageState extends State<SourceFormPage> {
  final viewModel = GetIt.instance.get<SourceFormViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initSignals(widget.source);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_buildDebugButton(), _buildStoreButton()],
        centerTitle: true,
        title: Watch((_) => Text(viewModel.title.value)),
      ),
      body: Watch(
        (_) => ListView(
          children: [
            _buildBasicGroup(),
            _buildRuleGroup(),
            _buildOtherGroup(),
            const SizedBox(height: 8),
            _buildDestroyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDestroyButton() {
    if (viewModel.source.value.id == 0) return const SizedBox();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final error = colorScheme.error;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => viewModel.destroySource(context),
        child: Text('删除', style: TextStyle(color: error)),
      ),
    );
  }

  Widget _buildBasicGroup() {
    return Column(
      children: [
        RuleGroupLabel('基本信息'),
        RuleTile(
          onChange: viewModel.updateName,
          placeholder: '书源名称',
          title: '名称',
          value: viewModel.source.value.name,
        ),
        RuleTile(
          onChange: viewModel.updateUrl,
          placeholder: '书源网址，一般为网站域名，用于补全链接',
          title: '网址',
          value: viewModel.source.value.url,
        )
      ],
    );
  }

  Widget _buildDebugButton() {
    return IconButton(
      onPressed: () => viewModel.navigateSourceFormDebugPage(context),
      icon: const Icon(HugeIcons.strokeRoundedCursorMagicSelection02),
    );
  }

  Widget _buildOtherGroup() {
    return Column(
      children: [
        RuleGroupLabel('其他信息'),
        RuleTile(
          onTap: () => viewModel.navigateSourceDetailAdvancedPage(context),
          placeholder: '其他配置，一般不需要填写',
          title: '高级',
        ),
      ],
    );
  }

  Widget _buildRuleGroup() {
    return Column(
      children: [
        RuleGroupLabel('规则配置'),
        RuleTile(
          onTap: () => viewModel.navigateSourceDetailSearchPage(context),
          title: '搜索',
        ),
        RuleTile(
          title: '详情',
          onTap: () => viewModel.navigateSourceDetailInformationPage(context),
        ),
        RuleTile(
          title: '目录',
          onTap: () => viewModel.navigateSourceDetailCataloguePage(context),
        ),
        RuleTile(
          bordered: false,
          title: '正文',
          onTap: () => viewModel.navigateSourceDetailContentPage(context),
        ),
        RuleTile(
          title: '发现',
          value: viewModel.source.value.exploreJson,
          onChange: viewModel.updateExploreJson,
          placeholder: '发现配置，配置后可在发现页使用',
        )
      ],
    );
  }

  Widget _buildStoreButton() {
    return IconButton(
      onPressed: () => viewModel.storeSource(),
      icon: const Icon(HugeIcons.strokeRoundedTick02),
    );
  }
}
