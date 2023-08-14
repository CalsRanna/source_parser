import 'dart:async';
import 'dart:isolate';

import 'package:cached_network/cached_network.dart';
import 'package:html_parser_plus/html_parser_plus.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/model/chapter.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/schema/source.dart';

class Parser {
  static Future<List<History>> topSearch() async {
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
    return nodes
        .map((node) => History()
          ..name = parser.query(
            node,
            '/div[@class="content_1YWBm"]/a/div@text',
          ))
        .toList();
  }

  static Future<Stream<Book>> search(
    String credential,
  ) async {
    final controller = StreamController<Book>();
    final sources = await isar.sources.filter().enabledEqualTo(true).findAll();
    final cacheDirectory = await getTemporaryDirectory();
    final network = CachedNetwork(cacheDirectory: cacheDirectory);
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
      receiver.forEach((element) {
        if (element.runtimeType == Book) {
          controller.add(element);
        } else if (element == 'close') {
          isolate.kill();
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
          ?.replaceAll('{{credential}}', credential)
          .replaceAll('{{page}}', '1');
      var html = await network.request(
        searchUrl ?? '',
        charset: source.charset,
        duration: const Duration(hours: 6),
      );
      final parser = HtmlParser();
      var document = parser.parse(html);
      var items = parser.queryNodes(document, source.searchBooks);
      for (var i = 0; i < items.length; i++) {
        final author = parser.query(items[i], source.searchAuthor);
        final category = parser.query(items[i], source.searchCategory);
        var cover = parser.query(items[i], source.searchCover);
        if (!cover.startsWith('http')) {
          cover = '${source.url ?? ''}$cover';
        }
        final introduction = parser.query(items[i], source.searchIntroduction);
        final name = parser.query(items[i], source.searchName);
        var url = parser.query(items[i], source.searchInformationUrl);
        if (!url.startsWith('http')) {
          url = '${source.url ?? ''}$url';
        }
        if (name.isNotEmpty) {
          send.send(
            Book(
              author: author,
              catalogueUrl: '',
              category: category,
              cover: cover,
              introduction: introduction,
              name: name,
              sourceId: source.id,
              url: url,
            ),
          );
        }
      }
      send.send('close');
    });
  }

  Future<List<Chapter>> getChapters({
    required String url,
    required Source source,
  }) async {
    final html = await CachedNetwork().request(url);
    final parser = HtmlParser();
    final document = parser.parse(html);
    final items = parser.queryNodes(document, source.catalogueChapters);
    List<Chapter> chapters = [];
    for (var i = 0; i < items.length; i++) {
      final name = parser.query(items[i], source.catalogueName);
      var url = parser.query(items[i], source.catalogueUrl);
      if (!url.startsWith('http')) {
        url = '${source.url ?? ''}$url';
      }
      chapters.add(Chapter(name: name, url: url));
    }
    return chapters;
  }

  Future<String> getContent({
    required String url,
    required Source source,
  }) async {
    final html = await CachedNetwork().request(url);
    final parser = HtmlParser();
    final document = parser.parse(html);
    final content = parser.query(document, source.contentContent);
    return content;
  }

  static Future<Stream<History>> fetch(
    History history,
  ) async {
    final controller = StreamController<History>();
    // var source = await database.bookSourceDao.getBookSource(book.sourceId!);
    // var rules = await database.ruleDao.getRulesBySourceId(source!.id!);
    // var informationRule = InformationRule.fromJson(rules.toJson());
    // var sender = ReceivePort();
    // var isolate = await Isolate.spawn(_fetchInIsolate, sender.sendPort);
    // var sendPort = await sender.first as SendPort;
    // var reciver = ReceivePort();
    // sendPort.send([
    //   source,
    //   informationRule,
    //   book,
    //   folder,
    //   reciver.sendPort,
    // ]);
    // reciver.forEach((element) {
    //   if (element.runtimeType == Book) {
    //     controller.add(element);
    //   } else if (element == 'close') {
    //     isolate.kill();
    //   }
    // });

    return controller.stream;
  }

  // static void _fetchInIsolate(SendPort message) {
  //   final port = ReceivePort();
  //   message.send(port.sendPort);
  //   port.listen((message) async {
  //     // final source = message[0] as BookSource;
  //     // final rule = message[1] as InformationRule;
  //     // final book = message[2] as Book;
  //     // final folder = message[3] as Directory;
  //     final send = message[4] as SendPort;

  //     // var charset = CachedNetworkCharset.utf8;
  //     // if (source.charset != 'utf8') {
  //     //   charset = CachedNetworkCharset.gbk;
  //     // }
  //     // final response = await CachedNetwork(
  //     //   baseUrl: source.url,
  //     //   cacheFolder: folder,
  //     //   charset: charset,
  //     // ).get(book.url!, permanent: false);
  //     // var document = HtmlXPath.html(response ?? '').root;
  //     // final author = XPathParser.parse(document, rule.author);
  //     // final catalogueUrl = XPathParser.parse(document, rule.catalogueUrl);
  //     // final category = XPathParser.parse(document, rule.category);
  //     // final cover = XPathParser.parse(document, rule.cover);
  //     // final introduction = XPathParser.parse(document, rule.introduction);
  //     // final name = XPathParser.parse(document, rule.name);
  //     // send.send(Book(
  //     //   author: author,
  //     //   catalogueUrl: catalogueUrl,
  //     //   category: category,
  //     //   cover: cover,
  //     //   introduction: introduction,
  //     //   name: name,
  //     //   url: book.url,
  //     //   sourceId: book.sourceId,
  //     // ));
  //     send.send('close');
  //   });
  // }

  Future<DebugResult> debug(String credential, Source source) async {
    var result = DebugResult(
      searchRaw: '',
      searchBooks: [],
      informationBook: null,
      informationRaw: '',
      catalogueRaw: '',
      catalogueChapters: [],
      contentRaw: '',
      contentContent: '',
    );
    final network = CachedNetwork();
    // // 调试搜索解析规则
    final searchUrl = source.searchUrl
        ?.replaceAll('{{credential}}', credential)
        .replaceAll('{{page}}', '1');
    var html = await network.request(
      searchUrl ?? '',
      charset: source.charset,
      duration: const Duration(hours: 6),
      // reacquire: true,
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
        cover = '${source.url ?? ''}$cover';
      }
      final introduction = parser.query(items[i], source.searchIntroduction);
      final name = parser.query(items[i], source.searchName);
      var url = parser.query(items[i], source.searchInformationUrl);
      if (!url.startsWith('http')) {
        url = '${source.url ?? ''}$url';
      }
      if (name.isNotEmpty) {
        books.add(
          Book(
            author: author,
            catalogueUrl: '',
            category: category,
            cover: cover,
            introduction: introduction,
            name: name,
            sourceId: source.id,
            url: url,
          ),
        );
      }
    }
    result.searchBooks = books;
    if (books.isNotEmpty) {
      // 调试详情规则解析
      var informationUrl = books.first.url;
      html = await network.request(informationUrl);
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
        url: books.first.url,
      );
      result.informationBook = book;
      // 调试目录解析规则
      if (catalogueUrl.isEmpty) {
        catalogueUrl = informationUrl;
      }
      html = await network.request(catalogueUrl);
      result.catalogueRaw = html;
      document = parser.parse(html);
      items = parser.queryNodes(document, source.catalogueChapters);
      var chapters = <Chapter>[];
      for (var i = 0; i < items.length; i++) {
        final name = parser.query(items[i], source.catalogueName);
        var url = parser.query(items[i], source.catalogueUrl);
        if (!url.startsWith('http')) {
          url = '${source.url ?? ''}$url';
        }
        chapters.add(
          Chapter(
            name: name,
            url: url,
          ),
        );
      }
      result.catalogueChapters = chapters;
      // 调试正文解析规则
      if (chapters.isNotEmpty) {
        html = await network.request(chapters.first.url);
        result.contentRaw = html;
        document = parser.parse(html);
        var content = parser.query(document, source.contentContent);
        result.contentContent = content;
      }
    }
    return result;
  }
}
