import 'package:get_it/get_it.dart';
import 'package:source_parser/component/reader/reader_delegate.dart';
import 'package:source_parser/component/reader/reader_exception.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/database/replacement_service.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class LocalReaderDelegate extends ReaderDelegate {
  final BookEntity book;

  String catalogueUrl = '';
  List<ChapterEntity> chapters = [];
  List<AvailableSourceEntity> availableSources = [];
  SourceEntity source = SourceEntity();

  LocalReaderDelegate({required this.book});

  @override
  int get totalChapterCount => chapters.length;

  @override
  Future<ReaderInitialState> loadInitialState() async {
    catalogueUrl = book.catalogueUrl;
    chapters = await _initChapters();
    availableSources = await _initAvailableSources();
    source = await SourceService().getBookSource(book.sourceId);
    return ReaderInitialState(
      bookName: book.name,
      totalChapterCount: chapters.length,
      initialChapterIndex: book.chapterIndex,
      initialPageIndex: book.pageIndex,
    );
  }

  @override
  String getChapterName(int index) => chapters.elementAt(index).name;

  @override
  Future<String> fetchContent(int chapterIndex,
      {bool reacquire = false}) async {
    var chapterName = chapters.elementAt(chapterIndex).name;
    var seconds = await SharedPreferenceUtil.getTimeout();
    var timeout = Duration(seconds: seconds);
    final network = CachedNetwork(prefix: book.name, timeout: timeout);
    var url = chapters.elementAt(chapterIndex).url;
    final html = await network.request(
      url,
      charset: source.charset,
      method: source.contentMethod.toUpperCase(),
      reacquire: reacquire,
    );
    final parser = HtmlParser();
    var document = parser.parse(html);
    var content = parser.query(document, source.contentContent);
    if (content.isEmpty) {
      throw ReaderException('$chapterName\n\n${StringConfig.emptyContent}');
    }
    if (source.contentPagination.isNotEmpty) {
      var validation = parser.query(
        document,
        source.contentPaginationValidation,
      );
      while (validation.contains(StringConfig.nextPage)) {
        var nextUrl = parser.query(document, source.contentPagination);
        if (!nextUrl.startsWith('http')) {
          nextUrl = '${source.url}$nextUrl';
        }
        var nextHtml = await network.request(
          nextUrl,
          charset: source.charset,
          method: source.contentMethod.toUpperCase(),
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
    var replacements =
        await ReplacementService().getReplacementsByBookId(book.id);
    for (var replacement in replacements) {
      content = content.replaceAll(replacement.source, replacement.target);
    }
    return '$chapterName\n\n$content';
  }

  @override
  Future<void> saveProgress({
    required int chapterIndex,
    required int pageIndex,
  }) async {
    var copiedBook = book.copyWith(
      chapterIndex: chapterIndex,
      pageIndex: pageIndex,
      sourceId: source.id,
    );
    await BookService().updateBook(copiedBook);
  }

  @override
  Future<void> onLeave() async {
    GetIt.instance.get<BookshelfViewModel>().initSignals();
  }

  // --- 本地特有的辅助方法（供 ViewModel/Page 调用） ---

  Future<List<AvailableSourceEntity>> reloadAvailableSources() async {
    availableSources = await _initAvailableSources();
    return availableSources;
  }

  Future<String> getRemoteCatalogueUrl(String url) async {
    var network = CachedNetwork(prefix: book.name);
    var html = await network.request(url);
    final parser = HtmlParser();
    var document = parser.parse(html);
    var result = parser.query(document, source.informationCatalogueUrl);
    if (!result.startsWith('http')) {
      result = '${source.url}$result';
    }
    return result;
  }

  Future<List<ChapterEntity>> getRemoteChapters() async {
    var network = CachedNetwork(prefix: book.name);
    var html = await network.request(catalogueUrl);
    final parser = HtmlParser();
    var document = parser.parse(html);
    var preset = parser.query(document, source.cataloguePreset);
    var items = parser.queryNodes(document, source.catalogueChapters);
    List<ChapterEntity> result = [];
    var catalogueUrlRule = source.catalogueUrl;
    catalogueUrlRule = catalogueUrlRule.replaceAll('{{preset}}', preset);
    for (var i = 0; i < items.length; i++) {
      final name = parser.query(items[i], source.catalogueName);
      var chapterUrl = parser.query(items[i], catalogueUrlRule);
      if (!chapterUrl.startsWith('http')) {
        chapterUrl = '${source.url}$chapterUrl';
      }
      final chapter = ChapterEntity();
      chapter.name = name;
      chapter.url = chapterUrl;
      chapter.bookId = book.id;
      result.add(chapter);
    }
    return result;
  }

  // --- Private helpers ---

  Future<List<AvailableSourceEntity>> _initAvailableSources() async {
    return await AvailableSourceService().getAvailableSources(book.id);
  }

  Future<List<ChapterEntity>> _initChapters() async {
    var chapters = await ChapterService().getChapters(book.id);
    if (chapters.isNotEmpty) return chapters;
    return await getRemoteChapters();
  }
}
