import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class SourceCatalogueConfigurationPage extends StatelessWidget {
  const SourceCatalogueConfigurationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('目录配置')),
      body: Consumer(builder: (context, ref, child) {
        final source = ref.watch(formSourceProvider);
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '请求方法',
                    value: source.catalogueMethod,
                    onTap: () => selectMethod(context),
                  ),
                  RuleTile(
                    placeholder: '解析后的值使用{{preset}}代替，仅章节URL规则可用',
                    title: '预设',
                    value: source.cataloguePreset,
                    onChange: (value) => updateCataloguePreset(ref, value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '目录列表规则',
                    value: source.catalogueChapters,
                    onChange: (value) => updateCatalogueChapters(ref, value),
                  ),
                  RuleTile(
                    title: '章节名称规则',
                    value: source.catalogueName,
                    onChange: (value) => updateCatalogueName(ref, value),
                  ),
                  RuleTile(
                    title: '更新时间规则',
                    value: source.catalogueUpdatedAt,
                    onChange: (value) => updateCatalogueUpdatedAt(ref, value),
                  ),
                  RuleTile(
                    title: '章节URL规则',
                    value: source.catalogueUrl,
                    onChange: (value) => updateCatalogueUrl(ref, value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '下一页URL规则',
                    value: source.cataloguePagination,
                    onChange: (value) => updateCataloguePagination(ref, value),
                  ),
                  RuleTile(
                    title: '校验规则',
                    value: source.cataloguePaginationValidation,
                    onChange: (value) =>
                        updateCataloguePaginationValidation(ref, value),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void updateCataloguePreset(WidgetRef ref, String cataloguePreset) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(cataloguePreset: cataloguePreset));
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
      BuildContext context, WidgetRef ref, String catalogueMethod) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(catalogueMethod: catalogueMethod));
    Navigator.of(context).pop();
  }

  void updateCatalogueChapters(WidgetRef ref, String catalogueChapters) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(catalogueChapters: catalogueChapters));
  }

  void updateCatalogueName(WidgetRef ref, String catalogueName) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(catalogueName: catalogueName));
  }

  void updateCatalogueUrl(WidgetRef ref, String catalogueUrl) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(catalogueUrl: catalogueUrl));
  }

  void updateCatalogueUpdatedAt(WidgetRef ref, String catalogueUpdatedAt) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(catalogueUpdatedAt: catalogueUpdatedAt));
  }

  void updateCataloguePagination(WidgetRef ref, String cataloguePagination) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(cataloguePagination: cataloguePagination));
  }

  void updateCataloguePaginationValidation(
      WidgetRef ref, String cataloguePaginationValidation) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(
        cataloguePaginationValidation: cataloguePaginationValidation));
  }
}
