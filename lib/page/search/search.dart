import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:source_parser/creator/history.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/widget/message.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cancel = TextButton(
      onPressed: () => pop(context),
      child: Text(
        '取消',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
    final Widget body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmitterWatcher<List<History>>(
              builder: (context, histories) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('热门搜索'),
                  const SizedBox(height: 8),
                  Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: histories
                          .map((history) => ActionChip(
                                label: Text(history.name ?? ''),
                                labelPadding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onPressed: () {},
                              ))
                          .toList()),
                ],
              ),
              emitter: hotHistoriesEmitter,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [cancel],
        centerTitle: false,
        leading: const SizedBox(),
        leadingWidth: 16,
        title: _SearchInput(),
        titleSpacing: 0,
      ),
      body: body,
    );
  }

  void pop(BuildContext context) {
    context.pop();
  }

  void search(BuildContext context, String credential) async {
    try {} catch (e) {
      Message.of(context).show(e.toString());
    }
  }
}

class _SearchInput extends StatelessWidget {
  _SearchInput({Key? key}) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              cursorHeight: 14,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: '输入查询关键字',
                hintStyle: TextStyle(fontSize: 14, height: 1),
              ),
              style: const TextStyle(fontSize: 14),
              textInputAction: TextInputAction.search,
              onEditingComplete: () => search(context),
            ),
          ),
        ],
      ),
    );
  }

  void search(BuildContext context) async {
    try {} catch (e) {
      Message.of(context).show(e.toString());
    }
  }
}
