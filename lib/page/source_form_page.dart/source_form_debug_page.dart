import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/page/source_form_page.dart/source_form_debug_view_model.dart';
import 'package:source_parser/page/source_page/component/rule_group_label.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/string_extension.dart';

@RoutePage()
class SourceFormDebugPage extends StatefulWidget {
  final SourceEntity source;
  const SourceFormDebugPage({super.key, required this.source});

  @override
  State<StatefulWidget> createState() => _SourceFormDebugPageState();
}

class _SourceFormDebugPageState extends State<SourceFormDebugPage> {
  final viewModel = GetIt.instance.get<SourceFormDebugViewModel>();
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
  List<DebugResultEntity> results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [_buildDebugButton()], title: const Text('书源调试')),
      body: StreamBuilder(
        stream: viewModel.debug(),
        builder: (context, snapshot) {
          Widget indicator = const LinearProgressIndicator();
          if (snapshot.connectionState == ConnectionState.done) {
            indicator = const SizedBox();
          }
          Widget list = const SizedBox();
          if (!snapshot.hasData || snapshot.data == null) {
            list = const SizedBox();
          } else {
            final entity = snapshot.data!;
            final json = entity.json;
            final jsonList = jsonDecode(json);
            dynamic jsonMap;
            if (jsonList is List) {
              jsonMap = jsonList[0];
            }
            if (jsonMap is Map) {
              list = _Tile(
                response: jsonMap.toString(),
                result: jsonMap,
                title: entity.title,
              );
            } else {
              list = const SizedBox();
            }
          }
          return Column(children: [indicator, Expanded(child: list)]);
        },
      ),
    );
  }

  Widget _buildDebugButton() {
    return IconButton(
      icon: const Icon(HugeIcons.strokeRoundedCursorMagicSelection02),
      onPressed: viewModel.debug,
    );
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
