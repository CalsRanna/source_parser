import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/provider/file.dart';
import 'package:source_parser/widget/loading.dart';

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
      AsyncError(:final error) => Center(child: Text(error.toString())),
      AsyncLoading() => const Center(child: LoadingIndicator()),
      _ => const SizedBox(),
    };
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (paths.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  paths.removeLast();
                  if (paths.isEmpty) {
                    directory = null;
                  } else {
                    directory = paths.last;
                  }
                });
              },
              icon: Icon(HugeIcons.strokeRoundedArrowUp01),
            )
        ],
        title: Text('File Manager'),
      ),
      body: body,
    );
  }

  Widget _buildData(List<FileSystemEntity> files) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 5,
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        var file = files[index];
        var icon = HugeIcons.strokeRoundedFile01;
        if (file is Directory) {
          icon = HugeIcons.strokeRoundedFolder01;
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (file is Directory) {
              setState(() {
                directory = file.path;
                paths.add(directory!);
              });
            }
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text('Delete'),
                    content:
                        Text('Are you sure you want to delete ${file.path}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          file.deleteSync(recursive: true);
                          setState(() {
                            directory = null;
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                      )
                    ]);
              },
            );
          },
          child: Column(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return Icon(
                  icon,
                  size: constraints.maxWidth,
                );
              }),
              Text(
                file.path.split('/').last,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (file is File) Text(_formatSize(file.statSync().size)),
            ],
          ),
        );
      },
      itemCount: files.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
    );
    // return ListView.builder(
    //   itemBuilder: (context, index) {
    //     var file = files[index];
    //     return ListTile(
    //         title: Text(file.path),
    //         onTap: () {
    //           if (file is Directory) {
    //             setState(() {
    //               directory = file.path;
    //             });
    //           }
    //         });
    //   },
    //   itemCount: files.length,
    // );
  }

  Widget _buildLoading() {
    return const Center(child: LoadingIndicator());
  }

  String _formatSize(int size) {
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
