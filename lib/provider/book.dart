import 'dart:math';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/available_source.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/parser.dart';

part 'book.g.dart';

@riverpod
class BookCovers extends _$BookCovers {
  @override
  Future<List<String>> build(Book book) async {
    if (book.covers.isNotEmpty) return book.covers;
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = setting.cacheDuration;
    final timeout = setting.timeout;
    List<String> covers = [];
    // for (var availableSource in book.sources) {
    //   final source =
    //       await isar.sources.filter().idEqualTo(availableSource.id).findFirst();
    //   if (source == null) continue;
    //   final information = await Parser.getInformation(
    //     book.name,
    //     availableSource.url,
    //     source,
    //     Duration(hours: duration.floor()),
    //     Duration(milliseconds: timeout),
    //   );
    //   final cover = information.cover;
    //   if (cover.isNotEmpty) {
    //     covers.add(cover);
    //   }
    // }
    final inShelf = await ref.read(inShelfProvider(book).future);
    if (inShelf) {
      var updatedBook = book.copyWith(covers: covers);
      isar.writeTxn(() async {
        isar.books.put(updatedBook);
      });
    }
    return covers;
  }
}

@Riverpod(keepAlive: true)
class BookNotifier extends _$BookNotifier {
  Future<String> addSource(String url) async {
    if (url.isEmpty) return '网址不能为空';
    // var availableSources = state.sources;
    // if (availableSources.any((source) => source.url == url)) return '网址已存在';
    // logger.d(url);
    // var host = Uri.parse(url).host;
    // logger.d(host);
    // final builder = isar.sources.filter();
    // final source = await builder.urlContains(host).findFirst();
    // if (source == null) return '未找到该网址对应的书源';
    // final setting = await ref.read(settingNotifierProvider.future);
    // final duration = setting.cacheDuration;
    // final timeout = setting.timeout;
    // var latestChapter = await Parser.getLatestChapter(
    //   state.name,
    //   url,
    //   source,
    //   Duration(hours: duration.floor()),
    //   Duration(milliseconds: timeout),
    // );
    // var availableSource = AvailableSource()
    //   ..id = source.id
    //   ..latestChapter = latestChapter
    //   ..name = source.name
    //   ..url = url;
    // state = state.copyWith(sources: [...availableSources, availableSource]);
    // await isar.writeTxn(() async {
    //   await isar.books.put(state);
    // });
    // ref.invalidate(booksProvider);
    return '添加成功';
  }

  @override
  Book build() {
    return Book();
  }

  void clearCache() {
    CacheManager(prefix: state.name).clearCache();
  }

  Future<String> getContent(int index, {bool reacquire = false}) async {
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(state.sourceId).findFirst();
    if (source == null) return '';
    final chapter = state.chapters.elementAt(index);
    final title = chapter.name;
    final url = chapter.url;
    final setting = await ref.read(settingNotifierProvider.future);
    final timeout = setting.timeout;
    return Parser.getContent(
      name: state.name,
      source: source,
      title: title,
      url: url,
      timeout: Duration(milliseconds: timeout),
      reacquire: reacquire,
    );
  }

  Future<List<String>> getCovers() async {
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = setting.cacheDuration;
    final timeout = setting.timeout;
    List<String> covers = [];
    // for (var availableSource in state.sources) {
    //   final source =
    //       await isar.sources.filter().idEqualTo(availableSource.id).findFirst();
    //   if (source == null) continue;
    //   final information = await Parser.getInformation(
    //     state.name,
    //     availableSource.url,
    //     source,
    //     Duration(hours: duration.floor()),
    //     Duration(milliseconds: timeout),
    //   );
    //   final cover = information.cover;
    //   if (cover.isNotEmpty) {
    //     covers.add(cover);
    //   }
    // }
    return covers;
  }

  Future<void> refreshCatalogue() async {
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(state.sourceId).findFirst();
    if (source == null) return;
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = setting.cacheDuration;
    final timeout = setting.timeout;
    var stream = await Parser.getChapters(
      state.name,
      state.catalogueUrl,
      source,
      Duration(hours: duration.floor()),
      Duration(milliseconds: timeout),
    );
    stream = stream.asBroadcastStream();
    List<Chapter> chapters = [];
    stream.listen((chapter) {
      chapters.add(chapter);
    });
    await stream.last;
    state = state.copyWith(chapters: chapters);
  }

  Future<void> refreshCover(String cover) async {
    state = state.copyWith(cover: cover);
    final inShelf = await ref.read(inShelfProvider(state).future);
    if (!inShelf) return;
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
    ref.invalidate(booksProvider);
  }

  Future<void> refreshCursor(int cursor) async {
    state = state.copyWith(cursor: cursor);
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
  }

  Future<void> refreshIndex(int index) async {
    state = state.copyWith(index: index);
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
  }

  Future<void> refreshInformation() async {
    final queryBuilder = isar.sources.filter();
    final sourceId = state.sourceId;
    final source = await queryBuilder.idEqualTo(sourceId).findFirst();
    if (source == null) return;
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = setting.cacheDuration;
    final timeout = setting.timeout;
    final information = await Parser.getInformation(
      state.name,
      state.url,
      source,
      Duration(hours: duration.floor()),
      Duration(milliseconds: timeout),
    );
    String? updatedIntroduction;
    if (information.introduction.length > state.introduction.length) {
      updatedIntroduction = information.introduction;
    }
    var stream = await Parser.getChapters(
      state.name,
      information.catalogueUrl,
      source,
      Duration(hours: duration.floor()),
      Duration(milliseconds: timeout),
    );
    stream = stream.asBroadcastStream();
    List<Chapter> chapters = [];
    stream.listen(
      (chapter) {
        chapters.add(chapter);
      },
    );
    await stream.last;
    String updatedCover = state.cover;
    if (updatedCover.isEmpty) {
      updatedCover = information.cover;
    }
    List<Chapter> updatedChapters = [];
    if (chapters.length > state.chapters.length) {
      final start = max(state.chapters.length - 1, 0);
      final end = max(chapters.length - 1, 0);
      updatedChapters = chapters.getRange(start, end).toList();
    }
    state = state.copyWith(
      catalogueUrl: information.catalogueUrl,
      category: information.category,
      chapters: [...state.chapters, ...updatedChapters],
      cover: updatedCover,
      introduction: updatedIntroduction,
      latestChapter: information.latestChapter,
      words: information.words,
    );
    final builder = isar.books.filter();
    final exist = await builder
        .nameEqualTo(state.name)
        .authorEqualTo(state.author)
        .findFirst();
    if (exist == null) return;
    state = exist.copyWith(
      catalogueUrl: state.catalogueUrl,
      category: state.category,
      chapters: state.chapters,
      cover: state.cover,
      introduction: state.introduction,
      latestChapter: state.latestChapter,
      words: state.words,
    );
  }

  Future<String> refreshSource(int index) async {
    return '';
    // final builder = isar.sources.filter();
    // final source = await builder.idEqualTo(state.sources[index].id).findFirst();
    // if (source == null) return '书源不存在';
    // if (source.id == state.sourceId) return '已在当前源';
    // try {
    //   final name = state.name;
    //   final url = state.sources[index].url;
    //   final setting = await ref.read(settingNotifierProvider.future);
    //   final duration = setting.cacheDuration;
    //   final timeout = setting.timeout;
    //   final information = await Parser.getInformation(
    //     name,
    //     url,
    //     source,
    //     Duration(hours: duration.floor()),
    //     Duration(milliseconds: timeout),
    //   );
    //   final catalogueUrl = information.catalogueUrl;
    //   var stream = await Parser.getChapters(
    //     name,
    //     catalogueUrl,
    //     source,
    //     Duration(hours: duration.floor()),
    //     Duration(milliseconds: timeout),
    //   );
    //   stream = stream.asBroadcastStream();
    //   List<Chapter> chapters = [];
    //   stream.listen(
    //     (chapter) {
    //       chapters.add(chapter);
    //     },
    //   );
    //   await stream.last;
    //   final length = chapters.length;
    //   var chapterIndex = state.index;
    //   var cursor = state.cursor;
    //   if (length <= chapterIndex) {
    //     chapterIndex = length - 1;
    //     cursor = 0;
    //   }
    //   state = state.copyWith(
    //     catalogueUrl: catalogueUrl,
    //     chapters: chapters,
    //     cursor: cursor,
    //     index: chapterIndex,
    //     sourceId: state.sources[index].id,
    //     url: url,
    //   );
    //   final inShelf = await ref.read(inShelfProvider(state).future);
    //   if (inShelf) {
    //     await isar.writeTxn(() async {
    //       isar.books.put(state);
    //     });
    //   }
    //   return '切换成功';
    // } catch (error) {
    //   return '切换失败:$error';
    // }
  }

  Future<void> refreshSources() async {
    // final setting = await ref.read(settingNotifierProvider.future);
    // final duration = setting.cacheDuration;
    // final maxConcurrent = setting.maxConcurrent;
    // final timeout = setting.timeout;
    // List<AvailableSource> sources = [...state.sources];
    // var stream = Parser.search(
    //   state.name,
    //   maxConcurrent.floor(),
    //   Duration(hours: duration.floor()),
    //   Duration(milliseconds: timeout),
    // );
    // stream = stream.asBroadcastStream();
    // stream.listen((book) async {
    //   var builder = isar.sources.filter();
    //   var source = await builder.idEqualTo(book.sourceId).findFirst();
    //   if (source == null) return;
    //   final sameAuthor = book.author == state.author;
    //   final sameName = book.name == state.name;
    //   if (sameAuthor && sameName) {
    //     if (book.latestChapter.isEmpty) {
    //       book.latestChapter = await Parser.getLatestChapter(
    //         book.name,
    //         book.url,
    //         source,
    //         Duration(hours: duration.floor()),
    //         Duration(milliseconds: timeout),
    //       );
    //     }
    //     final sameSource = sources.where((source) {
    //       return source.id == book.sourceId;
    //     }).firstOrNull;
    //     if (sameSource == null) {
    //       final builder = isar.sources.filter();
    //       var source = await builder.idEqualTo(book.sourceId).findFirst();
    //       if (source != null) {
    //         var availableSource = AvailableSource();
    //         availableSource.id = source.id;
    //         availableSource.latestChapter = book.latestChapter;
    //         availableSource.name = source.name;
    //         availableSource.url = book.url;
    //         sources.add(availableSource);
    //       }
    //     } else {
    //       final builder = isar.sources.filter();
    //       var source = await builder.idEqualTo(book.sourceId).findFirst();
    //       sameSource.name = source?.name ?? '';
    //       sameSource.latestChapter = book.latestChapter;
    //     }
    //   }
    // });
    // await stream.last;
    // state = state.copyWith(sources: sources);
    // final inShelf = await ref.read(inShelfProvider(state).future);
    // if (inShelf) {
    //   await isar.writeTxn(() async {
    //     isar.books.put(state);
    //   });
    // }
  }

  Future<void> resetSources() async {
    // state = state.copyWith(sources: []);
    // await isar.writeTxn(() async {
    //   isar.books.put(state);
    // });
  }

  Future<void> startReader({int? cursor, required int index}) async {
    state = state.copyWith(cursor: cursor, index: index);
    final notifier = ref.read(cacheProgressNotifierProvider.notifier);
    notifier.cacheChapters();
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
  }

  Future<void> updateChapter(int index) async {
    state = state.copyWith(cursor: 0, index: index);
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
  }

  Future<void> updateCursor(int cursor) async {
    state = state.copyWith(cursor: cursor);
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
  }

  Future<void> nextChapter() async {
    if (state.index + 1 >= state.chapters.length) return;
    state = state.copyWith(cursor: 0, index: state.index + 1);
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
  }

  Future<void> previousChapter() async {
    if (state.index <= 0) return;
    state = state.copyWith(cursor: 0, index: state.index - 1);
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
  }

  Future<void> toggleArchive() async {
    state = state.copyWith(archive: !state.archive);
    var builder = isar.books.filter();
    builder = builder.nameEqualTo(state.name);
    final exist = await builder.authorEqualTo(state.author).findFirst();
    if (exist == null) return;
    isar.writeTxn(() async {
      await isar.books.put(state);
    });
    ref.invalidate(booksProvider);
  }

  void update(Book book) {
    state = book;
  }
}

@riverpod
class Books extends _$Books {
  Future<bool> _exist(String url) async {
    var books = await future;
    List<AvailableSource> sources = [];
    // for (var book in books) {
    //   sources.addAll(book.sources);
    // }
    List<String> urls = [];
    for (var source in sources) {
      urls.add(source.url);
    }
    return urls.contains(url);
  }

  Future<void> addBook(String url) async {
    if (await _exist(url)) throw Exception('该网址对应的书籍已存在');
    var host = Uri.parse(url).host;
    final builder = isar.sources.filter();
    final source = await builder.urlContains(host).findFirst();
    if (source == null) throw Exception('未找到该网址对应的书源');
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = Duration(hours: setting.cacheDuration.floor());
    final timeout = Duration(milliseconds: setting.timeout);
    var book = await Parser.getInformation('', url, source, duration, timeout);
    var latestChapter = await Parser.getLatestChapter(
        book.name, url, source, duration, timeout);
    var availableSource = AvailableSource()
      ..id = source.id
      ..latestChapter = latestChapter
      ..name = source.name
      ..url = url;
    var books = await future;
    var sameBook = books.where((item) => item.name == book.name).firstOrNull;
    // if (sameBook != null) {
    //   sameBook.sources = [...sameBook.sources, availableSource];
    //   await isar.writeTxn(() async {
    //     await isar.books.put(sameBook);
    //   });
    // } else {
    //   book.sourceId = source.id;
    //   book.sources = [availableSource];
    //   var stream = await Parser.getChapters(
    //       book.name, book.catalogueUrl, source, duration, timeout);
    //   stream = stream.asBroadcastStream();
    //   List<Chapter> chapters = [];
    //   stream.listen((chapter) {
    //     chapters.add(chapter);
    //   });
    //   await stream.last;
    //   book.chapters = chapters;
    //   await isar.writeTxn(() async {
    //     await isar.books.put(book);
    //   });
    // }
    ref.invalidateSelf();
  }

  @override
  Future<List<Book>> build() async {
    final builder = isar.books.where();
    final books = await builder.findAll();
    books.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    FlutterNativeSplash.remove();
    return books;
  }

  Future<void> delete(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.delete(book.id);
    });
    CacheManager(prefix: book.name).clearCache();
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    final books = await future;
    for (var book in books) {
      if (book.archive) continue;
      final builder = isar.sources.filter();
      final source = await builder.idEqualTo(book.sourceId).findFirst();
      if (source == null) continue;
      final setting = await ref.read(settingNotifierProvider.future);
      final duration = setting.cacheDuration;
      var stream = await Parser.getChapters(
        book.name,
        book.catalogueUrl,
        source,
        Duration(hours: duration.floor()),
        Duration(milliseconds: setting.timeout),
      );
      stream = stream.asBroadcastStream();
      List<Chapter> chapters = [];
      stream.listen(
        (chapter) => chapters.add(chapter),
        onDone: () async {
          if (chapters.isEmpty) return;
          book.chapters = chapters;
          await isar.writeTxn(() async {
            isar.books.put(book);
          });
        },
      );
      await stream.last;
    }
    ref.invalidateSelf();
  }
}

@riverpod
class InShelf extends _$InShelf {
  @override
  Future<bool> build(Book book) async {
    var builder = isar.books.filter();
    builder = builder.nameEqualTo(book.name);
    return await builder.authorEqualTo(book.author).findFirst() != null;
  }

  Future<void> toggleShelf() async {
    final book = ref.read(bookNotifierProvider);
    final inShelf = await future;
    if (inShelf) {
      await isar.writeTxn(() async {
        await isar.books.delete(book.id);
      });
      CacheManager(prefix: book.name).clearCache();
    } else {
      await isar.writeTxn(() async {
        isar.books.put(book);
      });
    }
    final books = await isar.books.where().findAll();
    books.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    ref.invalidate(booksProvider);
    ref.invalidateSelf();
  }
}

@riverpod
class SearchBooks extends _$SearchBooks {
  @override
  List<Book> build(String credential) {
    return [];
  }

  Future<void> search() async {
    var provider = searchLoadingProvider(credential);
    var notifier = ref.read(provider.notifier);
    notifier.start();
    var setting = await ref.read(settingNotifierProvider.future);
    var duration = Duration(hours: setting.cacheDuration.floor());
    var timeout = Duration(milliseconds: setting.timeout);
    var maxConcurrent = setting.maxConcurrent.floor();
    var stream = Parser.search(credential, maxConcurrent, duration, timeout);
    stream.listen(_listenStream, onDone: () {
      notifier.stop();
    }, onError: (error) {
      logger.e(error);
    });
  }

  Book? _getExistingBook(Book book) {
    return state.where((item) {
      return item.name == book.name && item.author == book.author;
    }).firstOrNull;
  }

  Future<Book?> _getFilteredBook(Book book) async {
    final setting = await ref.read(settingNotifierProvider.future);
    if (!setting.searchFilter) return book;
    final conditionA = book.name.contains(credential);
    final conditionB = book.author.contains(credential);
    final filtered = conditionA || conditionB;
    return filtered ? book : null;
  }

  void _listenStream(Book book) async {
    final filteredBook = await _getFilteredBook(book);
    if (filteredBook == null) return;
    var existingBook = _getExistingBook(filteredBook);
    if (existingBook == null) {
      state = [...state, filteredBook];
      return;
    }
    // existingBook.sources.addAll(filteredBook.sources);
    if (filteredBook.cover.length > existingBook.cover.length) {
      existingBook.cover = filteredBook.cover;
    }
    if (filteredBook.introduction.length > existingBook.introduction.length) {
      existingBook.introduction = filteredBook.introduction;
    }
    state = [...state];
  }
}

@riverpod
class SearchLoading extends _$SearchLoading {
  @override
  bool build(String credential) {
    return false;
  }

  void start() {
    state = true;
  }

  void stop() {
    state = false;
  }
}
