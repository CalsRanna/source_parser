import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/provider/file.dart';

@RoutePage()
class FileManagerPage extends ConsumerStatefulWidget {
  const FileManagerPage({super.key});

  @override
  ConsumerState<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends ConsumerState<FileManagerPage> {
  String? directory;
  List<String> paths = [];
  @override
  Widget build(BuildContext context) {
    var provider = filesProvider(directory);
    var state = ref.watch(provider);
    var body = switch (state) {
      AsyncData(:final value) => _buildData(value),
      AsyncError(:final error) => _buildError(error),
      _ => const SizedBox(),
    };
    var title = '文件管理';
    if (directory != null) {
      title = directory!.split('/').last;
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  void enterDirectory(FileSystemEntity file) {
    if (file is Directory) {
      setState(() {
        directory = file.path;
        paths.add(directory!);
      });
    }
  }

  void navigateUp() {
    setState(() {
      paths.removeLast();
      if (paths.isEmpty) {
        directory = null;
      } else {
        directory = paths.last;
      }
    });
  }

  void openDialog(FileSystemEntity file) {
    HapticFeedback.heavyImpact();
    var actions = [
      TextButton(onPressed: _handleCancel, child: Text('Cancel')),
      TextButton(onPressed: () => _handleConfirm(file), child: Text('Delete'))
    ];
    var title = 'Delete File';
    if (file is Directory) title = 'Delete Directory';
    var alertDialog = AlertDialog(
      actions: actions,
      content: Text('Are you sure you want to delete "${file.path}"?'),
      title: Text(title),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Widget _buildData(List<FileSystemEntity> files) {
    if (files.isEmpty) {
      var child = Padding(
        padding: const EdgeInsets.all(16),
        child: Text('No files found'),
      );
      return Center(child: child);
    }
    const delegate = SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: 2 / 3,
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    );
    return GridView.builder(
      gridDelegate: delegate,
      itemBuilder: (_, index) => _itemBuilder(files[index]),
      itemCount: files.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildError(Object error) {
    var child = Padding(
      padding: const EdgeInsets.all(16),
      child: Text(error.toString()),
    );
    return Center(child: child);
  }

  Widget? _buildFloatingActionButton() {
    Widget? floatingActionButton;
    if (paths.isNotEmpty) {
      floatingActionButton = FloatingActionButton(
        onPressed: navigateUp,
        child: Icon(HugeIcons.strokeRoundedArrowUp01),
      );
    }
    return floatingActionButton;
  }

  String _formatSize(int size) {
    String string;
    if (size < 1024) {
      string = '$size B';
    } else if (size >= 1024 && size < 1024 * 1024) {
      string = '${(size / 1024).toStringAsFixed(2)} KB';
    } else {
      string = '${(size / 1024 / 1024).toStringAsFixed(2)} MB';
    }
    return string;
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleConfirm(FileSystemEntity file) {
    file.deleteSync(recursive: true);
    setState(() {
      directory = null;
    });
    var provider = filesProvider(directory);
    ref.invalidate(provider);
    Navigator.pop(context);
  }

  Widget _itemBuilder(FileSystemEntity file) {
    var icon = HugeIcons.strokeRoundedFile01;
    if (file is Directory) {
      icon = HugeIcons.strokeRoundedFolder01;
    }
    var color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
    var fileIcon = LayoutBuilder(builder: (_, constraints) {
      return Icon(icon, color: color, size: constraints.maxWidth);
    });
    var nameText = Text(
      file.path.split('/').last,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    var sizeText = Text(_formatSize(file.statSync().size));
    var children = [fileIcon, nameText, if (file is File) sizeText];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => openDialog(file),
      onTap: () => enterDirectory(file),
      child: Column(children: children),
    );
  }
}
