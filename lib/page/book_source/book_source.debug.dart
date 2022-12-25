import 'dart:convert';

import 'package:creator/creator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/state/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/message.dart';

class BookSourceDebug extends StatefulWidget {
  const BookSourceDebug({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookSourceDebugState();
}

class _BookSourceDebugState extends State<BookSourceDebug> {
  String defaultCredential = '都市';
  bool loading = false;
  DebugResult? result;

  @override
  void didChangeDependencies() {
    debug(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: () => debug(context),
          )
        ],
        title: const Text('书源调试'),
      ),
      body: loading
          ? const Center(child: CupertinoActivityIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: '默认以关键字“$defaultCredential”进行搜索调试',
                  ),
                ),
                Visibility(
                  visible: result?.searchResponse != null,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _DebugResultTile(
                        response: result?.searchResponse,
                        results: result?.searchBooks
                            ?.map((book) => book.toJson())
                            .toList(),
                        title: '搜索结果',
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: result?.informationResponse != null,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _DebugResultTile(
                        response: result?.informationResponse,
                        results: [result?.informationBook?.toJson() ?? {}],
                        title: '详情结果',
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: result?.catalogueResponse != null,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _DebugResultTile(
                        response: result?.catalogueResponse,
                        results: result?.catalogueChapters
                            ?.map((chapter) => chapter.toJson())
                            .toList(),
                        title: '目录结果',
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: result?.contentResponse != null,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _DebugResultTile(
                        response: result?.contentResponse,
                        results: [result?.contentChapter?.toJson() ?? {}],
                        title: '正文结果',
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void debug(BuildContext context) async {
    setState(() {
      loading = true;
    });
    var source = context.ref.read(bookSourceCreator);
    var searchRule = context.ref.read(searchRuleCreator);
    var informationRule = context.ref.read(informationRuleCreator);
    var catalogueRule = context.ref.read(catalogueRuleCreator);
    var contentRule = context.ref.read(contentRuleCreator);

    try {
      var debug = await Parser().debug(
        defaultCredential,
        source,
        searchRule,
        informationRule,
        catalogueRule,
        contentRule,
      );
      setState(() {
        result = debug;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      Message.of(context).show(e.toString());
    }
  }
}

class _DebugResultTile extends StatelessWidget {
  const _DebugResultTile({
    Key? key,
    this.response,
    this.results,
    required this.title,
  }) : super(key: key);

  final String? response;
  final List<Map<String, dynamic>>? results;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            subtitle: Text(response ?? '', overflow: TextOverflow.ellipsis),
            title: const Text('原始数据'),
            trailing: const Icon(Icons.chevron_right_outlined),
            onTap: () => showRawData(context),
          ),
          ListTile(
            title: const Text('解析数据'),
            subtitle: Text('${results?.length ?? 0}条数据'),
            trailing: const Icon(Icons.chevron_right_outlined),
            onTap: () => showJsonData(context),
          ),
        ],
      ),
    );
  }

  void showRawData(BuildContext context) {
    if (response != null) {
      showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => _RawDataView(rawData: response!),
        expand: true,
      );
    }
  }

  void showJsonData(BuildContext context) {
    if (results != null) {
      showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => _JsonDataView(list: results!),
        expand: true,
      );
    }
  }
}

class _RawDataView extends StatelessWidget {
  const _RawDataView({Key? key, required this.rawData}) : super(key: key);

  final String rawData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    onPressed: () => handleTap(context),
                    icon: const Icon(Icons.close))
              ],
            ),
            Expanded(child: SingleChildScrollView(child: Text(rawData))),
          ],
        ),
      ),
    );
  }

  void handleTap(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _JsonDataView extends StatelessWidget {
  const _JsonDataView({Key? key, required this.list}) : super(key: key);

  final List<Map<String, dynamic>> list;

  @override
  Widget build(BuildContext context) {
    var json = const JsonCodec().encode(list);
    json = json
        .replaceAll(',"', ',\n    "')
        .replaceAll('{', '\n  {\n    ')
        .replaceAll('}', '\n  }')
        .replaceAll(']', '\n]');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    onPressed: () => handleTap(context),
                    icon: const Icon(Icons.close))
              ],
            ),
            Expanded(child: SingleChildScrollView(child: Text(json))),
          ],
        ),
      ),
    );
  }

  void handleTap(BuildContext context) {
    Navigator.of(context).pop();
  }
}
