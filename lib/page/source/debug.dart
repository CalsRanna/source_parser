import 'dart:convert';
import 'dart:io';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/string_extension.dart';

class BookSourceDebug extends StatefulWidget {
  const BookSourceDebug({super.key});

  @override
  State<StatefulWidget> createState() => _BookSourceDebugState();
}

class _BookSourceDebugState extends State<BookSourceDebug> {
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
  void didChangeDependencies() {
    debug();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = ListView.builder(
      itemBuilder: (context, index) {
        dynamic json = jsonDecode(results[index].json);
        switch (results[index].title) {
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
          response: results[index].raw,
          result: json,
          title: results[index].title,
        );
      },
      itemCount: results.length,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: debug,
          )
        ],
        title: const Text('书源调试'),
      ),
      body: Column(
        children: [
          if (loading) const LinearProgressIndicator(),
          Expanded(child: child)
        ],
      ),
    );
  }

  void debug() async {
    setState(() {
      loading = true;
      results = [];
    });
    final message = Message.of(context);
    try {
      final source = context.ref.read(currentSourceCreator);
      final duration = context.ref.read(cacheDurationCreator);
      final timeout = context.ref.read(timeoutCreator);
      var stream = await Parser.debug(
        defaultCredential,
        source,
        Duration(hours: duration.floor()),
        Duration(milliseconds: timeout),
      );
      stream.listen((result) {
        setState(() {
          results.add(result);
        });
        final isMacOS = Platform.isMacOS;
        final isWindows = Platform.isWindows;
        final isLinux = Platform.isLinux;
        final showExtra = isMacOS || isWindows || isLinux;
        if (showExtra && result.title == '正文') {
          setState(() {
            results.add(DebugResultNew(
              json: result.json,
              raw: jsonDecode(result.json)['content'].codeUnits.toString(),
              title: '正文Unicode编码',
            ));
            loading = false;
          });
        }
      }, onDone: () {
        setState(() {
          loading = false;
        });
      }, onError: (error) {
        setState(() {
          loading = false;
        });
        message.show(error);
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
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
