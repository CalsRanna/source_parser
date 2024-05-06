import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_view/json_view.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/provider/source.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/string_extension.dart';

class SourceDebuggerPage extends StatefulWidget {
  const SourceDebuggerPage({super.key});

  @override
  State<StatefulWidget> createState() => _SourceDebuggerPageState();
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
      appBar: AppBar(
        actions: [
          Consumer(builder: (context, ref, child) {
            return IconButton(
              icon: const Icon(Icons.bug_report_outlined),
              onPressed: () => debug(ref),
            );
          })
        ],
        title: const Text('书源调试'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final provider = ref.watch(sourceDebuggerProvider);
        return StreamBuilder(
          stream: provider.value,
          builder: (context, snapshot) {
            Widget indicator = const LinearProgressIndicator();
            if (snapshot.connectionState == ConnectionState.done) {
              indicator = const SizedBox(height: 4);
            }
            Widget list = const SizedBox();
            if (!provider.isLoading && snapshot.data != null) {
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
                  return _DebugResultTile(
                    response: result[index].raw,
                    result: json,
                    title: result[index].title,
                  );
                },
                itemCount: result.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              );
            }
            return Column(children: [indicator, Expanded(child: list)]);
          },
        );
      }),
    );
  }

  void debug(WidgetRef ref) async {
    try {
      final notifier = ref.read(sourceDebuggerProvider.notifier);
      notifier.debug();
    } catch (e) {
      final message = Message.of(context);
      message.show(e.toString());
    }
  }

  Map<String, dynamic> _remove(Map<String, dynamic> map, List<String> keys) {
    for (var key in keys) {
      map.remove(key);
    }
    return map;
  }
}

class _DebugResultTile extends StatelessWidget {
  const _DebugResultTile({
    this.response,
    this.result,
    required this.title,
  });

  final String? response;
  final dynamic result;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            subtitle: Text(
              response.plain() ?? '解析失败',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            title: const Text('原始数据'),
            trailing: const Icon(Icons.chevron_right_outlined),
            onTap: () => showRawData(context),
          ),
          if (result != null)
            ListTile(
              title: const Text('解析数据'),
              subtitle: Text(
                jsonEncode(result),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: const Icon(Icons.chevron_right_outlined),
              onTap: () => showJsonData(context),
            ),
        ],
      ),
    );
  }

  void showRawData(BuildContext context) {
    if (response != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => _RawDataView(rawData: response!),
      );
    }
  }

  void showJsonData(BuildContext context) {
    if (result != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => _ParsedDataView(parsed: result),
      );
    }
  }
}

class _RawDataView extends StatelessWidget {
  const _RawDataView({required this.rawData});

  final String rawData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '原始数据',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => handleTap(context),
              )
            ],
          ),
          Expanded(child: SingleChildScrollView(child: Text(rawData))),
        ],
      ),
    );
  }

  void handleTap(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _ParsedDataView extends StatelessWidget {
  const _ParsedDataView({required this.parsed});

  final dynamic parsed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '解析数据',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => handleTap(context),
              )
            ],
          ),
          Expanded(
            child: JsonView(
              json: parsed,
              styleScheme: const JsonStyleScheme(openAtStart: true),
            ),
          )
        ],
      ),
    );
  }

  void handleTap(BuildContext context) {
    Navigator.of(context).pop();
  }
}
