import 'package:flutter/material.dart';
import 'package:source_parser/schema/book.dart';

class ReaderState {
  Book book = Book();
  int chapterIndex = 0;
  int pageIndex = 0;
  List<TextSpan> pages = [];
  List<TextSpan> previousChapterPages = [];
  List<TextSpan> nextChapterPages = [];
  List<TextSpan> currentChapterPages = [];
}
