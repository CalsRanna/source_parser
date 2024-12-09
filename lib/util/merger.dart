import 'package:flutter/material.dart';

class Merger {
  final TextStyle chapterStyle;
  final TextStyle contentStyle;

  const Merger({required this.chapterStyle, required this.contentStyle});

  TextSpan merge(String pageContent) {
    bool isFirstPage = pageContent.startsWith('\n');
    if (isFirstPage) {
      pageContent = pageContent.substring(1); // Remove the marker
    }
    List<String> paragraphs = pageContent.split('\n');
    List<InlineSpan> children = [];
    if (isFirstPage && paragraphs.isNotEmpty) {
      // Add spacing before title using newlines
      children.add(TextSpan(text: '\n', style: chapterStyle));
      children.add(TextSpan(text: paragraphs.first, style: chapterStyle));
      paragraphs.removeAt(0);
    }
    children.addAll(paragraphs.map(_buildTextSpan));
    return TextSpan(children: children);
  }

  TextSpan _buildTextSpan(String paragraph) {
    return TextSpan(text: '$paragraph\n', style: contentStyle);
  }
}
