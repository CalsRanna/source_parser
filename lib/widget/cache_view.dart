import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path_provider/path_provider.dart';

class CacheView extends StatefulWidget {
  const CacheView({super.key});

  @override
  State<CacheView> createState() => _CacheViewState();
}

class _CacheViewState extends State<CacheView> {
  late Directory directory;
  List<FileSystemEntity> files = [];
  bool isRoot = true;

  Future<void> backward() async {
    final cacheDirectory = await getTemporaryDirectory();
    final parent = directory.parent;
    setState(() {
      directory = directory.parent;
      files = directory.listSync();
      isRoot = parent.path == cacheDirectory.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 64) / 3;
    final ratio = width / (width + 52);
    List<Widget>? actions = [];
    final iconButton = IconButton(
      onPressed: backward,
      icon: const Icon(HugeIcons.strokeRoundedArrowUp01),
    );
    if (!isRoot) actions = [iconButton];
    final delegate = SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: ratio,
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    );
    final gridView = GridView.builder(
      gridDelegate: delegate,
      itemBuilder: (context, index) => _itemBuilder(files[index], width),
      itemCount: files.length,
      padding: const EdgeInsets.all(16),
    );
    return Scaffold(
      appBar: AppBar(actions: actions, title: const Text('Cached View')),
      body: gridView,
    );
  }

  void fetchFiles() async {
    final cacheDirectory = await getTemporaryDirectory();
    setState(() {
      directory = cacheDirectory;
      files = cacheDirectory.listSync();
    });
  }

  void forward(FileSystemEntity entity) {
    if (!isDirectory(entity)) return;
    setState(() {
      directory = Directory(entity.path);
      files = Directory(entity.path).listSync();
      isRoot = false;
    });
  }

  String getDate(FileSystemEntity entity) {
    final date = entity.statSync().changed;
    return '${date.year}/${date.month}/${date.day}';
  }

  String getName(FileSystemEntity entity) {
    return entity.path.split('/').last;
  }

  String getSize(FileSystemEntity entity) {
    final size = entity.statSync().size;
    return switch (size) {
      < 1024 => '$size Bytes',
      < 1024 * 1024 => '${(size / 1024).toStringAsFixed(2)} KB',
      _ => '${(size / 1024 / 1024).toStringAsFixed(2)} MB'
    };
  }

  @override
  void initState() {
    fetchFiles();
    super.initState();
  }

  bool isDirectory(FileSystemEntity entity) {
    final stat = entity.statSync();
    return stat.type == FileSystemEntityType.directory;
  }

  Widget _itemBuilder(FileSystemEntity entity, double width) {
    IconData icon = HugeIcons.strokeRoundedFile01;
    String name = getName(entity);
    String date = getDate(entity);
    String size = getSize(entity);
    if (isDirectory(entity)) icon = HugeIcons.strokeRoundedFolder01;
    final style =
        TextStyle(color: Colors.black.withValues(alpha: 0.4), fontSize: 12);
    final children = [
      Icon(icon, color: Colors.black.withValues(alpha: 0.4), size: width),
      Text(name, maxLines: 2, overflow: TextOverflow.ellipsis),
      if (!isDirectory(entity)) Text(date, maxLines: 1, style: style),
      if (!isDirectory(entity)) Text(size, maxLines: 1, style: style),
    ];
    final child = DefaultTextStyle.merge(
      style: const TextStyle(fontSize: 14, height: 1),
      textAlign: TextAlign.center,
      child: Column(children: children),
    );
    return GestureDetector(onTap: () => forward(entity), child: child);
  }
}
