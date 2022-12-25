import 'package:source_parser/model/book.dart';
import 'package:source_parser/model/chapter.dart';

class DebugResult {
  final String? searchResponse;
  final List<Book>? searchBooks;
  final String? informationResponse;
  final Book? informationBook;
  final String? catalogueResponse;
  final List<Chapter>? catalogueChapters;
  final String? contentResponse;
  final Chapter? contentChapter;

  DebugResult(
    this.searchResponse,
    this.searchBooks,
    this.informationResponse,
    this.informationBook,
    this.catalogueResponse,
    this.catalogueChapters,
    this.contentResponse,
    this.contentChapter,
  );

  DebugResult.bean({
    this.searchResponse,
    this.searchBooks,
    this.informationResponse,
    this.informationBook,
    this.catalogueResponse,
    this.catalogueChapters,
    this.contentResponse,
    this.contentChapter,
  });

  DebugResult copyWith({
    String? searchResponse,
    List<Book>? searchBooks,
    String? informationResponse,
    Book? informationBook,
    String? catalogueResponse,
    List<Chapter>? catalogueChapters,
    String? contentResponse,
    Chapter? contentChapter,
  }) {
    return DebugResult(
      searchResponse ?? this.searchResponse,
      searchBooks ?? this.searchBooks,
      informationResponse ?? this.informationResponse,
      informationBook ?? this.informationBook,
      catalogueResponse ?? this.catalogueResponse,
      catalogueChapters ?? this.catalogueChapters,
      contentResponse ?? this.contentResponse,
      contentChapter ?? this.contentChapter,
    );
  }
}
