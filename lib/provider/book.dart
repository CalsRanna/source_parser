import 'dart:math';

import 'package:cached_network/cached_network.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';

part 'book.g.dart';

@Riverpod(keepAlive: true)
class BookNotifier extends _$BookNotifier {
  @override
  Book build() {
    return Book();
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
    for (var availableSource in state.sources) {
      final source =
          await isar.sources.filter().idEqualTo(availableSource.id).findFirst();
      if (source == null) continue;
      final information = await Parser.getInformation(
        state.name,
        availableSource.url,
        source,
        Duration(hours: duration.floor()),
        Duration(milliseconds: timeout),
      );
      final cover = information.cover;
      if (cover.isNotEmpty) {
        covers.add(cover);
      }
    }
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
    final inShelf = await ref.read(inShelfProvider.future);
    if (!inShelf) return;
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
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
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(state.sources[index].id).findFirst();
    if (source == null) return '书源不存在';
    if (source.id == state.sourceId) return '已在当前源';
    try {
      final name = state.name;
      final url = state.sources[index].url;
      final setting = await ref.read(settingNotifierProvider.future);
      final duration = setting.cacheDuration;
      final timeout = setting.timeout;
      final information = await Parser.getInformation(
        name,
        url,
        source,
        Duration(hours: duration.floor()),
        Duration(milliseconds: timeout),
      );
      final catalogueUrl = information.catalogueUrl;
      var stream = await Parser.getChapters(
        name,
        catalogueUrl,
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
      final length = chapters.length;
      var chapterIndex = state.index;
      var cursor = state.cursor;
      if (length <= chapterIndex) {
        chapterIndex = length - 1;
        cursor = 0;
      }
      state = state.copyWith(
        catalogueUrl: catalogueUrl,
        chapters: chapters,
        cursor: cursor,
        index: chapterIndex,
        sourceId: state.sources[index].id,
        url: url,
      );
      final inShelf = await ref.read(inShelfProvider.future);
      if (inShelf) {
        await isar.writeTxn(() async {
          isar.books.put(state);
        });
      }
      return '切换成功';
    } catch (error) {
      return '切换失败:$error';
    }
  }

  Future<void> refreshSources() async {
    final setting = await ref.read(settingNotifierProvider.future);
    final duration = setting.cacheDuration;
    final maxConcurrent = setting.maxConcurrent;
    final timeout = setting.timeout;
    List<AvailableSource> sources = [];
    var stream = await Parser.search(
      state.name,
      maxConcurrent.floor(),
      Duration(hours: duration.floor()),
      Duration(milliseconds: timeout),
    );
    stream = stream.asBroadcastStream();
    stream.listen((book) async {
      final sameAuthor = book.author == state.author;
      final sameName = book.name == state.name;
      final sameSource = sources.where((source) {
        return source.id == book.sourceId;
      }).isNotEmpty;
      if (sameAuthor && sameName && !sameSource) {
        final builder = isar.sources.filter();
        final source = await builder.idEqualTo(book.sourceId).findFirst();
        if (source != null) {
          var availableSource = AvailableSource();
          availableSource.id = source.id;
          availableSource.url = book.url;
          sources.add(availableSource);
        }
      }
    });
    await stream.last;
    state = state.copyWith(sources: sources);
    final inShelf = await ref.read(inShelfProvider.future);
    if (inShelf) {
      await isar.writeTxn(() async {
        isar.books.put(state);
      });
    }
  }

  Future<void> resetSources() async {
    state = state.copyWith(sources: []);
    await isar.writeTxn(() async {
      isar.books.put(state);
    });
  }

  Future<void> startReader({int? cursor, required int index}) async {
    state = state.copyWith(cursor: cursor, index: index);
    final notifier = ref.read(cacheProgressNotifierProvider.notifier);
    notifier.cacheChapters();
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
  }

  void update(Book book) {
    state = book;
  }
}

@riverpod
class Books extends _$Books {
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
  Future<bool> build() async {
    final book = ref.watch(bookNotifierProvider);
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
