import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:cached_network/cached_network.dart';
import 'package:charset/charset.dart';
import 'package:html_parser_plus/html_parser_plus.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';

class Parser {
  static Future<List<Book>> topSearch() async {
    final html = await CachedNetwork().request(
      'https://top.baidu.com/board?tab=novel',
      duration: const Duration(hours: 6),
    );
    final parser = HtmlParser();
    final node = parser.parse(html);
    final nodes = parser.queryNodes(
      node,
      '//div[@class="container-bg_lQ801"]/div/div[@class="category-wrap_iQLoo"]',
    );
    return nodes.map((node) {
      var book = Book();
      book.name = parser.query(
        node,
        '/div[@class="content_1YWBm"]/a/div@text|function:trim()',
      );
      return book;
    }).toList();
  }

  static Future<Stream<Book>> search(
    String credential,
  ) async {
    final controller = StreamController<Book>();
    final sources = await isar.sources.filter().enabledEqualTo(true).findAll();
    final cacheDirectory = await getTemporaryDirectory();
    final network = CachedNetwork(cacheDirectory: cacheDirectory);
    var closed = 0;
    for (var i = 0; i < sources.length; i++) {
      var sender = ReceivePort();
      var isolate = await Isolate.spawn(_searchInIsolate, sender.sendPort);
      var sendPort = await sender.first as SendPort;
      var receiver = ReceivePort();
      sendPort.send([
        network,
        sources[i],
        credential,
        receiver.sendPort,
      ]);
      receiver.forEach((element) async {
        if (element.runtimeType == Book) {
          controller.add(element);
        } else if (element == 'close') {
          isolate.kill();
          closed++;
          if (closed == sources.length) {
            controller.close();
          }
        }
      });
    }
    return controller.stream;
  }

  static void _searchInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      final source = message[1] as Source;
      var credential = message[2] as String;
      final send = message[3] as SendPort;
      try {
        final header = jsonDecode(source.header);
        if (header['Content-Type'] == 'application/x-www-form-urlencoded') {
          if (source.charset == 'gbk') {
            final codeUnits = gbk.encode(credential);
            credential = codeUnits.map((codeUnit) {
              return '%${codeUnit.toRadixString(16).padLeft(2, '0').toUpperCase()}';
            }).join();
          } else {
            credential = Uri.encodeComponent(credential);
          }
        }
      } catch (error) {
        // Do nothing
      }
      final searchUrl = source.searchUrl
          .replaceAll('{{credential}}', credential)
          .replaceAll('{{page}}', '1');
      final method = source.searchMethod.toUpperCase();
      var html = await network.request(
        searchUrl,
        charset: source.charset,
        duration: const Duration(hours: 6),
        method: method,
      );
      final parser = HtmlParser();
      var document = parser.parse(html);
      var items = parser.queryNodes(document, source.searchBooks);
      for (var i = 0; i < items.length; i++) {
        final author = parser.query(items[i], source.searchAuthor);
        final category = parser.query(items[i], source.searchCategory);
        var cover = parser.query(items[i], source.searchCover);
        if (!cover.startsWith('http')) {
          cover = '${source.url}$cover';
        }
        final introduction = parser.query(items[i], source.searchIntroduction);
        final name = parser.query(items[i], source.searchName);
        var url = parser.query(items[i], source.searchInformationUrl);
        if (!url.startsWith('http')) {
          url = '${source.url}$url';
        }
        if (name.isNotEmpty) {
          var availableSource = AvailableSource();
          availableSource.id = source.id;
          availableSource.name = source.name;
          availableSource.url = url;
          var book = Book();
          book.author = author;
          book.category = category;
          book.cover = cover;
          book.introduction = introduction;
          book.name = name;
          book.sourceId = source.id;
          book.sources = [availableSource];
          book.url = url;
          send.send(book);
        }
      }
      send.send('close');
    });
  }

  static Future<List<Book>> getExplore(
    String url,
    Map<String, dynamic> rule,
    Source source,
  ) async {
    final html = await CachedNetwork().request(
      url,
      charset: rule['charset'],
      duration: const Duration(hours: 6),
    );
    final parser = HtmlParser();
    final document = parser.parse(html);
    final nodes = parser.queryNodes(document, rule['list']);
    List<Book> books = [];
    for (var node in nodes) {
      final author = parser.query(node, rule['author']);
      final cover = parser.query(node, rule['cover']);
      final name = parser.query(node, rule['name']);
      final introduction = parser.query(node, rule['introduction']);
      url = parser.query(node, rule['url']);
      var availableSource = AvailableSource();
      availableSource.id = source.id;
      availableSource.name = source.name;
      availableSource.url = url;
      var book = Book();
      book.author = author;
      book.cover = cover;
      book.name = name;
      book.introduction = introduction;
      book.url = url;
      book.sourceId = source.id;
      book.sources = [availableSource];
      books.add(book);
    }
    return books;
  }

  Future<Book> getInformation(String url, Source source) async {
    final method = source.informationMethod.toUpperCase();
    final html = await CachedNetwork().request(
      url,
      charset: source.charset,
      duration: const Duration(hours: 6),
      method: method,
    );
    final parser = HtmlParser();
    final document = parser.parse(html);
    final author = parser.query(document, source.informationAuthor);
    var catalogueUrl = parser.query(document, source.informationCatalogueUrl);
    if (catalogueUrl.isEmpty) {
      catalogueUrl = url;
    }
    final category = parser.query(document, source.informationCategory);
    final cover = parser.query(document, source.informationCover);
    final introduction = parser.query(document, source.informationIntroduction);
    final latestChapter =
        parser.query(document, source.informationLatestChapter);
    final name = parser.query(document, source.informationName);
    final words = parser.query(document, source.informationWordCount);
    var book = Book();
    book.author = author;
    book.catalogueUrl = catalogueUrl;
    book.category = category;
    book.cover = cover;
    book.introduction = introduction;
    book.latestChapter = latestChapter;
    book.name = name;
    book.words = words;
    return book;
  }

  Future<List<Chapter>> getChapters(String url, Source source) async {
    final method = source.catalogueMethod.toUpperCase();
    final html = await CachedNetwork().request(
      url,
      charset: source.charset,
      duration: const Duration(hours: 6),
      method: method,
    );
    final parser = HtmlParser();
    final document = parser.parse(html);
    final items = parser.queryNodes(document, source.catalogueChapters);
    List<Chapter> chapters = [];
    for (var i = 0; i < items.length; i++) {
      final name = parser.query(items[i], source.catalogueName);
      var url = parser.query(items[i], source.catalogueUrl);
      if (!url.startsWith('http')) {
        url = '${source.url}$url';
      }
      var chapter = Chapter();
      chapter.name = name;
      chapter.url = url;
      chapters.add(chapter);
    }
    return chapters;
  }

  Future<String> getLatestChapter(String url, Source source) async {
    final book = await getInformation(url, source);
    final chapters = await getChapters(book.catalogueUrl, source);
    if (chapters.isNotEmpty) {
      return chapters.last.name;
    } else {
      return '解析失败';
    }
  }

  Future<String> getContent({
    required String url,
    required Source source,
    required String title,
    bool reacquire = false,
  }) async {
    final method = source.contentMethod.toUpperCase();
    final html = await CachedNetwork().request(
      url,
      charset: source.charset,
      method: method,
      reacquire: reacquire,
    );
    final parser = HtmlParser();
    final document = parser.parse(html);
    final content = parser.query(document, source.contentContent);
    return '$title\n\n$content';
  }

  Future<DebugResult> debug(String credential, Source source) async {
    var result = DebugResult();
    final network = CachedNetwork();
    // // 调试搜索解析规则
    try {
      final header = jsonDecode(source.header);
      if (header['Content-Type'] == 'application/x-www-form-urlencoded') {
        if (source.charset == 'gbk') {
          final codeUnits = gbk.encode(credential);
          credential = codeUnits.map((codeUnit) {
            return '%${codeUnit.toRadixString(16).padLeft(2, '0').toUpperCase()}';
          }).join();
        } else {
          credential = Uri.encodeComponent(credential);
        }
      }
    } catch (error) {
      // Do nothing
    }
    final searchUrl = source.searchUrl
        .replaceAll('{{credential}}', credential)
        .replaceAll('{{page}}', '1');
    var html = await network.request(
      searchUrl,
      charset: source.charset,
      duration: const Duration(hours: 6),
      method: source.searchMethod.toUpperCase(),
      reacquire: true,
    );
    result.searchRaw = html;
    final parser = HtmlParser();
    var document = parser.parse(html);
    var items = parser.queryNodes(document, source.searchBooks);
    var books = <Book>[];
    for (var i = 0; i < items.length; i++) {
      final author = parser.query(items[i], source.searchAuthor);
      final category = parser.query(items[i], source.searchCategory);
      var cover = parser.query(items[i], source.searchCover);
      if (!cover.startsWith('http')) {
        cover = '${source.url}$cover';
      }
      final introduction = parser.query(items[i], source.searchIntroduction);
      final name = parser.query(items[i], source.searchName);
      var url = parser.query(items[i], source.searchInformationUrl);
      if (!url.startsWith('http')) {
        url = '${source.url}$url';
      }
      if (name.isNotEmpty) {
        var availableSource = AvailableSource();
        availableSource.id = source.id;
        availableSource.name = source.name;
        availableSource.url = url;
        var book = Book();
        book.author = author;
        book.category = category;
        book.cover = cover;
        book.introduction = introduction;
        book.name = name;
        book.sourceId = source.id;
        book.sources = [availableSource];
        book.url = url;
        books.add(book);
      }
    }
    result.searchBooks = books;
    if (books.isNotEmpty) {
      // 调试详情规则解析
      var informationUrl = books.first.url;
      html = await network.request(
        informationUrl,
        charset: source.charset,
        duration: const Duration(hours: 6),
        method: source.informationMethod.toUpperCase(),
        reacquire: true,
      );
      result.informationRaw = html;
      document = parser.parse(html);
      var name = parser.query(document, source.informationName);
      var author = parser.query(document, source.informationAuthor);
      var cover = parser.query(document, source.informationCover);
      var category = parser.query(document, source.informationCategory);
      var catalogueUrl = parser.query(document, source.informationCatalogueUrl);
      if (catalogueUrl.isEmpty) {
        catalogueUrl = informationUrl;
      }
      var introduction = parser.query(document, source.informationIntroduction);

      var availableSource = AvailableSource();
      availableSource.id = source.id;
      availableSource.name = source.name;
      availableSource.url = books.first.url;
      var book = Book();
      book.author = author;
      book.catalogueUrl = catalogueUrl;
      book.category = category;
      book.cover = cover;
      book.introduction = introduction;
      book.name = name;
      book.sourceId = source.id;
      book.sources = [availableSource];
      book.url = books.first.url;
      result.informationBook = [book];
      // 调试目录解析规则
      if (catalogueUrl.isEmpty) {
        catalogueUrl = informationUrl;
      }
      html = await network.request(
        catalogueUrl,
        charset: source.charset,
        duration: const Duration(hours: 6),
        method: source.catalogueMethod.toUpperCase(),
        reacquire: true,
      );
      result.catalogueRaw = html;
      document = parser.parse(html);
      items = parser.queryNodes(document, source.catalogueChapters);
      var chapters = <Chapter>[];
      for (var i = 0; i < items.length; i++) {
        final name = parser.query(items[i], source.catalogueName);
        var url = parser.query(items[i], source.catalogueUrl);
        if (!url.startsWith('http')) {
          url = '${source.url}$url';
        }
        var chapter = Chapter();
        chapter.name = name;
        chapter.url = url;
        chapters.add(chapter);
      }
      result.catalogueChapters = chapters;
      // 调试正文解析规则
      if (chapters.isNotEmpty) {
        html = await network.request(
          chapters.first.url,
          charset: source.charset,
          duration: const Duration(hours: 6),
          method: source.contentMethod.toUpperCase(),
          reacquire: false,
        );
        result.contentRaw = html;
        document = parser.parse(html);
        var content = parser.query(document, source.contentContent);
        result.contentContent = content;
      }
    }
    return result;
  }

  Future<List<Source>> importNetworkSource(String url) async {
    final network = CachedNetwork();
    final html = await network.request(url, reacquire: true);
    final parser = HtmlParser();
    final document = parser.parse(html);
    final raw = parser.query(document, '/@text');
    final json = jsonDecode(raw);
    List<Source> sources = [];
    if (json is List) {
      for (var element in json) {
        sources.add(Source.fromJson(element));
      }
    } else {
      sources.add(Source.fromJson(json));
    }
    return sources;
  }
}
