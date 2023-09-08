import 'dart:convert';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/plain_string.dart';
import 'package:source_parser/util/message.dart';

class BookSourceDebug extends StatefulWidget {
  const BookSourceDebug({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookSourceDebugState();
}

class _BookSourceDebugState extends State<BookSourceDebug> {
  String defaultCredential = '都市';
  bool loading = false;
  DebugResult result = DebugResult();

  @override
  void didChangeDependencies() {
    debug();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
      body: loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _DebugResultTile(
                  response: result.searchRaw.plain(),
                  result: result.searchBooks.map((e) => e.toJson()).toList(),
                  title: '搜索',
                ),
                // const _DebugResultTile(title: '发现'),
                _DebugResultTile(
                  response: result.informationRaw.plain(),
                  result: result.informationBook.isNotEmpty
                      ? result.informationBook.first.toJson()
                      : {},
                  title: '详情',
                ),
                _DebugResultTile(
                  response: result.catalogueRaw.plain(),
                  result:
                      result.catalogueChapters.map((e) => e.toJson()).toList(),
                  title: '目录',
                ),
                _DebugResultTile(
                  response: result.contentRaw.plain(),
                  result: {'content': result.contentContent},
                  title: '正文',
                ),
              ],
            ),
    );
  }

  void debug() async {
    setState(() {
      loading = true;
    });
    final message = Message.of(context);
    try {
      final source = context.ref.read(currentSourceCreator);
      var debug = await Parser.debug(defaultCredential, source);
      setState(() {
        result = debug;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      message.show(e.toString());
    }
  }
}

class _DebugResultTile extends StatelessWidget {
  const _DebugResultTile({
    Key? key,
    this.response,
    this.result,
    required this.title,
  }) : super(key: key);

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
              response != null && response!.isNotEmpty ? response! : '解析失败',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            title: const Text('原始数据'),
            trailing: const Icon(Icons.chevron_right_outlined),
            onTap: () => showRawData(context),
          ),
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
  const _RawDataView({Key? key, required this.rawData}) : super(key: key);

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
  const _ParsedDataView({Key? key, required this.parsed}) : super(key: key);

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
