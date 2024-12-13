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

  List<String> _previousChapterPages = [];
  List<String> _currentChapterPages = [];
  List<String> _nextChapterPages = [];

  ReaderController(this.book, {required this.size, required this.theme});

  int get chapter => _chapter;
  List<String> get currentChapterPages => _currentChapterPages;

  List<String> get nextChapterPages => _nextChapterPages;
  int get page => _page;
  List<String> get previousChapterPages => _previousChapterPages;

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

  String getPageProgressText(int index) {
    try {
      return switch (index) {
        0 => _getPreviousPageProgressText(),
        1 => _getCurrentPageProgressText(),
        2 => _getNextPageProgressText(),
        _ => '',
      };
    } catch (error, stackTrace) {
      return stackTrace.toString();
    }
  }

  String getTotalProgressText(int index) {
    try {
      return switch (index) {
        0 => _getPreviousTotalProgressText(),
        1 => _getCurrentTotalProgressText(),
        2 => _getNextTotalProgressText(),
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
    if (_currentChapterPages.isNotEmpty &&
        _page >= _currentChapterPages.length) {
      _page = _currentChapterPages.length - 1;
    }
  }

  void nextChapter() {
    if (_chapter + 1 >= book.chapters.length) return;
    _chapter++;
    _page = 0;
    _previousChapterPages = _currentChapterPages;
    _currentChapterPages = _nextChapterPages;
    _getNextChapterPages(_chapter + 1);
  }

  void nextPage() {
    if (_page >= _currentChapterPages.length - 1) return nextChapter();
    _page++;
  }

  void previousChapter({int? page}) {
    if (_chapter <= 0) return;
    _chapter--;
    _page = page ?? _previousChapterPages.length - 1;
    _nextChapterPages = _currentChapterPages;
    _currentChapterPages = _previousChapterPages;
    _getPreviousChapterPages(_chapter - 1);
  }

  void previousPage() {
    if (_page <= 0) return previousChapter();
    _page--;
  }

  Future<void> _getCurrentChapterPages(int index) async {
    _currentChapterPages = await _getPages(index);
  }

  String _getCurrentContentText() {
    if (_currentChapterPages.isEmpty) return '';
    if (_page < 0 || _page >= _currentChapterPages.length) return '';
    return _currentChapterPages.elementAt(_page);
  }

  String _getCurrentHeaderText() {
    if (_page != 0) return book.chapters.elementAt(_chapter).name;
    return book.name;
  }

  String _getCurrentPageProgressText() {
    return '${_page + 1}/${_currentChapterPages.length}';
  }

  String _getCurrentTotalProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = _chapter / chapters;
    var pageProgress = _currentChapterPages.isEmpty
        ? 0
        : (_page / _currentChapterPages.length);
    var progress = (chapterProgress + pageProgress / chapters) * 100;
    return '${progress.toStringAsFixed(2)}%';
  }

  Future<void> _getNextChapterPages(int index) async {
    _nextChapterPages = await _getPages(index);
  }

  String _getNextContentText() {
    if (_currentChapterPages.isEmpty) return '';
    if (_page + 1 >= _currentChapterPages.length) {
      return _nextChapterPages.isEmpty ? '' : _nextChapterPages.first;
    }
    return _currentChapterPages.elementAt(_page + 1);
  }

  String _getNextHeaderText() {
    var chapter = book.chapters.elementAt(_chapter);
    var isLastPage = _page + 1 >= _currentChapterPages.length;
    var isLastChapter = _chapter + 1 >= book.chapters.length;
    if (isLastPage && isLastChapter) return chapter.name;
    if (isLastPage) return book.name;
    return chapter.name;
  }

  String _getNextPageProgressText() {
    if (_page < _currentChapterPages.length - 1)
      return '${_page + 2}/${_currentChapterPages.length}';
    return '1/${_nextChapterPages.length}';
  }

  String _getNextTotalProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = (_chapter + 1) / chapters;
    var progress = chapterProgress * 100;
    return '${progress.toStringAsFixed(2)}%';
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
    _previousChapterPages = await _getPages(index);
  }

  String _getPreviousContentText() {
    if (_currentChapterPages.isEmpty) return '';
    if (_page - 1 < 0) {
      return _previousChapterPages.isEmpty ? '' : _previousChapterPages.last;
    }
    return _currentChapterPages.elementAt(_page - 1);
  }

  String _getPreviousHeaderText() {
    var chapter = book.chapters.elementAt(_chapter);
    if (_page > 0) return chapter.name;
    if (_chapter <= 0) return chapter.name;
    return book.name;
  }

  String _getPreviousPageProgressText() {
    if (_page > 0) return '${_page - 1}/${_currentChapterPages.length}';
    return '${_previousChapterPages.length}/${_currentChapterPages.length}';
  }

  String _getPreviousTotalProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = _chapter / chapters;
    var pageProgress = _currentChapterPages.isEmpty
        ? 0
        : ((_page - 1) / _currentChapterPages.length);
    var progress = (chapterProgress + pageProgress / chapters) * 100;
    return '${progress.toStringAsFixed(2)}%';
  }

  Future<Setting> _getSetting() async {
    var setting = await isar.settings.where().findFirst();
    return setting ?? Setting();
  }

  Future<Source?> _getSource() async {
    return isar.sources.filter().idEqualTo(book.sourceId).findFirst();
  }
}
