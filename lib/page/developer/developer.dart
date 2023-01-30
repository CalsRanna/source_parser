import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/state/global.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

class Developer extends StatelessWidget {
  const Developer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('开发者选项')),
      body: Watcher(
        (context, ref, _) => ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ListTile(
              title: const Text('查看数据库'),
              onTap: () => showSqliteViewer(context, ref),
            ),
            ListTile(
              title: const Text('清空数据库'),
              onTap: () => emptyDatabase(context, ref),
            ),
            ListTile(
              title: const Text('缓存'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.withOpacity(0.5),
                size: 16,
              ),
              onTap: () => showCacheViewer(context),
            ),
          ],
        ),
      ),
    );
  }

  void emptyDatabase(BuildContext context, Ref ref) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空数据库'),
        content: const Text('确定清空数据库吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: (() => handleConfirm(context, ref)),
            child: const Text('清空'),
          ),
        ],
      ),
    );
  }

  void handleConfirm(BuildContext context, Ref ref) async {
    var navigator = Navigator.of(context);
    var database = ref.read(databaseEmitter.asyncData).data;
    await database?.bookSourceDao.emptyBookSources();
    await database?.ruleDao.emptyRules();
    navigator.pop();
  }

  void showSqliteViewer(BuildContext context, Ref ref) {
    final file = ref.read(databaseFileEmitter.asyncData).data;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DatabaseList(dbPath: file)),
    );
  }

  void showCacheViewer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CacheView()),
    );
  }
}
