import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceInformation extends StatelessWidget {
  const BookSourceInformation({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const DebugButton(),
          IconButton(
            onPressed: () => storeBookSource(context),
            icon: const Icon(Icons.check_outlined),
          ),
        ],
        centerTitle: true,
        title: CreatorWatcher<Source>(
          builder: (context, source) {
            final prefix = id == null ? '新建' : '编辑';
            return Text('$prefix书源');
          },
          creator: currentSourceCreator,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CreatorWatcher<Source>(
            creator: currentSourceCreator,
            builder: (context, source) => Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '名称',
                    value: source.name,
                    onChange: (value) => updateName(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '网址',
                    value: source.url,
                    onChange: (value) => updateUrl(context, value),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
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
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
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
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
            child: Column(
              children: [
                RuleTile(
                  bordered: false,
                  title: '发现',
                  onTap: () => navigate(context, 'explore-configuration'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => handleTap(context),
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          )
        ],
      ),
    );
  }

  void storeBookSource(BuildContext context) async {
    final ref = context.ref;
    final message = Message.of(context);
    final source = ref.read(currentSourceCreator);
    isar.writeTxn(() async {
      await isar.sources.put(source);
      message.show('书源保存成功');
      final sources = await isar.sources.where().findAll();
      ref.emit(sourcesEmitter, [...sources]);
    });
  }

  void updateName(BuildContext context, String name) async {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(name: name));
  }

  void updateUrl(BuildContext context, String url) async {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(url: url));
  }

  void navigate(BuildContext context, String route) {
    context.push('/book-source/$route');
  }

  void handleTap(BuildContext context) async {
    final router = GoRouter.of(context);
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    isar.writeTxn(() async {
      await isar.sources.delete(source.id);
      final sources = await isar.sources.where().findAll();
      ref.emit(sourcesEmitter, sources);
      router.pop();
    });
  }
}
