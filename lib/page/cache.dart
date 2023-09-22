import 'dart:io';

import 'package:cached_network/cached_network.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/util/message.dart';

class CacheList extends StatefulWidget {
  const CacheList({super.key});

  @override
  State<CacheList> createState() => _CacheListState();
}

class _CacheListState extends State<CacheList> {
  List<FileSystemEntity> caches = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: clearCache,
            icon: const Icon(Icons.delete_outline),
          )
        ],
        title: const Text('缓存'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final cache = caches[index];
          final name = getName(cache);
          return ListTile(
            title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: FutureBuilder(
                future: getSize(cache),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  } else {
                    return const SizedBox();
                  }
                }),
            onLongPress: () => _handleLongPress(name),
          );
        },
        itemCount: caches.length,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    final caches = await CachedNetwork().listCaches();
    setState(() {
      this.caches = caches;
    });
  }

  void clearCache() async {
    showDialog(
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: cancelClear,
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: confirmClear,
              child: const Text('确认'),
            ),
          ],
          content: const Text('确定清空所有已缓存的内容？'),
          title: const Text('清空缓存'),
        );
      },
      context: context,
    );
  }

  void cancelClear() {
    Navigator.of(context).pop();
  }

  void confirmClear() async {
    final navigator = Navigator.of(context);
    final message = Message.of(context);
    final succeed = await CachedNetwork().clearCache();
    navigator.pop();
    if (succeed) {
      message.show('已清空缓存');
      await _initState();
    } else {
      message.show('清空缓存失败');
    }
  }

  void _handleLongPress(String name) async {
    showDialog(
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: cancel,
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => confirm(name),
              child: const Text('确认'),
            ),
          ],
          content: const Text('确认删除本书所有缓存？'),
          title: const Text('删除缓存'),
        );
      },
      context: context,
    );
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  void confirm(String name) async {
    final navigator = Navigator.of(context);
    final message = Message.of(context);
    final succeed = await CachedNetwork(prefix: name).clearCache();
    navigator.pop();
    if (succeed) {
      message.show('已删除缓存');
      await _initState();
    } else {
      message.show('删除缓存失败');
    }
  }

  String getName(FileSystemEntity entity) {
    return entity.path.split('/').last;
  }

  Future<String> getSize(FileSystemEntity entity) async {
    final files = Directory(entity.path).listSync(recursive: true);
    List<int> sizes = [];
    for (var file in files) {
      final stat = await file.stat();
      sizes.add(stat.size);
    }
    final total = sizes.reduce((value, size) => value + size);
    String string;
    if (total < 1024) {
      string = '$total Bytes';
    } else if (total >= 1024 && total < 1024 * 1024) {
      string = '${(total / 1024).toStringAsFixed(2)} KB';
    } else {
      string = '${(total / 1024 / 1024).toStringAsFixed(2)} MB';
    }
    return string;
  }
}
