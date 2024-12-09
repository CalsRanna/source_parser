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
      // Add spacing around title using newlines
      var paragraph = '\n${paragraphs.first}\n';
      children.add(TextSpan(text: paragraph, style: chapterStyle));
      paragraphs.removeAt(0);
    }
    children.addAll(paragraphs.map(_toElement));
    return TextSpan(children: children);
  }

  TextSpan _toElement(String paragraph) {
    return TextSpan(text: '$paragraph\n', style: contentStyle);
  }
}
