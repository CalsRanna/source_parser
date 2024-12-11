import 'package:flutter/material.dart' hide Theme;
import 'package:isar/isar.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/splitter.dart';

class ReaderController extends ChangeNotifier {
  final Book book;
  final Size size;
  final Theme theme;

  int _chapter = 0;
  int _page = 0;

  List<String> _previous = [];
  List<String> _current = [];
  List<String> _next = [];

  ReaderController(this.book, {required this.size, required this.theme});

  int get chapter => _chapter;
  int get page => _page;

  List<String> get previousChapterPages => _previous;
  List<String> get currentChapterPages => _current;
  List<String> get nextChapterPages => _next;

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
    if (_current.isNotEmpty && _page >= _current.length) {
      _page = _current.length - 1;
    }
  }

  void nextChapter() {
    if (_chapter + 1 >= book.chapters.length) return;
    _chapter++;
    _page = 0;
    _previous = _current;
    _current = _next;
    _getNextChapterPages(_chapter + 1);
  }

  void nextPage() {
    if (_page >= _current.length - 1) return nextChapter();
    _page++;
  }

  void previousChapter({int? page}) {
    if (_chapter <= 0) return;
    _chapter--;
    _page = page ?? _previous.length - 1;
    _next = _current;
    _current = _previous;
    _getPreviousChapterPages(_chapter - 1);
  }

  void previousPage() {
    if (_page <= 0) return previousChapter();
    _page--;
  }

  Future<void> _getCurrentChapterPages(int index) async {
    _current = await _getPages(index);
  }

  String _getCurrentChapterText() {
    return '${_page + 1}/${_current.length}';
  }

  String _getCurrentContentText() {
    if (_current.isEmpty) return '';
    if (_page < 0 || _page >= _current.length) return '';
    return _current.elementAt(_page);
  }

  String _getCurrentHeaderText() {
    if (_page == 0) return book.name;
    return book.chapters.elementAt(_chapter).name;
  }

  String _getCurrentProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = _chapter / chapters;
    var pageProgress =
        _current.isEmpty ? 0 : (_page / _current.length / chapters);
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
    if (_page + 1 >= _current.length) {
      return _next.isEmpty ? '' : _next.first;
    }
    return _current.elementAt(_page + 1);
  }

  String _getNextHeaderText() {
    if (_page + 1 > _current.length) return book.name;
    return book.chapters.elementAt(_chapter).name;
  }

  String _getNextProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = (_chapter + 1) / chapters;
    var pageProgress =
        _current.isEmpty ? 0 : (_page / _current.length / chapters);
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
    if (_page - 1 < 0) {
      return _previous.isEmpty ? '' : _previous.last;
    }
    return _current.elementAt(_page - 1);
  }

  String _getPreviousHeaderText() {
    if (_page - 1 < 0) return book.name;
    return book.chapters.elementAt(_chapter).name;
  }

  String _getPreviousProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = (_chapter - 1) / chapters;
    var pageProgress =
        _current.isEmpty ? 0 : (_page / _current.length / chapters);
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
