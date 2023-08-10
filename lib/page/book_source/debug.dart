import 'dart:convert';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/plain_string.dart';
import 'package:source_parser/widget/message.dart';

class BookSourceDebug extends StatefulWidget {
  const BookSourceDebug({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookSourceDebugState();
}

class _BookSourceDebugState extends State<BookSourceDebug> {
  String defaultCredential = '都市';
  bool loading = false;
  DebugResult result = DebugResult(
    searchBooks: [],
    searchRaw: '',
    informationBook: null,
    informationRaw: '',
    catalogueChapters: [],
    catalogueRaw: '',
    contentContent: '',
    contentRaw: '',
  );

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
                  results: result.searchBooks.map((e) => e.toJson()).toList(),
                  title: '搜索',
                ),
                const _DebugResultTile(title: '发现'),
                _DebugResultTile(
                  response: result.informationRaw.plain(),
                  results: [result.informationBook?.toJson() ?? {}],
                  title: '详情',
                ),
                _DebugResultTile(
                  response: result.catalogueRaw.plain(),
                  results:
                      result.catalogueChapters.map((e) => e.toJson()).toList(),
                  title: '目录',
                ),
                _DebugResultTile(
                  response: result.contentRaw.plain(),
                  results: [
                    {
                      'content': result.contentContent,
                    }
                  ],
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

    try {
      final source = context.ref.read(currentSourceCreator);
      var debug = await Parser().debug(defaultCredential, source);
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
      showModalBottomSheet(
        context: context,
        builder: (context) => _RawDataView(rawData: response!),
      );
    }
  }

  void showJsonData(BuildContext context) {
    if (results != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => _ParsedDataView(results: results!),
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

class _ParsedDataView extends StatelessWidget {
  const _ParsedDataView({Key? key, required this.results}) : super(key: key);

  final List results;

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
                  '解析数据',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                IconButton(
                    onPressed: () => handleTap(context),
                    icon: const Icon(Icons.close))
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  json.encode(results),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleTap(BuildContext context) {
    Navigator.of(context).pop();
  }
}
