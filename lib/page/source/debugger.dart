import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/string_extension.dart';
import 'package:source_parser/page/source/component/rule_group_label.dart';

class SourceDebuggerPage extends StatefulWidget {
  const SourceDebuggerPage({super.key});

  @override
  State<StatefulWidget> createState() => _SourceDebuggerPageState();
}

class _DebugButton extends ConsumerWidget {
  const _DebugButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.bug_report_outlined),
      onPressed: () => debug(context, ref),
    );
  }

  void debug(BuildContext context, WidgetRef ref) async {
    try {
      final notifier = ref.read(sourceDebuggerProvider.notifier);
      notifier.debug();
    } catch (e) {
      final message = Message.of(context);
      message.show(e.toString());
    }
  }
}

class _JsonDataPage extends StatelessWidget {
  final String data;
  final String? title;
  const _JsonDataPage(this.data, {this.title});

  @override
  Widget build(BuildContext context) {
    final serializable = _canSerialize();
    if (!serializable) return _buildText();
    final json = jsonDecode(data);
    if (json is List) return _buildList(context, json);
    return _buildMap(context, json);
  }

  void handleTap(BuildContext context, String text, String title) {
    if (text.isEmpty) return;
    final page = _JsonDataPage(text, title: title);
    final route = MaterialPageRoute(builder: (_) => page);
    Navigator.of(context).push(route);
  }

  Widget _buildList(BuildContext context, List<dynamic> list) {
    final appBar = AppBar(title: Text(title ?? '解析数据'));
    final listView = ListView.builder(
      itemBuilder: (context, i) => _listBuilder(context, list[i], i),
      itemCount: list.length,
    );
    return Scaffold(appBar: appBar, body: listView);
  }

  Widget _buildMap(BuildContext context, dynamic map) {
    final appBar = AppBar(title: Text(title ?? '解析数据'));
    final entries = map.entries.toList();
    final listView = ListView.builder(
      itemBuilder: (context, i) => _mapBuilder(context, entries[i]),
      itemCount: entries.length,
    );
    return Scaffold(appBar: appBar, body: listView);
  }

  Scaffold _buildText() {
    final appBar = AppBar(title: Text(title ?? '解析数据'));
    final scrollView = SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(data),
    );
    return Scaffold(appBar: appBar, body: scrollView);
  }

  bool _canSerialize() {
    try {
      jsonDecode(data);
      return true;
    } catch (error) {
      return false;
    }
  }

  Widget _listBuilder(BuildContext context, Map map, int index) {
    final subtitle = Text(
      map.toString(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    return ListTile(
      title: Text((index + 1).toString()),
      subtitle: subtitle,
      trailing: Icon(Icons.chevron_right_outlined),
      onTap: () => handleTap(context, jsonEncode(map), '${index + 1}'),
    );
  }

  Widget _mapBuilder(BuildContext context, MapEntry entry) {
    final title = entry.key.toString();
    final subtitle = entry.value.toString();
    final text = Text(
      subtitle.plain() ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.chevron_right_outlined),
      subtitle: text,
      onTap: () => handleTap(context, subtitle, title),
    );
  }
}

class _RawDataPage extends StatelessWidget {
  final String data;
  const _RawDataPage(this.data);

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const Text('网页数据'));
    final paragraphs = data.split('\n');
    final scrollView = ListView.builder(
      itemBuilder: (_, index) => Text(paragraphs[index]),
      itemCount: paragraphs.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
    );
    return Scaffold(appBar: appBar, body: scrollView);
  }
}

class _SourceDebuggerPageState extends State<SourceDebuggerPage> {
  String defaultCredential = '都市';
  final keys = [
    'archive',
    'chapters',
    'cursor',
    'id',
    'index',
    'source_id',
    'sources',
  ];
  bool loading = false;
  DebugResult result = DebugResult();
  List<DebugResultNew> results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [_DebugButton()], title: const Text('书源调试')),
      body: Consumer(builder: (context, ref, child) {
        final state = ref.watch(sourceDebuggerProvider);
        return StreamBuilder(
          stream: state.value,
          builder: (context, snapshot) {
            Widget indicator = const LinearProgressIndicator();
            if (snapshot.connectionState == ConnectionState.done) {
              indicator = const SizedBox();
            }
            Widget list = const SizedBox();
            if (!state.isLoading && snapshot.data != null) {
              final result = snapshot.data!;
              list = ListView.builder(
                itemBuilder: (context, index) {
                  dynamic json = jsonDecode(result[index].json);
                  switch (result[index].title) {
                    case '搜索':
                      for (var item in json) {
                        _remove(item, [...keys, 'catalogue_url']);
                      }
                      break;
                    case '详情':
                      _remove(json, keys);
                      break;
                    case '目录':
                      for (var item in json) {
                        _remove(item, ['id']);
                      }
                      break;
                    default:
                      break;
                  }
                  return _Tile(
                    response: result[index].html,
                    result: json,
                    title: result[index].title,
                  );
                },
                itemCount: result.length,
              );
            }
            return Column(children: [indicator, Expanded(child: list)]);
          },
        );
      }),
    );
  }

  Map<String, dynamic> _remove(Map<String, dynamic> map, List<String> keys) {
    for (var key in keys) {
      map.remove(key);
    }
    return map;
  }
}

class _Tile extends StatelessWidget {
  final String? response;

  final dynamic result;
  final String title;
  const _Tile({
    this.response,
    this.result,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final rawSubtitle = Text(
      response.plain() ?? '解析失败',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
    final rawTile = ListTile(
      subtitle: rawSubtitle,
      title: const Text('网页数据'),
      trailing: const Icon(Icons.chevron_right_outlined),
      onTap: () => showRawData(context),
    );
    final parseSubtitle = Text(
      result.toString(),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
    final parseTile = ListTile(
      title: const Text('解析数据'),
      subtitle: parseSubtitle,
      trailing: const Icon(Icons.chevron_right_outlined),
      onTap: () => showJsonData(context),
    );
    final children = [
      RuleGroupLabel(title),
      rawTile,
      if (result != null) parseTile,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  void showJsonData(BuildContext context) {
    if (result == null) return;
    final page = _JsonDataPage(jsonEncode(result));
    final route = MaterialPageRoute(builder: (_) => page);
    Navigator.of(context).push(route);
  }

  void showRawData(BuildContext context) {
    if (response == null) return;
    final page = _RawDataPage(response!);
    final route = MaterialPageRoute(builder: (_) => page);
    Navigator.of(context).push(route);
  }
}
