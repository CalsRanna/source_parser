import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/rule_tile.dart';

class SourceFormPage extends StatelessWidget {
  const SourceFormPage({super.key, this.id});

  final int? id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceVariant = colorScheme.surfaceVariant;
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Consumer(builder: (context, ref, child) {
            final source = ref.watch(formSourceProvider);
            return Card(
              color: surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '名称',
                    value: source.name,
                    onChange: (value) => updateName(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '网址',
                    value: source.url,
                    onChange: (value) => updateUrl(ref, value),
                  )
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Card(
            color: surfaceVariant,
            elevation: 0,
            child: Column(
              children: [
                RuleTile(
                  bordered: false,
                  title: '高级',
                  onTap: () => navigate(context, 'advanced-configuration'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: surfaceVariant,
            elevation: 0,
            child: Column(
              children: [
                RuleTile(
                  title: '搜索',
                  onTap: () => navigate(context, 'search-configuration'),
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
              ],
            ),
          ),
          const SizedBox(height: 8),
          Consumer(builder: (context, ref, child) {
            final source = ref.watch(formSourceProvider);
            return Card(
              color: surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '发现',
                    value: source.exploreJson,
                    onChange: (value) => updateExploreJson(ref, value),
                  ),
                ],
              ),
            );
          }),
          Consumer(builder: (context, ref, child) {
            final source = ref.watch(formSourceProvider);
            if (source.id.isNegative) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
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
        const SourceFormAdvancedConfigurationPageRoute().push(context);
        break;
      case 'search-configuration':
        const SourceFormSearchConfigurationPageRoute().push(context);
        break;
      case 'information-configuration':
        const SourceFormInformationConfigurationPageRoute().push(context);
        break;
      case 'catalogue-configuration':
        const SourceFormCatalogueConfigurationPageRoute().push(context);
        break;
      case 'content-configuration':
        const SourceFormContentConfigurationPageRoute().push(context);
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
