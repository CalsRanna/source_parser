import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

import '../../state/global.dart';

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
    print(file);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DatabaseList(dbPath: file)),
    );
  }
}
