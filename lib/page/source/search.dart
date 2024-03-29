import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class SourceSearchConfigurationPage extends StatelessWidget {
  const SourceSearchConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('搜索配置')),
      body: Consumer(builder: (context, ref, child) {
        final source = ref.watch(formSourceProvider);
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '搜索URL',
                    value: source.searchUrl,
                    onChange: (value) => updateSearchUrl(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '请求方法',
                    value: source.searchMethod,
                    onTap: () => selectMethod(context),
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
                    bordered: false,
                    title: '书籍列表规则',
                    value: source.searchBooks,
                    onChange: (value) => updateSearchBooks(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '作者规则',
                    value: source.searchAuthor,
                    onChange: (value) => updateSearchAuthor(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '分类规则',
                    value: source.searchCategory,
                    onChange: (value) => updateSearchCategory(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '封面规则',
                    value: source.searchCover,
                    onChange: (value) => updateSearchCover(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '简介规则',
                    value: source.searchIntroduction,
                    onChange: (value) => updateSearchIntroduction(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '最新章节规则',
                    value: source.searchLatestChapter,
                    onChange: (value) => updateSearchLatestChapter(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '书名规则',
                    value: source.searchName,
                    onChange: (value) => updateSearchName(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '详情URL规则',
                    value: source.searchInformationUrl,
                    onChange: (value) => updateSearchInformationUrl(ref, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '字数规则',
                    value: source.searchWordCount,
                    onChange: (value) => updateSearchWordCount(ref, value),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void updateSearchUrl(WidgetRef ref, String searchUrl) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchUrl: searchUrl));
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

  void confirmSelect(BuildContext context, WidgetRef ref, String searchMethod) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchMethod: searchMethod));
    Navigator.of(context).pop();
  }

  void updateSearchBooks(WidgetRef ref, String searchBooks) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchBooks: searchBooks));
  }

  void updateSearchName(WidgetRef ref, String searchName) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchName: searchName));
  }

  void updateSearchAuthor(WidgetRef ref, String searchAuthor) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchAuthor: searchAuthor));
  }

  void updateSearchCategory(WidgetRef ref, String searchCategory) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchCategory: searchCategory));
  }

  void updateSearchWordCount(WidgetRef ref, String searchWordCount) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchWordCount: searchWordCount));
  }

  void updateSearchIntroduction(WidgetRef ref, String searchIntroduction) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchIntroduction: searchIntroduction));
  }

  void updateSearchCover(WidgetRef ref, String searchCover) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchCover: searchCover));
  }

  void updateSearchInformationUrl(WidgetRef ref, String searchInformationUrl) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier
        .update(source.copyWith(searchInformationUrl: searchInformationUrl));
  }

  void updateSearchLatestChapter(WidgetRef ref, String searchLatestChapter) {
    final source = ref.read(formSourceProvider);
    final notifier = ref.read(formSourceProvider.notifier);
    notifier.update(source.copyWith(searchLatestChapter: searchLatestChapter));
  }
}
