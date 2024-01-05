import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceSearchConfiguration extends StatelessWidget {
  const BookSourceSearchConfiguration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [DebugButton()], title: const Text('搜索配置')),
      body: Watcher((context, ref, child) {
        final source = ref.watch(currentSourceCreator);
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
                    onChange: (value) => updateSearchUrl(context, value),
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
                    onChange: (value) => updateSearchBooks(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '作者规则',
                    value: source.searchAuthor,
                    onChange: (value) => updateSearchAuthor(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '分类规则',
                    value: source.searchCategory,
                    onChange: (value) => updateSearchCategory(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '封面规则',
                    value: source.searchCover,
                    onChange: (value) => updateSearchCover(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '简介规则',
                    value: source.searchIntroduction,
                    onChange: (value) =>
                        updateSearchIntroduction(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '最新章节规则',
                    value: source.searchLatestChapter,
                    onChange: (value) =>
                        updateSearchLatestChapter(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '书名规则',
                    value: source.searchName,
                    onChange: (value) => updateSearchName(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '详情URL规则',
                    value: source.searchInformationUrl,
                    onChange: (value) =>
                        updateSearchInformationUrl(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '字数规则',
                    value: source.searchWordCount,
                    onChange: (value) => updateSearchWordCount(context, value),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void updateSearchUrl(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchUrl: value));
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
    ref.set(currentSourceCreator, source.copyWith(searchMethod: method));
    Navigator.of(context).pop();
  }

  void updateSearchBooks(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchBooks: value));
  }

  void updateSearchName(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchName: value));
  }

  void updateSearchAuthor(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchAuthor: value));
  }

  void updateSearchCategory(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchCategory: value));
  }

  void updateSearchWordCount(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchWordCount: value));
  }

  void updateSearchIntroduction(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchIntroduction: value));
  }

  void updateSearchCover(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchCover: value));
  }

  void updateSearchInformationUrl(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchInformationUrl: value));
  }

  void updateSearchLatestChapter(BuildContext context, String value) {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(searchLatestChapter: value));
  }
}
