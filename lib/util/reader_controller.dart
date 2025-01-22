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

class ReaderContent {
  final ReaderContentState state;
  final String text;

  const ReaderContent({
    this.state = ReaderContentState.normal,
    required this.text,
  });

  const ReaderContent.boundary()
      : state = ReaderContentState.boundary,
        text = '';

  const ReaderContent.error([String? message])
      : state = ReaderContentState.error,
        text = message ?? '';

  const ReaderContent.loading()
      : state = ReaderContentState.loading,
        text = '';
}

enum ReaderContentState {
  boundary, // 边界页面（第一页或最后一页）
  error, // 错误状态
  loading, // 加载中
  normal, // 正常内容
}

class ReaderController extends ChangeNotifier {
  final Book book;
  void Function()? onReachFirstPage;
  void Function()? onReachLastPage;
  final Size size;
  final Theme theme;

  int _chapter = 0;
  int _page = 0;

  List<String> _previousChapterPages = [];
  List<String> _currentChapterPages = [];
  List<String> _nextChapterPages = [];

  String _currentContent = '';
  String _previousContent = '';
  String _nextContent = '';

  String _headerText = '';
  String _previousHeaderText = '';
  String _nextHeaderText = '';

  String _pageProgressText = '';
  String _previousPageProgressText = '';
  String _nextPageProgressText = '';

  String _totalProgressText = '';
  String _previousTotalProgressText = '';
  String _nextTotalProgressText = '';

  ReaderContent _currentPageContent = const ReaderContent.loading();
  ReaderContent _previousPageContent = const ReaderContent.loading();
  ReaderContent _nextPageContent = const ReaderContent.loading();
  ReaderController(this.book, {required this.size, required this.theme});

  int get chapter => _chapter;
  List<String> get currentChapterPages => _currentChapterPages;

  bool get isFirstPage => _chapter == 0 && _page == 0;
  bool get isLastPage {
    var lastChapter = _chapter == book.chapters.length - 1;
    var lastPage = _page == _currentChapterPages.length - 1;
    return lastChapter && lastPage;
  }

  List<String> get nextChapterPages => _nextChapterPages;

  int get page => _page;
  List<String> get previousChapterPages => _previousChapterPages;

  bool canGoToNextPage() => !isLastPage;

  bool canGoToPreviousPage() => !isFirstPage;

  bool canScrollToPage(int index) {
    if (index == 0 && isFirstPage) return false;
    if (index == 2 && isLastPage) return false;
    return true;
  }

  void _updatePageContents() {
    try {
      // Update previous page content
      if (isFirstPage) {
        _previousPageContent = const ReaderContent.boundary();
        _previousContent = '';
      } else {
        _previousContent = _getPreviousContentText();
        _previousPageContent = ReaderContent(text: _previousContent);
      }

      // Update current page content
      _currentContent = _getCurrentContentText();
      _currentPageContent = ReaderContent(text: _currentContent);

      // Update next page content
      if (isLastPage) {
        _nextPageContent = const ReaderContent.boundary();
        _nextContent = '';
      } else {
        _nextContent = _getNextContentText();
        _nextPageContent = ReaderContent(text: _nextContent);
      }
    } catch (error) {
      _previousPageContent = ReaderContent.error(error.toString());
      _currentPageContent = ReaderContent.error(error.toString());
      _nextPageContent = ReaderContent.error(error.toString());
    }
  }

  // Getters for content
  String get currentContent => _currentContent;
  String get previousContent => _previousContent;
  String get nextContent => _nextContent;

  // Getters for header text
  String get headerText => _headerText;
  String get previousHeaderText => _previousHeaderText;
  String get nextHeaderText => _nextHeaderText;

  // Getters for progress text
  String get pageProgressText => _pageProgressText;
  String get previousPageProgressText => _previousPageProgressText;
  String get nextPageProgressText => _nextPageProgressText;

  // Getters for total progress
  String get totalProgressText => _totalProgressText;
  String get previousTotalProgressText => _previousTotalProgressText;
  String get nextTotalProgressText => _nextTotalProgressText;

  // Getters for page content
  ReaderContent get currentPageContent => _currentPageContent;
  ReaderContent get previousPageContent => _previousPageContent;
  ReaderContent get nextPageContent => _nextPageContent;

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
    _updatePageContents();
    _updateHeaderTexts();
    _updateProgressTexts();
    notifyListeners();
  }

  Future<void> nextChapter() async {
    if (_chapter + 1 >= book.chapters.length) return;
    _chapter++;
    _page = 0;
    _previousChapterPages = _currentChapterPages;
    _currentChapterPages = _nextChapterPages;
    await _getNextChapterPages(_chapter + 1);
    _updatePageContents();
    _updateHeaderTexts();
    _updateProgressTexts();
    notifyListeners();
  }

  Future<void> nextPage() async {
    if (!canGoToNextPage()) return notifyListeners();
    if (_page >= _currentChapterPages.length - 1) {
      await nextChapter();
      return;
    }
    _page++;
    _updatePageContents();
    _updateHeaderTexts();
    _updateProgressTexts();
    notifyListeners();
    _checkBoundaries();
  }

  Future<void> previousChapter({int? page}) async {
    if (_chapter <= 0) return notifyListeners();
    _chapter--;
    _page = page ?? _previousChapterPages.length - 1;
    _nextChapterPages = _currentChapterPages;
    _currentChapterPages = _previousChapterPages;
    if (_chapter > 0) {
      await _getPreviousChapterPages(_chapter - 1);
      _updatePageContents();
      _updateHeaderTexts();
      _updateProgressTexts();
      notifyListeners();
    } else {
      _previousChapterPages = [];
      _updatePageContents();
      _updateHeaderTexts();
      _updateProgressTexts();
      notifyListeners();
    }
  }

  Future<void> previousPage() async {
    if (!canGoToPreviousPage()) {
      notifyListeners();
      return;
    }
    if (_page <= 0) return previousChapter();
    _page--;
    _updatePageContents();
    _updateHeaderTexts();
    _updateProgressTexts();
    notifyListeners();
    _checkBoundaries();
  }

  /// 强制刷新当前章节的内容
  Future<void> refresh() async {
    await _getCurrentChapterPages(_chapter, reacquire: true);
    if (_currentChapterPages.isNotEmpty &&
        _page >= _currentChapterPages.length) {
      _page = _currentChapterPages.length - 1;
    }
    _updatePageContents();
    _updateHeaderTexts();
    _updateProgressTexts();
    notifyListeners();
  }

  void _checkBoundaries() {
    if (isFirstPage) {
      onReachFirstPage?.call();
    }
    if (isLastPage) {
      onReachLastPage?.call();
    }
  }

  void _updateHeaderTexts() {
    try {
      _previousHeaderText = _getPreviousHeaderText();
      _headerText = _getCurrentHeaderText();
      _nextHeaderText = _getNextHeaderText();
    } catch (error) {
      _previousHeaderText = error.toString();
      _headerText = error.toString();
      _nextHeaderText = error.toString();
    }
  }

  void _updateProgressTexts() {
    try {
      _previousPageProgressText = _getPreviousPageProgressText();
      _pageProgressText = _getCurrentPageProgressText();
      _nextPageProgressText = _getNextPageProgressText();

      _previousTotalProgressText = _getPreviousTotalProgressText();
      _totalProgressText = _getCurrentTotalProgressText();
      _nextTotalProgressText = _getNextTotalProgressText();
    } catch (error) {
      _previousPageProgressText = '0/0';
      _pageProgressText = '0/0';
      _nextPageProgressText = '0/0';

      _previousTotalProgressText = '0.00%';
      _totalProgressText = '0.00%';
      _nextTotalProgressText = '0.00%';
    }
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
    if (_page < _currentChapterPages.length - 1) {
      return '${_page + 2}/${_currentChapterPages.length}';
    }
    return '1/${_nextChapterPages.length}';
  }

  String _getNextTotalProgressText() {
    var chapters = book.chapters.length;
    var chapterProgress = (_chapter + 1) / chapters;
    var progress = chapterProgress * 100;
    return '${progress.toStringAsFixed(2)}%';
  }

  Future<List<String>> _getPages(int index, {bool reacquire = false}) async {
    if (index < 0 || index >= book.chapters.length) {
      return [];
    }
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
      return '${max(0, _page - 1)}/${_currentChapterPages.length}';
    } catch (error) {
      return '0/0';
    }
  }

  String _getPreviousTotalProgressText() {
    try {
      var chapters = book.chapters.length;
      var chapterProgress = _chapter / chapters;
      // 如果是第一页，直接返回章节进度
      if (_page <= 0) {
        var progress = (chapterProgress * 100);
        return '${progress.toStringAsFixed(2)}%';
      }
      // 计算页面进度时确保不会出现负数
      var pageProgress = _currentChapterPages.isEmpty
          ? 0
          : (max(0, _page - 1) / _currentChapterPages.length);
      var progress = (chapterProgress + pageProgress / chapters) * 100;
      return '${progress.toStringAsFixed(2)}%';
    } catch (error) {
      return '0.00%';
    }
  }

  Future<Setting> _getSetting() async {
    var setting = await isar.settings.where().findFirst();
    return setting ?? Setting();
  }

  Future<Source?> _getSource() async {
    return isar.sources.filter().idEqualTo(book.sourceId).findFirst();
  }
}
