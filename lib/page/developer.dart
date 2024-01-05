import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';

class Developer extends StatelessWidget {
  const Developer({super.key});

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
              onTap: () {},
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
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('清空'),
            ),
          ],
          content: const Text('确定清空数据库吗？'),
          title: const Text('清空数据库'),
        );
      },
      context: context,
    );
  }

  void showCacheViewer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CacheView()),
    );
  }
}
