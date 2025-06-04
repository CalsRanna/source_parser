import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/book_source_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/schema/theme.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/splitter.dart';
import 'package:source_parser/view_model/source_parser_view_model.dart';

class ReaderViewModel {
  final BookEntity book;
  final availableSources = signal<List<AvailableSourceEntity>>([]);
  final chapters = signal<List<ChapterEntity>>([]);
  final previousChapterContent = signal('');
  final previousChapterPages = signal<List<String>>([]);
  final currentChapterContent = signal('');
  final currentChapterPages = signal<List<String>>([]);
  final nextChapterContent = signal('');
  final nextChapterPages = signal<List<String>>([]);
  late final chapterIndex = signal(book.chapterIndex);
  late final pageIndex = signal(book.pageIndex);
  final theme = signal(Theme());
  final showOverlay = signal(false);
  final progress = signal(0.0);
  final showCacheIndicator = signal(false);
  final battery = signal(100);
  final size = Signal(Size.zero);
  final availableSource = Signal(AvailableSourceEntity());

  late final controller = PageController(initialPage: book.pageIndex);

  ReaderViewModel({required this.book});

  void downloadChapters(BuildContext context, int amount) async {
    showCacheIndicator.value = true;
    // await cacheChapters(amount: amount);
    if (!context.mounted) return;
    // final message = Message.of(context);
    // message.show('缓存完毕，${progress.succeed}章成功，${progress.failed}章失败');
    await Future.delayed(const Duration(seconds: 1));
    showCacheIndicator.value = false;
  }

  String getHeaderText(int index) {
    if (index == 0) return book.name;
    return chapters.value.elementAt(chapterIndex.value).name;
  }

  String getFooterText(int index) {
    return '${index + 1}/${currentChapterPages.value.length}';
  }

  // Future<void> cacheChapters({int amount = 3}) async {
  //   final book = ref.read(bookNotifierProvider);
  //   final builder = isar.sources.filter();
  //   final source = await builder.idEqualTo(book.sourceId).findFirst();
  //   if (source == null) return;
  //   if (amount == 0) {
  //     amount = book.chapters.length - (book.index + 1);
  //   }
  //   amount = min(amount, book.chapters.length - (book.index + 1));
  //   state = state.copyWith(amount: amount, failed: 0, succeed: 0);
  //   final startIndex = book.index + 1;
  //   final endIndex = min(startIndex + amount, book.chapters.length);
  //   final setting = await ref.read(settingNotifierProvider.future);
  //   final maxConcurrent = setting.maxConcurrent;
  //   final semaphore = Semaphore(maxConcurrent.floor());
  //   List<Future<void>> futures = [];
  //   for (var i = startIndex; i < endIndex; i++) {
  //     futures.add(_cacheChapter(source, i, semaphore));
  //   }
  //   await Future.wait(futures);
  // }

  // Future<void> _cacheChapter(
  //   Source source,
  //   int index,
  //   Semaphore semaphore,
  // ) async {
  //   await semaphore.acquire();
  //   try {
  //     final book = ref.read(bookNotifierProvider);
  //     final url = book.chapters.elementAt(index).url;
  //     final setting = await ref.read(settingNotifierProvider.future);
  //     final timeout = setting.timeout;
  //     final network = CachedNetwork(
  //       prefix: book.name,
  //       timeout: Duration(milliseconds: timeout),
  //     );
  //     final cached = await network.cached(url);
  //     if (!cached) {
  //       await network.request(
  //         url,
  //         charset: source.charset,
  //         method: source.contentMethod,
  //       );
  //     }
  //     state = state.copyWith(succeed: state.succeed + 1);
  //   } catch (error) {
  //     state = state.copyWith(failed: state.failed + 1);
  //   } finally {
  //     semaphore.release();
  //   }
  // }

  void hideUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    showOverlay.value = false;
  }

  Future<void> initSignals() async {
    theme.value = theme.value.copyWith(
      headerPaddingTop: 48,
      footerPaddingBottom: 24,
    );
    size.value = _initSize(theme.value);
    availableSources.value = await _getAvailableSources();
    chapters.value = await _initChapters();
    preloadPreviousChapter();
    currentChapterContent.value = await _getContent(book.chapterIndex);
    var splitter = Splitter(size: size.value, theme: theme.value);
    currentChapterPages.value = splitter.split(currentChapterContent.value);
    preloadNextChapter();
    battery.value = await Battery().batteryLevel;
  }

  Future<void> navigateAvailableSourcePage(BuildContext context) async {
    var id = await AvailableSourceRoute(book: book).push<int>(context);
    if (id == null) return;
    availableSource.value =
        await AvailableSourceService().getAvailableSource(id);
    var source = await BookSourceService()
        .getBookSourceByName(availableSource.value.name);
    var stream = await Parser.getChapters(
      book.name,
      availableSource.value.url,
      Source.fromJson(source.toJson()),
      Duration(hours: 6),
      Duration(seconds: 30),
    );
    await for (var item in stream) {
      chapters.value = [
        ...chapters.value,
        ChapterEntity.fromJson(item.toJson())
      ];
    }
    await ChapterService().destroyChapters(book.id);
    await ChapterService().addChapters(chapters.value);
    await BookService().updateBook(book.copyWith(availableSourceId: id));
  }

  Future<void> navigateCataloguePage(BuildContext context) async {
    var currentState = book.copyWith(chapterIndex: chapterIndex.value);
    var index = await CatalogueRoute(book: currentState).push<int>(context);
    if (index == null) return;
    chapterIndex.value = index;
    pageIndex.value = 0;
    preloadPreviousChapter();
    currentChapterContent.value = await _getContent(chapterIndex.value);
    var splitter = Splitter(size: size.value, theme: theme.value);
    currentChapterPages.value = splitter.split(currentChapterContent.value);
    controller.jumpToPage(pageIndex.value);
    preloadNextChapter();
  }

  void nextChapter() {
    if (chapterIndex.value + 1 >= chapters.value.length) {
      return;
    }
    chapterIndex.value++;
    pageIndex.value = 0;
    previousChapterContent.value = currentChapterContent.value;
    previousChapterPages.value = currentChapterPages.value;
    currentChapterContent.value = nextChapterContent.value;
    currentChapterPages.value = nextChapterPages.value;
    controller.jumpToPage(pageIndex.value);
    preloadNextChapter();
  }

  Future<void> nextPage() async {
    if (chapterIndex.value == chapters.value.length - 1 &&
        pageIndex.value + 1 >= currentChapterPages.value.length) {
      return;
    }
    if (pageIndex.value + 1 >= currentChapterPages.value.length) {
      chapterIndex.value++;
      pageIndex.value = 0;
      previousChapterContent.value = currentChapterContent.value;
      previousChapterPages.value = currentChapterPages.value;
      currentChapterContent.value = nextChapterContent.value;
      currentChapterPages.value = nextChapterPages.value;
      controller.jumpToPage(pageIndex.value);
      preloadNextChapter();
      return;
    }
    controller.nextPage(
      duration: Durations.medium1,
      curve: Curves.easeInOut,
    );
    battery.value = await Battery().batteryLevel;
  }

  Future<void> preloadNextChapter() async {
    if (chapterIndex.value + 1 >= chapters.value.length) {
      nextChapterContent.value = '';
      nextChapterPages.value = [];
      return;
    }
    var size = _initSize(theme.value);
    nextChapterContent.value = await _getContent(chapterIndex.value + 1);
    var splitter = Splitter(size: size, theme: theme.value);
    nextChapterPages.value = splitter.split(nextChapterContent.value);
  }

  Future<void> preloadPreviousChapter() async {
    if (chapterIndex.value - 1 < 0) {
      previousChapterContent.value = '';
      previousChapterPages.value = [];
      return;
    }
    var size = _initSize(theme.value);
    previousChapterContent.value = await _getContent(chapterIndex.value - 1);
    var splitter = Splitter(size: size, theme: theme.value);
    previousChapterPages.value = splitter.split(previousChapterContent.value);
  }

  void previousChapter() {
    if (chapterIndex.value - 1 < 0) {
      return;
    }
    chapterIndex.value--;
    pageIndex.value = 0;
    nextChapterContent.value = currentChapterContent.value;
    nextChapterPages.value = currentChapterPages.value;
    currentChapterContent.value = previousChapterContent.value;
    currentChapterPages.value = previousChapterPages.value;
    controller.jumpToPage(pageIndex.value);
    preloadPreviousChapter();
  }

  Future<void> previousPage() async {
    if (chapterIndex.value == 0 && pageIndex.value == 0) {
      return;
    }
    if (pageIndex.value - 1 < 0) {
      chapterIndex.value--;
      pageIndex.value = previousChapterPages.value.length - 1;
      nextChapterContent.value = currentChapterContent.value;
      nextChapterPages.value = currentChapterPages.value;
      currentChapterContent.value = previousChapterContent.value;
      currentChapterPages.value = previousChapterPages.value;
      controller.jumpToPage(pageIndex.value);
      preloadPreviousChapter();
      return;
    }
    controller.previousPage(
      duration: Durations.medium1,
      curve: Curves.easeInOut,
    );
    battery.value = await Battery().batteryLevel;
  }

  void showUiOverlays() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    showOverlay.value = true;
  }

  Future<void> syncBookshelf() async {
    var book = this.book.copyWith(
          chapterIndex: chapterIndex.value,
          pageIndex: pageIndex.value,
        );
    await BookService().updateBook(book);
    GetIt.instance.get<BookshelfViewModel>().initSignals();
  }

  void turnPage(TapUpDetails details) {
    final size = GetIt.instance.get<SourceParserViewModel>().screenSize.value;
    final horizontalTapArea = details.globalPosition.dx / size.width;
    final verticalTapArea = details.globalPosition.dy / size.height;
    if (horizontalTapArea < 1 / 3) {
      previousPage();
    } else if (horizontalTapArea > 2 / 3) {
      nextPage();
    } else if (horizontalTapArea >= 1 / 3 && horizontalTapArea <= 2 / 3) {
      if (verticalTapArea > 3 / 4) {
        nextPage();
      } else if (verticalTapArea < 1 / 4) {
        previousPage();
      } else {
        showUiOverlays();
      }
    }
  }

  void updatePageIndex(int index) {
    pageIndex.value = index;
  }

  Future<List<AvailableSourceEntity>> _getAvailableSources() async {
    return await AvailableSourceService().getAvailableSources(book.id);
  }

  Future<List<ChapterEntity>> _getChapters() async {
    // var source = await BookSourceService().getBookSource(book.sourceId);
    // var chapters = await Parser.getChapters(
    //   book.name,
    //   book.catalogueUrl,
    //   Source(),
    //   Durations.medium1,
    //   Durations.medium2,
    // );
    return [];
  }

  Future<String> _getContent(int chapterIndex) async {
    var source = await BookSourceService().getBookSource(book.sourceId);
    final method = source.contentMethod.toUpperCase();
    final network = CachedNetwork(
      prefix: book.name,
      timeout: Duration(hours: 6),
    );
    var url = chapters.value.elementAt(chapterIndex).url;
    final html = await network.request(
      url,
      charset: source.charset,
      method: method,
      reacquire: false,
    );
    final parser = HtmlParser();
    var document = parser.parse(html);
    var content = parser.query(document, source.contentContent);
    if (source.contentPagination.isNotEmpty) {
      var validation = parser.query(
        document,
        source.contentPaginationValidation,
      );
      while (validation.contains('下一页')) {
        var nextUrl = parser.query(document, source.contentPagination);
        if (!nextUrl.startsWith('http')) {
          nextUrl = '${source.url}$nextUrl';
        }
        var nextHtml = await network.request(
          nextUrl,
          charset: source.charset,
          method: method,
          reacquire: false,
        );
        document = parser.parse(nextHtml);
        var nextContent = parser.query(document, source.contentContent);
        content = '$content\n$nextContent';
        validation = parser.query(
          document,
          source.contentPaginationValidation,
        );
      }
    }
    if (content.isEmpty) {
      return content;
    }
    var chapterName = chapters.value.elementAt(chapterIndex).name;
    return '$chapterName\n\n$content';
  }

  Future<List<ChapterEntity>> _initChapters() async {
    var chapters = await ChapterService().getChapters(book.id);
    if (chapters.isNotEmpty) return chapters;
    return await _getChapters();
  }

  Size _initSize(Theme theme) {
    var screenSize =
        GetIt.instance.get<SourceParserViewModel>().screenSize.value;
    var pagePaddingHorizontal =
        theme.contentPaddingLeft + theme.contentPaddingRight;
    var pagePaddingVertical =
        theme.contentPaddingTop + theme.contentPaddingBottom;
    var width = screenSize.width - pagePaddingHorizontal;
    var headerPaddingVertical =
        theme.headerPaddingBottom + theme.headerPaddingTop;
    var footerPaddingVertical =
        theme.footerPaddingBottom + theme.footerPaddingTop;
    var height = screenSize.height - pagePaddingVertical;
    height -= headerPaddingVertical;
    height -= (theme.headerFontSize * theme.headerHeight);
    height -= footerPaddingVertical;
    height -= (theme.footerFontSize * theme.footerHeight);
    return Size(width, height);
  }
}
