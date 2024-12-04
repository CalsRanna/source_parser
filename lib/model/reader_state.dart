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

  ReaderState copyWith({
    Book? book,
    int? chapterIndex,
    int? pageIndex,
    List<TextSpan>? pages,
    List<TextSpan>? previousChapterPages,
    List<TextSpan>? nextChapterPages,
    List<TextSpan>? currentChapterPages,
  }) {
    return ReaderState()
      ..book = book ?? this.book
      ..chapterIndex = chapterIndex ?? this.chapterIndex
      ..pageIndex = pageIndex ?? this.pageIndex
      ..pages = pages ?? this.pages
      ..previousChapterPages = previousChapterPages ?? this.previousChapterPages
      ..nextChapterPages = nextChapterPages ?? this.nextChapterPages
      ..currentChapterPages = currentChapterPages ?? this.currentChapterPages;
  }
}
