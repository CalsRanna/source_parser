import 'dart:io';

import 'package:creator/creator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:source_parser/model/book_source.dart';
import 'package:source_parser/model/rule.dart';
import 'package:source_parser/state/global.dart';
import 'package:source_parser/state/source.dart';
import 'package:source_parser/util/generator.dart';
import 'package:source_parser/util/get_by.dart';

class BookSourceList extends StatelessWidget {
  BookSourceList({Key? key}) : super(key: key);

  final icons = [
    Icons.add_outlined,
    Icons.folder_outlined,
    Icons.language_outlined,
    Icons.qr_code_outlined,
    Icons.ios_share_outlined,
    Icons.fingerprint_outlined,
  ];
  final labels = ['新建', '本地导入', '网络导入', '二维码导入', '导出', '校验'];
  final values = [
    'create',
    'import?by=locale',
    'import?by=internet',
    'import?by=qr-code',
    'export',
    'validate',
  ];

  @override
  Widget build(BuildContext context) {
    var items = <PopupMenuItem<String>>[];
    for (var i = 0; i < icons.length; i++) {
      items.add(PopupMenuItem(
        value: values[i],
        child: Row(children: [
          Icon(icons[i], color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(labels[i]),
        ]),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Watcher(
            (context, ref, _) => PopupMenuButton<String>(
              icon: const Icon(CupertinoIcons.ellipsis_vertical),
              itemBuilder: (context) => items,
              offset: const Offset(0, 64),
              onSelected: (value) => handleChange(context, ref, value),
            ),
          ),
        ],
        title: const Text('书源管理'),
      ),
      body: Watcher((context, ref, _) {
        if (AsyncDataStatus.waiting ==
            ref.watch(bookSourcesCreator.asyncData).status) {
          return const Center(child: CupertinoActivityIndicator());
        } else {
          var sources = ref.watch(bookSourcesCreator.asyncData).data;
          if (sources == null || sources.isEmpty) {
            return const Center(child: Text('暂无书源'));
          } else {
            return ReorderableListView.builder(
              itemCount: sources.length,
              itemBuilder: (context, index) {
                return SourceTile(
                  key: ValueKey('source-$index'),
                  source: sources[index],
                  onTap: (id) => handleTap(context, ref, id),
                );
              },
              onReorder: (oldIndex, newIndex) =>
                  handleReorder(ref, oldIndex, newIndex),
            );
          }
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/book-source/create'),
        child: const Icon(Icons.add_outlined),
      ),
    );
  }

  void handleChange(BuildContext context, Ref ref, String? value) async {
    if (value == 'export') {
      File file = File(path.join(
          ref.read(cacheDirectoryEmitter.asyncData).data!, 'sources.pbs'));
      final database = ref.read(databaseEmitter.asyncData).data;
      final json = await Generator.sourcesJson(database!);
      await file.writeAsBytes(json.codeUnits);
      // Share.shareXFiles([file.path], subject: 'sources.pbs');
    } else if (value == 'import?by=locale') {
      var result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final file = File(result.files.single.path!);
        await file.readAsBytes();
      } else {}
    } else {
      ref.set(bookSourceCreator, BookSource.bean());
      ref.set(searchRuleCreator, SearchRule.bean());
      ref.set(exploreRuleCreator, ExploreRule.bean());
      ref.set(informationRuleCreator, InformationRule.bean());
      ref.set(catalogueRuleCreator, CatalogueRule.bean());
      ref.set(contentRuleCreator, ContentRule.bean());
      context.push('/book-source/$value');
    }
  }

  void handleTap(BuildContext context, Ref ref, int id) async {
    var navigator = GoRouter.of(context);
    var database = ref.watch(databaseEmitter.asyncData).data;
    var source = await database?.bookSourceDao.getBookSource(id);
    var rules = await database?.ruleDao.getRulesBySourceId(id);
    ref.set(bookSourceCreator, source);
    ref.set(searchRuleCreator, SearchRule.fromJson(rules?.toJson() ?? {}));
    ref.set(exploreRuleCreator, ExploreRule.fromJson(rules?.toJson() ?? {}));
    ref.set(informationRuleCreator,
        InformationRule.fromJson(rules?.toJson() ?? {}));
    ref.set(
        catalogueRuleCreator, CatalogueRule.fromJson(rules?.toJson() ?? {}));
    ref.set(contentRuleCreator, ContentRule.fromJson(rules?.toJson() ?? {}));
    navigator.push('/book-source/information/$id');
  }

  void handleReorder(Ref ref, int oldIndex, int newIndex) {
    // var sources =
    //     ref.watch(bookSourceState.select((value) => value.bookSources));
    // if (newIndex > oldIndex) newIndex--;
    // final source = sources?.removeAt(oldIndex);
    // sources?.insert(newIndex, source!);
    // ref.read(bookSourceState.notifier).updateBookSources(sources!);
  }

  void initBookSources(Ref ref) async {
    // var database = ref.watch(globalState.select((value) => value.database));
    // var bookSources = await database?.bookSourceDao.getAllBookSources();
    // ref.watch(bookSourceState.notifier).updateBookSources(bookSources!);
  }
}

class SourceTile extends StatelessWidget {
  const SourceTile({Key? key, required this.source, this.onTap})
      : super(key: key);

  final BookSource source;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    var color = Colors.black;
    if (!source.enabled) {
      color = Colors.grey;
    }

    return InkWell(
      onTap: handleTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color),
                child: Text(source.name, style: const TextStyle(fontSize: 16)),
              ),
            ),
            IconTheme.merge(
              data: IconThemeData(
                color: Theme.of(context).primaryColor,
                size: 12,
              ),
              child: Row(
                children: [
                  if (source.enabled) const Icon(Icons.search_outlined),
                  if (source.exploreEnabled == true) const SizedBox(width: 8),
                  if (source.exploreEnabled == true)
                    const Icon(Icons.explore_outlined)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleTap() {
    onTap?.call(source.id!);
  }
}
