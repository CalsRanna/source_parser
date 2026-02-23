import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/string_extension.dart';
import 'package:source_parser/page/source_page/component/rule_group_label.dart';

@RoutePage()
class SourceDebuggerPage extends StatefulWidget {
  const SourceDebuggerPage({super.key});

  @override
  State<StatefulWidget> createState() => _SourceDebuggerPageState();
}

class _DebugButton extends StatelessWidget {
  const _DebugButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(HugeIcons.strokeRoundedCursorMagicSelection02),
      onPressed: onPressed,
    );
  }
}


class _SourceDebuggerPageState extends State<SourceDebuggerPage> {
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
  List<DebugResultEntity> results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [_DebugButton(onPressed: handleDebug)],
          title: const Text('书源调试')),
      body: Column(children: [
        if (loading) const LinearProgressIndicator() else const SizedBox(),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('点击右上角图标开始调试'))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    dynamic json = jsonDecode(results[index].json);
                    switch (results[index].title) {
                      case '搜索':
                        if (json is List) {
                          for (var item in json) {
                            if (item is Map<String, dynamic>) {
                              _remove(item, [...keys, 'catalogue_url']);
                            }
                          }
                        }
                        break;
                      case '详情':
                        if (json is Map<String, dynamic>) {
                          _remove(json, keys);
                        }
                        break;
                      case '目录':
                        if (json is List) {
                          for (var item in json) {
                            if (item is Map<String, dynamic>) {
                              _remove(item, ['id']);
                            }
                          }
                        }
                        break;
                      default:
                        break;
                    }
                    return _Tile(
                      response: results[index].html,
                      result: json,
                      title: results[index].title,
                    );
                  },
                  itemCount: results.length,
                ),
        ),
      ]),
    );
  }

  void handleDebug() async {
    try {
      setState(() {
        loading = true;
        results = [];
      });
      DialogUtil.snackBar('调试功能暂未实现');
      setState(() {
        loading = false;
      });
    } catch (e) {
      DialogUtil.snackBar(e.toString());
      setState(() {
        loading = false;
      });
    }
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
      trailing: const Icon(HugeIcons.strokeRoundedArrowRight01),
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
      trailing: const Icon(HugeIcons.strokeRoundedArrowRight01),
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
    JsonDataRoute(data: jsonEncode(result)).push(context);
  }

  void showRawData(BuildContext context) {
    if (response == null) return;
    RawDataRoute(data: response!).push(context);
  }
}
