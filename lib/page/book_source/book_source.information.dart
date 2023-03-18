import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/source.dart';
import 'package:source_parser/state/global.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/message.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceInformation extends StatelessWidget {
  const BookSourceInformation({Key? key}) : super(key: key);

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
        centerTitle: true,
        title: EmitterWatcher<Source>(
          builder: (context, source) => const Text('新建书源'),
          emitter: sourceEmitter(null),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          EmitterWatcher<Source>(
            emitter: sourceEmitter(null),
            builder: (context, source) => Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              child: Column(
                children: [
                  RuleTile(
                    title: '名称',
                    value: source.name,
                    onChange: (value) => updateName(context, value),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '网址',
                    value: source.url,
                    onChange: (value) => updateUrl(context, value),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
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
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
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
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          )
        ],
      ),
    );
  }

  void storeBookSource(BuildContext context) async {
    final ref = context.ref;
    final messager = Message.of(context);
    final isar = await ref.read(isarEmitter);
    final source = await ref.read(sourceEmitter(null));
    isar.writeTxn(() async {
      await isar.sources.put(source);
      messager.show('书源保存成功');
    });
  }

  void updateName(BuildContext context, String name) async {
    final ref = context.ref;
    final source = await ref.read(sourceEmitter(null));
    source.name = name;
    ref.emit(sourceEmitter(null), source);
  }

  void updateUrl(BuildContext context, String url) async {
    final ref = context.ref;
    final source = await ref.read(sourceEmitter(null));
    source.url = url;
    ref.emit(sourceEmitter(null), source);
  }

  // void updateType(BuildContext context, Ref ref) async {
  //   var type = await showMaterialModalBottomSheet(
  //     context: context,
  //     builder: (context) => _SourceTypeModalBottomSheet(),
  //   );
  //   ref.update<BookSource?>(
  //       bookSourceCreator, (source) => source?.copyWith(type: type));
  // }

  void navigate(BuildContext context, String route) {
    context.push('/book-source/$route');
  }
}

// class _SourceTypeModalBottomSheet extends StatelessWidget {
//   _SourceTypeModalBottomSheet({Key? key}) : super(key: key);

//   final List<String> types = ['文本', '图片', '音频', '视频'];

//   @override
//   Widget build(BuildContext context) {
//     var children = <Widget>[];
//     for (var i = 0; i < types.length; i++) {
//       children.add(
//         ListTile(
//           title: Text(types[i]),
//           onTap: () => Navigator.of(context).pop(i),
//         ),
//       );
//     }

//     return Material(
//       child: SafeArea(
//         top: false,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: children,
//         ),
//       ),
//     );
//   }
// }
