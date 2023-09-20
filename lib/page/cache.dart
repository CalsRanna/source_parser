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
          final size = getSize(cache);
          return ListTile(
            title: Text(name),
            trailing: Text(size),
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
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('清空缓存'),
          content: const Text('确定清空所有已缓存的内容？'),
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
        );
      },
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
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除缓存'),
          content: const Text('确认删除本书所有缓存？'),
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
        );
      },
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

  String getSize(FileSystemEntity entity) {
    final files = Directory(entity.path).listSync(recursive: true);
    var size = files.fold(0, (value, file) => value + file.statSync().size);
    String string;
    if (size < 1024) {
      string = '$size Bytes';
    } else if (size >= 1024 && size < 1024 * 1024) {
      string = '${(size / 1024).toStringAsFixed(2)} KB';
    } else {
      string = '${(size / 1024 / 1024).toStringAsFixed(2)} MB';
    }
    return string;
  }
}
