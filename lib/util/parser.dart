import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:cached_network/cached_network.dart';
import 'package:html_parser_plus/html_parser_plus.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/model/chapter.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/model/source.dart';
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
      final name = parser.query(
        node,
        '/div[@class="content_1YWBm"]/a/div@text',
      );
      return Book(name: name.trim());
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
      final credential = message[2] as String;
      final send = message[3] as SendPort;

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
          send.send(
            Book(
              author: author,
              category: category,
              cover: cover,
              introduction: introduction,
              name: name,
              sourceId: source.id,
              sources: [
                AvailableSource(id: source.id, name: source.name, url: url)
              ],
              url: url,
            ),
          );
        }
      }
      send.send('close');
    });
  }

  Future<Book> getInformation(String url, Source source) async {
    final method = source.informationMethod.toUpperCase();
    final html = await CachedNetwork().request(
      url,
      charset: source.charset,
      method: method,
    );
    final parser = HtmlParser();
    final document = parser.parse(html);
    final author = parser.query(document, source.informationAuthor);
    final catalogueUrl = parser.query(document, source.informationCatalogueUrl);
    final category = parser.query(document, source.informationCategory);
    final cover = parser.query(document, source.informationCover);
    final introduction = parser.query(document, source.informationIntroduction);
    final latestChapter =
        parser.query(document, source.informationLatestChapter);
    final name = parser.query(document, source.informationName);
    final words = parser.query(document, source.informationWordCount);
    return Book(
      author: author,
      catalogueUrl: catalogueUrl,
      category: category,
      cover: cover,
      introduction: introduction,
      latestChapter: latestChapter,
      name: name,
      words: words,
    );
  }

  Future<List<Chapter>> getChapters(String url, Source source) async {
    final method = source.catalogueMethod.toUpperCase();
    final html = await CachedNetwork().request(
      url,
      charset: source.charset,
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
      chapters.add(Chapter(name: name, url: url));
    }
    return chapters;
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
        books.add(
          Book(
            author: author,
            category: category,
            cover: cover,
            introduction: introduction,
            name: name,
            sourceId: source.id,
            sources: [
              AvailableSource(id: source.id, name: source.name, url: url)
            ],
            url: url,
          ),
        );
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
      var introduction = parser.query(document, source.informationIntroduction);
      final book = Book(
        name: name,
        author: author,
        category: category,
        cover: cover,
        catalogueUrl: catalogueUrl,
        introduction: introduction,
        sourceId: source.id,
        sources: [
          AvailableSource(
            id: source.id,
            name: source.name,
            url: books.first.url,
          )
        ],
        url: books.first.url,
      );
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
        chapters.add(Chapter(name: name, url: url));
      }
      result.catalogueChapters = chapters;
      // 调试正文解析规则
      if (chapters.isNotEmpty) {
        html = await network.request(
          chapters.first.url,
          charset: source.charset,
          duration: const Duration(hours: 6),
          method: source.contentMethod.toUpperCase(),
          reacquire: true,
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
