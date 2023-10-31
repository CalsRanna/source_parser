import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceCatalogueConfiguration extends StatelessWidget {
  const BookSourceCatalogueConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('目录配置')),
      body: CreatorWatcher<Source>(
        builder: (context, source) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
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
                    onChange: (value) => updateCataloguePreset(context, value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '目录列表规则',
                    value: source.catalogueChapters,
                    onChange: (value) =>
                        updateCatalogueChapters(context, value),
                  ),
                  RuleTile(
                    title: '章节名称规则',
                    value: source.catalogueName,
                    onChange: (value) => updateCatalogueName(context, value),
                  ),
                  RuleTile(
                    title: '更新时间规则',
                    value: source.catalogueUpdatedAt,
                    onChange: (value) =>
                        updateCatalogueUpdatedAt(context, value),
                  ),
                  RuleTile(
                    title: '章节URL规则',
                    value: source.catalogueUrl,
                    onChange: (value) => updateCatalogueUrl(context, value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '下一页URL规则',
                    value: source.cataloguePagination,
                    onChange: (value) =>
                        updateCataloguePagination(context, value),
                  ),
                  RuleTile(
                    title: '校验规则',
                    value: source.cataloguePaginationValidation,
                    onChange: (value) =>
                        updateCataloguePaginationValidation(context, value),
                  ),
                ],
              ),
            ),
          ],
        ),
        creator: currentSourceCreator,
      ),
    );
  }

  void updateCataloguePreset(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(cataloguePreset: value));
  }

  void selectMethod(BuildContext context) {
    const methods = ['get', 'post'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(methods[index]),
              onTap: () => confirmSelect(context, methods[index]),
            );
          },
          itemCount: methods.length,
        );
      },
    );
  }

  void confirmSelect(BuildContext context, String method) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(catalogueMethod: method));
    Navigator.of(context).pop();
  }

  void updateCatalogueChapters(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(catalogueChapters: value));
  }

  void updateCatalogueName(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(catalogueName: value));
  }

  void updateCatalogueUrl(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(catalogueUrl: value));
  }

  void updateCatalogueUpdatedAt(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(catalogueUpdatedAt: value));
  }

  void updateCataloguePagination(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(cataloguePagination: value));
  }

  void updateCataloguePaginationValidation(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(
      currentSourceCreator,
      source.copyWith(cataloguePaginationValidation: value),
    );
  }
}
