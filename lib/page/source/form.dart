import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/page/source/component/debug_button.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/page/source/component/rule_group_label.dart';
import 'package:source_parser/page/source/component/rule_tile.dart';

@RoutePage()
class SourceFormPage extends StatelessWidget {
  const SourceFormPage({super.key, this.id});

  final int? id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final error = colorScheme.error;
    return Scaffold(
      appBar: AppBar(
        actions: [
          const DebugButton(),
          Consumer(builder: (context, ref, child) {
            return IconButton(
              onPressed: () => storeBookSource(context, ref),
              icon: const Icon(Icons.check_outlined),
            );
          })
        ],
        centerTitle: true,
        title: Consumer(builder: (context, ref, child) {
          final source = ref.watch(formSourceProvider);
          final prefix = source.id.isNegative ? '新建' : '编辑';
          return Text('$prefix书源');
        }),
      ),
      body: ListView(
        children: [
          RuleGroupLabel('基本信息'),
          Consumer(builder: (context, ref, child) {
            final source = ref.watch(formSourceProvider);
            return Column(
              children: [
                RuleTile(
                  onChange: (value) => updateName(ref, value),
                  placeholder: '书源名称',
                  title: '名称',
                  value: source.name,
                ),
                RuleTile(
                  onChange: (value) => updateUrl(ref, value),
                  placeholder: '书源网址，一般为网站域名，用于补全链接',
                  title: '网址',
                  value: source.url,
                )
              ],
            );
          }),
          RuleGroupLabel('规则配置'),
          RuleTile(
            onTap: () => navigate(context, 'search-configuration'),
            title: '搜索',
          ),
          RuleTile(
            title: '详情',
            onTap: () => navigate(context, 'information-configuration'),
          ),
          RuleTile(
            title: '目录',
            onTap: () => navigate(context, 'catalogue-configuration'),
          ),
          RuleTile(
            bordered: false,
            title: '正文',
            onTap: () => navigate(context, 'content-configuration'),
          ),
          Consumer(builder: (context, ref, child) {
            final source = ref.watch(formSourceProvider);
            if (!source.exploreEnabled) return const SizedBox();
            return RuleTile(
              title: '发现',
              value: source.exploreJson,
              onChange: (value) => updateExploreJson(ref, value),
              placeholder: '发现配置，配置后可在发现页使用',
            );
          }),
          RuleGroupLabel('其他信息'),
          RuleTile(
            onTap: () => navigate(context, 'advanced-configuration'),
            placeholder: '其他配置，一般不需要填写',
            title: '高级',
          ),
          const SizedBox(height: 8),
          Consumer(builder: (context, ref, child) {
            final source = ref.watch(formSourceProvider);
            if (source.id.isNegative) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => deleteSource(context),
                child: Text('删除', style: TextStyle(color: error)),
              ),
            );
          })
        ],
      ),
    );
  }

  void storeBookSource(BuildContext context, WidgetRef ref) async {
    final message = Message.of(context);
    final source = ref.read(formSourceProvider);
    final formNotifier = ref.read(formSourceProvider.notifier);
    final validation = await formNotifier.validate();
    if (validation.isNotEmpty) {
      message.show(validation);
      return;
    }
    final notifier = ref.read(sourcesProvider.notifier);
    await notifier.store(source);
    message.show('书源保存成功');
  }

  void updateName(WidgetRef ref, String name) async {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(name: name));
  }

  void updateUrl(WidgetRef ref, String url) async {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(url: url));
  }

  void updateExploreJson(WidgetRef ref, String exploreJson) async {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(exploreJson: exploreJson));
  }

  void navigate(BuildContext context, String route) {
    switch (route) {
      case 'advanced-configuration':
        AutoRouter.of(context).push(SourceAdvancedConfigurationRoute());
        break;
      case 'search-configuration':
        AutoRouter.of(context).push(SourceSearchConfigurationRoute());
        break;
      case 'information-configuration':
        AutoRouter.of(context).push(SourceInformationConfigurationRoute());
        break;
      case 'catalogue-configuration':
        AutoRouter.of(context).push(SourceCatalogueConfigurationRoute());
        break;
      case 'content-configuration':
        AutoRouter.of(context).push(SourceContentConfigurationRoute());
        break;
      default:
        break;
    }
  }

  void deleteSource(BuildContext context) async {
    showDialog(
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => cancel(context),
              child: const Text('取消'),
            ),
            Consumer(builder: (context, ref, child) {
              return TextButton(
                onPressed: () => confirmDelete(context, ref),
                child: const Text('确认'),
              );
            })
          ],
          content: const Text('确认删除该书源？'),
          title: const Text('删除书源'),
        );
      },
      context: context,
    );
  }

  void cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirmDelete(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(sourcesProvider.notifier);
    await notifier.delete(source.id);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}
