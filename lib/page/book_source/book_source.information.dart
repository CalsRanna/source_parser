import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../database/database.dart';
import '../../entity/book_source.dart';
import '../../entity/rule.dart';
import '../../state/global.dart';
import '../../state/source.dart';
import '../../widget/action_button.dart';
import '../../widget/bordered_card.dart';
import '../../widget/message.dart';
import '../../widget/rule_tile.dart';

class BookSourceInformation extends StatelessWidget {
  BookSourceInformation({Key? key, this.id}) : super(key: key);

  final int? id;

  final List<String> types = ['文本', '图片', '音频', '视频'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Watcher(
            (context, ref, _) => ActionButton(
              text: '保存',
              onTap: () => storeBookSource(context, ref),
            ),
          )
        ],
        title: Text(id != null ? '编辑源' : '新建源'),
      ),
      body: ListView(
        children: [
          BorderedCard(
            title: '基本信息',
            child: Column(
              children: [
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '书源名称',
                    value: ref.watch(bookSourceCreator)?.name,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(name: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '网址',
                    value: ref.watch(bookSourceCreator)?.url,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(url: value),
                    ),
                  ),
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    title: '类型',
                    trailing:
                        Text(types[ref.watch(bookSourceCreator)?.type ?? 0]),
                    onTap: () => updateType(context, ref),
                  ),
                ),
                RuleTile(
                  title: '高级配置',
                  onTap: () => navigate(context, 'advanced-configuration'),
                ),
                InkWell(
                  onTap: () => debugSource(context),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    width: double.infinity,
                    child: Text(
                      '调试',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          BorderedCard(
            title: '查找配置',
            child: Column(
              children: [
                RuleTile(
                  title: '搜索',
                  onTap: () => navigate(context, 'search-configuration'),
                ),
                RuleTile(
                  bordered: false,
                  title: '发现',
                  onTap: () => navigate(context, 'explore-configuration'),
                ),
              ],
            ),
          ),
          BorderedCard(
            title: '内容配置',
            child: Column(
              children: [
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
        ],
      ),
    );
  }

  void storeBookSource(BuildContext context, Ref ref) async {
    final database = ref.read(databaseCreator);
    final source = ref.read(bookSourceCreator);
    final searchRule = ref.read(searchRuleCreator);
    final exploreRule = ref.read(exploreRuleCreator);
    final informationRule = ref.read(informationRuleCreator);
    final catalogueRule = ref.read(catalogueRuleCreator);
    final contentRule = ref.read(contentRuleCreator);
    if (source == null) {
      Message.of(context).show('书源不能为空');
    } else {
      var messager = Message.of(context);
      if (id == null) {
        await database?.bookSourceDao.insertBookSource(source);
      } else {
        await database?.bookSourceDao.updateBookSource(source);
      }
      storeRule(database!, source, searchRule!.toJson());
      storeRule(database, source, exploreRule!.toJson());
      storeRule(database, source, informationRule!.toJson());
      storeRule(database, source, catalogueRule!.toJson());
      storeRule(database, source, contentRule!.toJson());
      messager.show('书源保存成功');
    }
  }

  void storeRule(
    AppDatabase database,
    BookSource source,
    Map<String, String?> rule,
  ) async {
    final sourceDao = database.bookSourceDao;
    final ruleDao = database.ruleDao;
    final keys = rule.keys.toList();
    if (id == null) {
      var record = await sourceDao.findBookSourceByName(source.name);
      if (record != null) {
        for (var i = 0; i < keys.length; i++) {
          await ruleDao.insertRule(Rule.bean(
            name: keys[i],
            value: rule[keys[i]],
            sourceId: record.id,
          ));
        }
      }
    } else {
      for (var i = 0; i < keys.length; i++) {
        final record = await ruleDao.getRuleByNameAndSourceId(keys[i], id!);
        if (record != null) {
          await ruleDao.updateRule(Rule.bean(
            id: record.id,
            name: keys[i],
            value: rule[keys[i]],
            sourceId: id,
          ));
        } else {
          await ruleDao.insertRule(Rule.bean(
            name: keys[i],
            value: rule[keys[i]],
            sourceId: id,
          ));
        }
      }
    }
  }

  void updateType(BuildContext context, Ref ref) async {
    var type = await showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _SourceTypeModalBottomSheet(),
    );
    ref.update<BookSource?>(
        bookSourceCreator, (source) => source?.copyWith(type: type));
  }

  void navigate(BuildContext context, String route) {
    context.push('/book-source/$route');
  }

  void debugSource(BuildContext context) async {
    context.push('/book-source/debug');
  }
}

class _SourceTypeModalBottomSheet extends StatelessWidget {
  _SourceTypeModalBottomSheet({Key? key}) : super(key: key);

  final List<String> types = ['文本', '图片', '音频', '视频'];

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (var i = 0; i < types.length; i++) {
      children.add(
        ListTile(
          title: Text(types[i]),
          onTap: () => Navigator.of(context).pop(i),
        ),
      );
    }

    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
