import 'dart:async';

import 'package:cached_network/cached_network.dart';
import 'package:html_parser_plus/html_parser_plus.dart';
import 'package:logger/logger.dart';
import 'package:source_parser/model/history.dart';
import 'package:source_parser/model/source.dart';

class Parser {
  static Future<List<History>> topSearch() async {
    final html = await CachedNetwork().request(
      'https://top.baidu.com/board?tab=novel',
      duration: const Duration(hours: 6),
    );
    final parser = HtmlParser();
    final node = parser.query(html);
    final nodes = parser.parseNodes(
      node,
      '//div[@class="container-bg_lQ801"]/div/div[@class="category-wrap_iQLoo"]',
    );
    return nodes
        .map((node) => History()
          ..name = parser.parse(
            node,
            '/div[@class="content_1YWBm"]/a/div@text',
          ))
        .toList();
  }

  static Future<Stream<History>> search(
    String credential,
  ) async {
    final controller = StreamController<History>();
    // for (var i = 0; i < sources.length; i++) {
    //   var sender = ReceivePort();
    //   var isolate = await Isolate.spawn(_searchInIsolate, sender.sendPort);
    //   var sendPort = await sender.first as SendPort;
    //   var reciver = ReceivePort();
    //   sendPort.send([
    //     sources[i],
    //     credential,
    //     folder,
    //     reciver.sendPort,
    //   ]);
    //   reciver.forEach((element) {
    //     if (element.runtimeType == History) {
    //       controller.add(element);
    //     } else if (element == 'close') {
    //       isolate.kill();
    //     }
    //   });
    // }
    return controller.stream;
  }

  // static void _searchInIsolate(SendPort message) {
  //   final port = ReceivePort();
  //   message.send(port.sendPort);
  //   port.listen((message) async {
  //     // final source = message[0] as BookSource;
  //     // final rule = message[1] as SearchRule;
  //     // final credential = message[2] as String;
  //     // final folder = message[3] as Directory;
  //     final send = message[4] as SendPort;

  //     // var url = source.searchUrl;
  //     // if (url?.startsWith('http') == false) {
  //     //   url = source.url + (source.searchUrl ?? '');
  //     // }
  //     // url = url?.replaceAll('{{credential}}', credential) ?? '';
  //     // var charset = CachedNetworkCharset.utf8;
  //     // if (source.charset != 'utf8') {
  //     //   charset = CachedNetworkCharset.gbk;
  //     // }
  //     // final response = await CachedNetwork(
  //     //   baseUrl: source.url,
  //     //   cacheFolder: folder,
  //     //   charset: charset,
  //     // ).get(url, permanent: false);
  //     // // var document = parseHtmlDocument(response.data);
  //     // // final items = document.querySelectorAll(searchRule.books ?? '');
  //     // // for (var i = 0; i < items.length; i++) {
  //     // //   final name = items[i].querySelector(searchRule.name ?? '')?.text;
  //     // //   send.send(Book(name: name));
  //     // // }
  //     // final document = HtmlXPath.html(response ?? '').root;
  //     // final items = document.queryXPath(rule.books ?? '').nodes;
  //     // for (var item in items) {
  //     //   final author = XPathParser.parse(item, rule.author);
  //     //   final cover = XPathParser.parse(item, rule.cover);
  //     //   final name = XPathParser.parse(item, rule.name);
  //     //   var url = XPathParser.parse(item, rule.url);
  //     //   if (url != null && url.startsWith('http') == false) {
  //     //     url = '${source.url}$url';
  //     //   }
  //     //   send.send(Book(
  //     //     author: author,
  //     //     cover: cover,
  //     //     name: name,
  //     //     url: url,
  //     //     sourceId: source.id,
  //     //   ));
  //     // }
  //     send.send('close');
  //   });
  // }

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

  Future<dynamic> debug(String credential, Source source) async {
    final logger = Logger();
    final start = DateTime.now().millisecondsSinceEpoch;
    logger.d('开始调试');
    // final network = CachedNetwork();
    // // 调试搜索解析规则
    logger.d('开始调试搜索解析规则');
    // final searchUrl = source.searchUrl
    //         ?.replaceAll('{{credential}}', credential)
    //         .replaceAll('{{page}}', '1') ??
    '';
    // var html = await network.request(
    //   searchUrl,
    //   duration: const Duration(hours: 6),
    // );
    // final parser = HtmlParser();
    // final document = parser.query(html);
    // final nodes = parser.parseNodes(document, source.searchBooks);

    // var books = <Book>[];
    // for (var i = 0; i < items.length; i++) {
    //   final author = XPathParser.parse(items[i], searchRule?.author);
    //   final cover = XPathParser.parse(items[i], searchRule?.cover);
    //   final name = XPathParser.parse(items[i], searchRule?.name);
    //   final url = XPathParser.parse(items[i], searchRule?.url);
    //   books.add(Book(author: author, cover: cover, name: name, url: url));
    // }
    // result = result.copyWith(
    //   searchResponse: response,
    //   searchBooks: books,
    // );
    // 调试详情规则解析
    logger.d('开始调试详情解析规则');
    // if (books.isNotEmpty) {
    //   final informationUrl = books.first.url ?? '';
    //   response = await network.get(informationUrl);
    //   document = HtmlXPath.html(response ?? '').root;
    //   var name = XPathParser.parse(document, informationRule?.name);
    //   var author = XPathParser.parse(document, informationRule?.author);
    //   var cover = XPathParser.parse(document, informationRule?.cover);
    //   var category = XPathParser.parse(document, informationRule?.category);
    //   var catalogueUrl =
    //       XPathParser.parse(document, informationRule?.catalogueUrl);
    //   var introduction =
    //       XPathParser.parse(document, informationRule?.introduction);
    //   final book = Book(
    //     name: name,
    //     author: author,
    //     category: category,
    //     cover: cover,
    //     catalogueUrl: catalogueUrl,
    //     introduction: introduction,
    //     url: books.first.url,
    //   );
    //   result = result.copyWith(
    //     informationResponse: response,
    //     informationBook: book,
    //   );
    // 调试目录解析规则
    logger.d('开始调试目录解析规则');
    // catalogueUrl = catalogueUrl ?? books.first.url ?? '';
    // response = await network.get(catalogueUrl);
    // document = HtmlXPath.html(response ?? '').root;
    // items = document.queryXPath(catalogueRule?.chapters ?? '').nodes;
    // var chapters = <Chapter>[];
    // for (var node in items) {
    //   final name = XPathParser.parse(node, catalogueRule?.name);
    //   final url = XPathParser.parse(node, catalogueRule?.url);
    //   chapters.add(Chapter(name: name, url: url));
    // }
    // result = result.copyWith(
    //   catalogueResponse: response,
    //   catalogueChapters: chapters,
    // );
    // 调试正文解析规则
    logger.d('开始调试正文解析规则');
    // final contentUrl = chapters.first.url ?? '';
    // response = await network.get(contentUrl);
    // document = HtmlXPath.html(response ?? '').root;
    // var content = XPathParser.parse(document, contentRule?.content);
    // final chapter = Chapter(
    //   name: chapters.first.name,
    //   content: content,
    //   url: chapters.first.url,
    // );
    // result = result.copyWith(
    //   contentResponse: response,
    //   contentChapter: chapter,
    // );
    // }
    final end = DateTime.now().millisecondsSinceEpoch;
    logger.d('结束调试,耗时${end - start}毫秒');
    return null;
  }
}

// class XPathParser {
//   static String? parse(XPathNode node, String? rule) {
//     if (rule == null) {
//       return null;
//     }
//     var attribute = rule.split('@').last;
//     var matchedNode = node.queryXPath(rule.replaceAll('@$attribute', '')).node;
//     if (attribute == 'text') {
//       return matchedNode?.text;
//     } else {
//       return matchedNode?.attributes[attribute];
//     }
//   }
// }
