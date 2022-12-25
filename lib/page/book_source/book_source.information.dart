import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:source_parser/database/database.dart';
import 'package:source_parser/model/book_source.dart';
import 'package:source_parser/model/rule.dart';
import 'package:source_parser/state/global.dart';
import 'package:source_parser/state/source.dart';
import 'package:source_parser/widget/bordered_card.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/message.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceInformation extends StatefulWidget {
  const BookSourceInformation({Key? key}) : super(key: key);

  @override
  State<BookSourceInformation> createState() {
    return _BookSourceInformationState();
  }
}

class _BookSourceInformationState extends State<BookSourceInformation> {
  late BookSource source;
  @override
  void didChangeDependencies() {
    source = context.ref.read(bookSourceCreator);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // const List<String> types = ['文本', '图片', '音频', '视频'];
    return Scaffold(
      appBar: AppBar(
        actions: [
          const DebugButton(),
          IconButton(
            onPressed: () => storeBookSource(context),
            icon: const Icon(Icons.check_outlined),
          ),
        ],
        title: Text(source.id != null ? '编辑书源' : '新建书源'),
      ),
      body: ListView(
        children: [
          BorderedCard(
            title: '基本信息',
            child: Column(
              children: [
                RuleTile(
                  title: '名称',
                  value: source.name,
                  onChange: (value) {
                    setState(() => source.name = value);
                    context.ref.set(bookSourceCreator, source);
                  },
                ),
                Watcher(
                  (context, ref, _) => RuleTile(
                    bordered: false,
                    title: '网址',
                    value: source.url,
                    onChange: (value) {
                      setState(() => source.url = value);
                      context.ref.set(bookSourceCreator, source);
                    },
                  ),
                ),
                // Watcher(
                //   (context, ref, _) => RuleTile(
                //     title: '类型',
                //     trailing:
                //         Text(types[source.type ?? 0]),
                //     onTap: () => updateType(context, ref),
                //   ),
                // ),
              ],
            ),
          ),
          BorderedCard(
            title: '高级信息',
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
          BorderedCard(
            title: '查找配置',
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
          BorderedCard(
            title: '内容配置',
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
          Watcher((context, ref, _) {
            if (source.id != null) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('删除', style: TextStyle(color: Colors.red)),
                ),
              );
            } else {
              return const SizedBox();
            }
          })
        ],
      ),
    );
  }

  void storeBookSource(BuildContext context) async {
    final ref = context.ref;
    final database = ref.read(databaseEmitter.asyncData).data;
    final source = ref.read(bookSourceCreator);
    final searchRule = ref.read(searchRuleCreator);
    final exploreRule = ref.read(exploreRuleCreator);
    final informationRule = ref.read(informationRuleCreator);
    final catalogueRule = ref.read(catalogueRuleCreator);
    final contentRule = ref.read(contentRuleCreator);
    var messager = Message.of(context);
    if (source.id == null) {
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

  void storeRule(
    AppDatabase database,
    BookSource source,
    Map<String, String?> rule,
  ) async {
    final sourceDao = database.bookSourceDao;
    final ruleDao = database.ruleDao;
    final keys = rule.keys.toList();
    if (source.id == null) {
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
        final record =
            await ruleDao.getRuleByNameAndSourceId(keys[i], source.id!);
        if (record != null) {
          await ruleDao.updateRule(Rule.bean(
            id: record.id,
            name: keys[i],
            value: rule[keys[i]],
            sourceId: source.id,
          ));
        } else {
          await ruleDao.insertRule(Rule.bean(
            name: keys[i],
            value: rule[keys[i]],
            sourceId: source.id,
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
