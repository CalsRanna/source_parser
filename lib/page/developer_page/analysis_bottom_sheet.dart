import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class AnalysisBottomSheet extends StatelessWidget {
  final String content;
  final bool loading;
  const AnalysisBottomSheet({
    super.key,
    required this.content,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        GptMarkdown(content),
        SafeArea(top: false, child: SizedBox()),
      ],
    );
  }
}
