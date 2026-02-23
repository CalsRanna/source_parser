import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RawDataPage extends StatelessWidget {
  final String data;
  const RawDataPage({super.key, required this.data});

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
