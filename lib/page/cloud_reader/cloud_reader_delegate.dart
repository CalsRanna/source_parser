import 'package:source_parser/component/reader/reader_delegate.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/database/cloud_available_source_service.dart';
import 'package:source_parser/database/cloud_book_service.dart';
import 'package:source_parser/database/cloud_chapter_service.dart';
import 'package:source_parser/model/cloud_available_source_entity.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/model/cloud_chapter_entity.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/logger.dart';

class CloudReaderDelegate extends ReaderDelegate {
  CloudBookEntity book;

  List<CloudChapterEntity> chapters = [];
  List<CloudAvailableSourceEntity> availableSources = [];

  CloudReaderDelegate({required this.book});

  @override
  int get totalChapterCount => chapters.length;

  @override
  Future<ReaderInitialState> loadInitialState() async {
    await _loadChapterList();
    await _loadAvailableSources();
    return ReaderInitialState(
      bookName: book.name,
      totalChapterCount: chapters.length,
      initialChapterIndex: book.durChapterIndex,
      initialPageIndex: book.durChapterPos,
    );
  }

  @override
  String getChapterName(int index) => chapters[index].title;

  @override
  Future<String> fetchContent(int chapterIndex,
      {bool reacquire = false}) async {
    var chapterTitle =
        chapterIndex < chapters.length ? chapters[chapterIndex].title : '';
    var network = CachedNetwork(prefix: book.name);
    var url = chapters[chapterIndex].url;
    if (!reacquire) {
      var cached = await network.read(url);
      if (cached != null) {
        return '$chapterTitle\n\n$cached';
      }
    }
    var content = await CloudReaderApiClient().getBookContent(
      book.bookUrl,
      chapterIndex,
    );
    if (content.isEmpty) {
      return '$chapterTitle\n\n${StringConfig.emptyContent}';
    }
    await network.cache(url, content);
    return '$chapterTitle\n\n$content';
  }

  @override
  Future<void> saveProgress({
    required int chapterIndex,
    required int pageIndex,
  }) async {
    var title = '';
    if (chapterIndex < chapters.length) {
      title = chapters[chapterIndex].title;
    }
    await CloudBookService().updateProgress(
      book.bookUrl,
      chapterIndex,
      title,
      pageIndex,
    );
    try {
      await CloudReaderApiClient().saveBookProgress(
        book.bookUrl,
        chapterIndex,
      );
    } catch (e) {
      logger.e('同步进度失败: $e');
    }
  }

  @override
  Future<void> onLeave() async {
    // 云端的离场同步由宿主页面通过 syncProgress() 调用，
    // onLeave 本身不需要额外操作。
  }

  /// 供宿主页面在 deactivate 时调用，传入当前阅读位置。
  Future<void> syncProgress(int chapterIndex, int pageIndex) async {
    await saveProgress(chapterIndex: chapterIndex, pageIndex: pageIndex);
  }

  // --- 云端特有的辅助方法（供 ViewModel/Page 调用） ---

  Future<void> loadChapterList({bool forceRemote = false}) async {
    await _loadChapterList(forceRemote: forceRemote);
  }

  Future<void> loadAvailableSources() async {
    await _loadAvailableSources();
  }

  Future<void> switchSource(String newBookUrl) async {
    var oldBookUrl = book.bookUrl;
    book.bookUrl = newBookUrl;
    await CloudChapterService().deleteChapters(oldBookUrl);
    await CloudAvailableSourceService().deleteSources(oldBookUrl);
    await _loadChapterList(forceRemote: true);
    await _loadAvailableSources();
  }

  // --- Private helpers ---

  Future<void> _loadChapterList({bool forceRemote = false}) async {
    if (!forceRemote) {
      var local = await CloudChapterService().getChapters(book.bookUrl);
      if (local.isNotEmpty) {
        chapters = local;
        return;
      }
    }
    var remote = await CloudReaderApiClient().getChapterList(book.bookUrl);
    chapters = remote;
    await CloudChapterService().replaceChapters(book.bookUrl, remote);
  }

  Future<void> _loadAvailableSources() async {
    try {
      availableSources =
          await CloudAvailableSourceService().getSources(book.bookUrl);
    } catch (_) {}
  }
}
