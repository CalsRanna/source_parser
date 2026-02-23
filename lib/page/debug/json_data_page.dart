import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/string_extension.dart';

@RoutePage()
class JsonDataPage extends StatelessWidget {
  final String data;
  final String? title;
  const JsonDataPage({super.key, required this.data, this.title});

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
    JsonDataRoute(data: text, title: title).push(context);
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
      trailing: Icon(HugeIcons.strokeRoundedArrowRight01),
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
      trailing: Icon(HugeIcons.strokeRoundedArrowRight01),
      subtitle: text,
      onTap: () => handleTap(context, subtitle, title),
    );
  }
}
