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

  int _chapter = 0;
  int _page = 0;

  List<String> _previous = [];
  List<String> _current = [];
  List<String> _next = [];

  ReaderController(this.book, {required this.size, required this.theme});

  List<String> get currentChapterPages => _current;
  List<String> get nextChapterPages => _next;
  List<String> get previousChapterPages => _previous;

  String getChapterText(int index) {
    try {
      return switch (index) {
        0 => _getPreviousChapterText(),
        1 => _getCurrentChapterText(),
        2 => _getNextChapterText(),
        _ => '',
      };
    } catch (error, stackTrace) {
      return stackTrace.toString();
    }
  }

  String getContentText(int index) {
    try {
      return switch (index) {
        0 => _getPreviousContentText(),
        1 => _getCurrentContentText(),
        2 => _getNextContentText(),
        _ => '',
      };
    } catch (error, stackTrace) {
      return stackTrace.toString();
    }
  }

  String getHeaderText(int index) {
    try {
      return switch (index) {
        0 => _getPreviousHeaderText(),
        1 => _getCurrentHeaderText(),
        2 => _getNextHeaderText(),
        _ => '',
      };
    } catch (error, stackTrace) {
      return stackTrace.toString();
    }
  }

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

  String getProgressText(int index) {
    try {
      return switch (index) {
        0 => _getPreviousProgressText(),
        1 => _getCurrentProgressText(),
        2 => _getNextProgressText(),
        _ => '',
      };
    } catch (error, stackTrace) {
      return stackTrace.toString();
    }
  }

  Future<void> init() async {
    _chapter = book.index;
    _page = book.cursor;
    List<Future<void>> futures = [];
    var previousChapter = _chapter - 1;
    if (previousChapter >= 0) {
      futures.add(_getPreviousChapterPages(previousChapter));
    }
    futures.add(_getCurrentChapterPages(_chapter));
    var nextChapter = _chapter + 1;
    if (nextChapter < book.chapters.length) {
      futures.add(_getNextChapterPages(nextChapter));
    }
    await Future.wait(futures);
  }

  Future<void> _getCurrentChapterPages(int index) async {
    _current = await _getPages(index);
  }

  String _getCurrentChapterText() {
    return '${_page + 1}/${_current.length}';
  }

  String _getCurrentContentText() {
    if (_current.isEmpty) return '';
    return _current.elementAt(_page);
  }

  String _getCurrentHeaderText() {
    if (_page == 0) return book.name;
    return book.chapters.elementAt(_chapter).name;
  }

  String _getCurrentProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = _chapter / chapters;
    var pageProgress = _page / _current.length / chapters;
    var progress = chapterProgress + pageProgress;
    return progress.toStringAsFixed(2);
  }

  Future<void> _getNextChapterPages(int index) async {
    _next = await _getPages(index);
  }

  String _getNextChapterText() {
    if (_page < _current.length - 1) return '${_page + 2}/${_current.length}';
    return '1/${_next.length}';
  }

  String _getNextContentText() {
    if (_current.isEmpty) return '';
    if (_page + 1 > _current.length) return _next.first;
    return _current.elementAt(_page + 1);
  }

  String _getNextHeaderText() {
    if (_page + 1 > _current.length) return book.name;
    return book.chapters.elementAt(_chapter).name;
  }

  String _getNextProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = (_chapter + 1) / chapters;
    var pageProgress = _page / _current.length / chapters;
    var progress = chapterProgress + pageProgress;
    return progress.toStringAsFixed(2);
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

  Future<void> _getPreviousChapterPages(int index) async {
    _previous = await _getPages(index);
  }

  String _getPreviousChapterText() {
    if (_page > 0) return '${_page - 1}/${_current.length}';
    return '${_previous.length}/${_current.length}';
  }

  String _getPreviousContentText() {
    if (_current.isEmpty) return '';
    if (_page - 1 < 0) return _previous.last;
    return _current.elementAt(_page - 1);
  }

  String _getPreviousHeaderText() {
    if (_page - 1 < 0) return book.name;
    return book.chapters.elementAt(_chapter).name;
  }

  String _getPreviousProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = (_chapter - 1) / chapters;
    var pageProgress = _page / _current.length / chapters;
    var progress = chapterProgress + pageProgress;
    if (_page > 0) return progress.toStringAsFixed(2);
    return chapterProgress.toStringAsFixed(2);
  }

  Future<Setting> _getSetting() async {
    var setting = await isar.settings.where().findFirst();
    return setting ?? Setting();
  }

  Future<Source?> _getSource() async {
    return isar.sources.filter().idEqualTo(book.sourceId).findFirst();
  }
}
