import 'package:flutter/material.dart' hide Theme;
import 'package:isar/isar.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/splitter.dart';

class ReaderController {
  final Book book;
  final Size size;
  final Theme theme;

  List<String> _previous = [];
  List<String> _current = [];
  List<String> _next = [];

  ReaderController(this.book, {required this.size, required this.theme});

  List<String> get previousChapterPages => _previous;
  List<String> get currentChapterPages => _current;
  List<String> get nextChapterPages => _next;

  List<String> getPages(int pageIndex, {int chapterIndex = 0}) {
    List<String> pages = ['', '', ''];
    try {
      if (pageIndex - 1 >= 0) {
        pages[0] = _current[pageIndex - 1];
      } else {
        pages[0] = _previous.last;
      }
    } catch (error) {
      pages[0] = error.toString();
    }
    try {
      pages[1] = _current[pageIndex];
    } catch (error) {
      pages[1] = error.toString();
    }
    try {
      if (pageIndex + 1 < _current.length) {
        pages[2] = _current[pageIndex + 1];
      } else {
        pages[2] = _next.first;
      }
    } catch (error) {
      pages[2] = error.toString();
    }
    return pages;
  }

  Future<void> init(int chapterIndex) async {
    List<Future<void>> futures = [];
    var previousChapter = chapterIndex - 1;
    if (previousChapter >= 0) futures.add(_getPrevious(previousChapter));
    futures.add(_getCurrent(chapterIndex));
    var nextChapter = chapterIndex + 1;
    if (nextChapter < book.chapters.length) futures.add(_getNext(nextChapter));
    await Future.wait(futures);
  }

  Future<void> _getCurrent(int index) async {
    _current = await _getPages(index);
  }

  Future<void> _getNext(int index) async {
    _next = await _getPages(index);
  }

  Future<List<String>> _getPages(int index) async {
    var chapter = book.chapters.elementAt(index);
    var source = await _getSource();
    if (source == null) return [];
    var setting = await _getSetting();
    var timeout = Duration(milliseconds: setting.timeout);
    var document = await Parser.getContent(
      name: book.name,
      url: chapter.url,
      source: source,
      title: chapter.name,
      timeout: timeout,
    );
    return Splitter(size: size, theme: theme).split(document);
  }

  Future<void> _getPrevious(int index) async {
    _previous = await _getPages(index);
  }

  Future<Setting> _getSetting() async {
    var setting = await isar.settings.where().findFirst();
    return setting ?? Setting();
  }

  Future<Source?> _getSource() async {
    return isar.sources.filter().idEqualTo(book.sourceId).findFirst();
  }
}
