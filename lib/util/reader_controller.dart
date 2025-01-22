import 'dart:math';

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

  List<String> _currentChapterPages = [];
  List<String> _nextChapterPages = [];
  List<String> _previousChapterPages = [];

  var currentContent = '';
  var nextContent = '';
  var previousContent = '';

  var currentHeader = '';
  var nextHeader = '';
  var previousHeader = '';

  var currentProgress = '';
  var nextProgress = '';
  var previousProgress = '';

  ReaderController(this.book, {required this.size, required this.theme});

  int get chapter => _chapter;
  bool get isFirstPage => _chapter == 0 && _page == 0;

  bool get isLastPage {
    var lastChapter = _chapter == book.chapters.length - 1;
    var lastPage = _page == _currentChapterPages.length - 1;
    return lastChapter && lastPage;
  }

  int get page => _page;

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
    _updateContent();
    _updateHeader();
    _updateProgress();
    notifyListeners();
  }

  Future<void> nextChapter() async {
    if (_chapter + 1 >= book.chapters.length) return;
    _chapter++;
    _page = 0;
    _previousChapterPages = _currentChapterPages;
    _currentChapterPages = _nextChapterPages;
    await _getNextChapterPages(_chapter + 1);
    _updateContent();
    _updateHeader();
    _updateProgress();
    notifyListeners();
  }

  Future<void> nextPage() async {
    if (isLastPage) return notifyListeners();
    if (_page >= _currentChapterPages.length - 1) {
      await nextChapter();
      return;
    }
    _page++;
    _updateContent();
    _updateHeader();
    _updateProgress();
    notifyListeners();
  }

  Future<void> previousChapter({int? page}) async {
    if (_chapter <= 0) return notifyListeners();
    _chapter--;
    _page = page ?? _previousChapterPages.length - 1;
    _nextChapterPages = _currentChapterPages;
    _currentChapterPages = _previousChapterPages;
    if (_chapter > 0) {
      await _getPreviousChapterPages(_chapter - 1);
    } else {
      _previousChapterPages = [];
    }
    _updateContent();
    _updateHeader();
    _updateProgress();
    notifyListeners();
  }

  Future<void> previousPage() async {
    if (isFirstPage) return notifyListeners();
    if (_page <= 0) return previousChapter();
    _page--;
    _updateContent();
    _updateHeader();
    _updateProgress();
    notifyListeners();
  }

  /// 强制刷新当前章节的内容
  Future<void> refresh() async {
    await _getCurrentChapterPages(_chapter, reacquire: true);
    if (_currentChapterPages.isNotEmpty &&
        _page >= _currentChapterPages.length) {
      _page = _currentChapterPages.length - 1;
    }
    _updateContent();
    _updateHeader();
    _updateProgress();
    notifyListeners();
  }

  Future<void> _getCurrentChapterPages(
    int index, {
    bool reacquire = false,
  }) async {
    _currentChapterPages = await _getPages(index, reacquire: reacquire);
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
    var pageProgress = '${_page + 1}/${_currentChapterPages.length}';
    var chapters = book.chapters.length;
    var chapterPercent = _chapter / chapters;
    var pagePercent = _currentChapterPages.isEmpty
        ? 0
        : (_page / _currentChapterPages.length);
    var progress = (chapterPercent + pagePercent / chapters) * 100;
    var chapterProgress = '${progress.toStringAsFixed(2)}%';
    return '$pageProgress $chapterProgress';
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
    var pageProgress = '1/${_nextChapterPages.length}';
    if (_page < _currentChapterPages.length - 1) {
      pageProgress = '${_page + 2}/${_currentChapterPages.length}';
    }
    var chapters = book.chapters.length;
    var chapterPercent = (_chapter + 1) / chapters;
    var progress = chapterPercent * 100;
    var chapterProgress = '${progress.toStringAsFixed(2)}%';
    return '$pageProgress $chapterProgress';
  }

  Future<List<String>> _getPages(int index, {bool reacquire = false}) async {
    if (index < 0 || index >= book.chapters.length) return [];
    try {
      var chapter = book.chapters.elementAt(index);
      var source = await _getSource();
      if (source == null) return [];
      var setting = await _getSetting();
      var timeout = Duration(milliseconds: setting.timeout);
      var document = await Parser.getContent(
        name: book.name,
        url: chapter.url,
        reacquire: reacquire,
        source: source,
        title: chapter.name,
        timeout: timeout,
      );
      return Splitter(size: size, theme: theme).split(document);
    } catch (e) {
      return [];
    }
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
    if (_page > 1) return chapter.name;
    if (_page == 1) return book.name;
    if (_chapter <= 0) return chapter.name;
    return book.chapters.elementAt(_chapter - 1).name;
  }

  String _getPreviousPageProgressText() {
    try {
      if (_page <= 0) {
        // 如果是第一页，显示上一章的最后一页
        if (_previousChapterPages.isEmpty) return '0/0';
        return '${_previousChapterPages.length}/${_previousChapterPages.length}';
      }
      // 确保页码不会出现负数
      var pageProgress = '${max(0, _page - 1)}/${_currentChapterPages.length}';
      var chapters = book.chapters.length;
      var chapterPercent = _chapter / chapters;
      // 如果是第一页，直接返回章节进度
      if (_page <= 0) {
        var progress = (chapterPercent * 100);
        return '${progress.toStringAsFixed(2)}%';
      }
      // 计算页面进度时确保不会出现负数
      var pagePercent = _currentChapterPages.isEmpty
          ? 0
          : (max(0, _page - 1) / _currentChapterPages.length);
      var progress = (chapterPercent + pagePercent / chapters) * 100;
      var chapterProgress = '${progress.toStringAsFixed(2)}%';
      return '$pageProgress $chapterProgress';
    } catch (error) {
      return '';
    }
  }

  Future<Setting> _getSetting() async {
    var setting = await isar.settings.where().findFirst();
    return setting ?? Setting();
  }

  Future<Source?> _getSource() async {
    return isar.sources.filter().idEqualTo(book.sourceId).findFirst();
  }

  void _updateContent() {
    try {
      currentContent = _getCurrentContentText();
      nextContent = isLastPage ? '' : _getNextContentText();
      previousContent = isFirstPage ? '' : _getPreviousContentText();
    } catch (error) {
      currentContent = '';
      nextContent = '';
      previousContent = '';
    }
  }

  void _updateHeader() {
    try {
      currentHeader = _getCurrentHeaderText();
      nextHeader = _getNextHeaderText();
      previousHeader = _getPreviousHeaderText();
    } catch (error) {
      currentHeader = '';
      nextHeader = '';
      previousHeader = '';
    }
  }

  void _updateProgress() {
    try {
      currentProgress = _getCurrentPageProgressText();
      nextProgress = _getNextPageProgressText();
      previousProgress = _getPreviousPageProgressText();
    } catch (error) {
      currentProgress = '';
      nextProgress = '';
      previousProgress = '';
    }
  }
}
