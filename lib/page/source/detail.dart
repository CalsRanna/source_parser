import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceInformation extends StatelessWidget {
  const BookSourceInformation({super.key, this.id});

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
          IconButton(
            onPressed: () => storeBookSource(context),
            icon: const Icon(Icons.check_outlined),
          ),
        ],
        centerTitle: true,
        title: Watcher((context, ref, child) {
          final source = ref.watch(currentSourceCreator);
          final prefix = source.id.isNegative ? '新建' : '编辑';
          return Text('$prefix书源');
        }),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Watcher((context, ref, child) {
            final source = ref.watch(currentSourceCreator);
            return Card(
              color: surfaceVariant,
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
          Watcher((context, ref, child) {
            final source = ref.watch(currentSourceCreator);
            return Card(
              color: surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '发现',
                    value: source.exploreJson,
                    onChange: (value) => updateExploreJson(context, value),
                  ),
                ],
              ),
            );
          }),
          Watcher((context, ref, child) {
            final source = ref.watch(currentSourceCreator);
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

  Future<bool> validate(BuildContext context) async {
    final ref = context.ref;
    final message = Message.of(context);
    final source = ref.read(currentSourceCreator);
    if (source.name.isEmpty) {
      message.show('名称不能为空');
      return false;
    }
    if (source.url.isEmpty) {
      message.show('网址不能为空');
      return false;
    }
    final filter = isar.sources.filter();
    var builder = filter.nameEqualTo(source.name);
    final exist = await builder.findFirst();
    if (exist != null && exist.id != source.id) {
      message.show('书源名称已存在');
      return false;
    }
    return true;
  }

  void storeBookSource(BuildContext context) async {
    final ref = context.ref;
    final message = Message.of(context);
    final source = ref.read(currentSourceCreator);
    final valid = await validate(context);
    if (!valid) return;
    isar.writeTxn(() async {
      final id = await isar.sources.put(source);
      ref.set(currentSourceCreator, source.copyWith(id: id));
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

  void updateExploreJson(BuildContext context, String json) async {
    final ref = context.ref;
    final source = ref.read(currentSourceCreator);
    ref.set(currentSourceCreator, source.copyWith(exploreJson: json));
  }

  void navigate(BuildContext context, String route) {
    context.push('/book-source/$route');
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
            TextButton(
              onPressed: () => confirmDelete(context),
              child: const Text('确认'),
            ),
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

  void confirmDelete(BuildContext context) async {
    Navigator.of(context).pop();
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
