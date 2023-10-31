import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:cached_network/cached_network.dart';
import 'package:charset/charset.dart';
import 'package:html_parser_plus/html_parser_plus.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/model/explore.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/semaphore.dart';

class Parser {
  static Future<List<Book>> topSearch(Duration duration) async {
    final html = await CachedNetwork().request(
      'https://top.baidu.com/board?tab=novel',
      duration: duration,
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

  static Future<List<Book>> today(Duration duration) async {
    final html = await CachedNetwork().request(
      'https://www.yousuu.com/rank/today',
      duration: duration,
    );
    final parser = HtmlParser();
    final node = parser.parse(html);
    const listRule =
        '//div[contains(@class,"result-item-layout")]@nodes|dart.sublist(0,15)';
    var nodes = parser.queryNodes(node, listRule);
    return nodes.toSet().map((node) {
      var book = Book();
      book.name = parser.query(node, '//a[@class="book-name"]@text');
      return book;
    }).toList();
  }

  static Future<Stream<Book>> search(
    String credential,
    int maxConcurrent,
    Duration duration,
  ) async {
    final sources = await isar.sources.filter().enabledEqualTo(true).findAll();
    final temporaryDirectory = await getTemporaryDirectory();
    final network = CachedNetwork(temporaryDirectory: temporaryDirectory);
    var closed = 0;
    final controller = StreamController<Book>();
    final semaphore = Semaphore(maxConcurrent);
    for (var source in sources) {
      await semaphore.acquire();
      final sender = ReceivePort();
      final receiver = ReceivePort();
      final isolate = await Isolate.spawn(_searchInIsolate, sender.sendPort);
      (await sender.first as SendPort).send(
        [network, duration, source, credential, receiver.sendPort],
      );
      receiver.forEach((element) async {
        if (element is Book) {
          controller.add(element);
        } else {
          isolate.kill();
          closed++;
          semaphore.release();
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
      final duration = message[1] as Duration;
      final source = message[2] as Source;
      var credential = message[3] as String;
      final sender = message[4] as SendPort;
      try {
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
          duration: duration,
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
          final introduction =
              parser.query(items[i], source.searchIntroduction);
          final name = parser.query(items[i], source.searchName);
          var url = parser.query(items[i], source.searchInformationUrl);
          if (!url.startsWith('http')) {
            url = '${source.url}$url';
          }
          if (name.isNotEmpty) {
            var availableSource = AvailableSource();
            availableSource.id = source.id;
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
            sender.send(book);
          }
        }
        sender.send('close');
      } catch (error) {
        sender.send(error.toString());
      }
    });
  }

  static Future<Stream<ExploreResult>> getExplore(
    Source source,
    Duration duration,
  ) async {
    final temporaryDirectory = await getTemporaryDirectory();
    final network = CachedNetwork(temporaryDirectory: temporaryDirectory);
    var closed = 0;
    final controller = StreamController<ExploreResult>();
    final rules = jsonDecode(source.exploreJson);
    for (var rule in rules) {
      final sender = ReceivePort();
      final receiver = ReceivePort();
      final isolate = await Isolate.spawn(
        _getExploreInIsolate,
        sender.sendPort,
      );
      final exploreUrl = rule['exploreUrl'];
      (await sender.first as SendPort).send(
        [network, duration, rule, exploreUrl, source, receiver.sendPort],
      );
      receiver.forEach((element) async {
        if (element.runtimeType == ExploreResult) {
          controller.add(element);
        } else {
          isolate.kill();
          closed++;
          if (closed == rules.length) {
            controller.close();
          }
        }
      });
    }
    return controller.stream;
  }

  static void _getExploreInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      final duration = message[1] as Duration;
      final rule = message[2] as Map<String, dynamic>;
      final exploreUrl = message[3] as String;
      final source = message[4] as Source;
      final sender = message[5] as SendPort;
      try {
        final html = await network.request(
          exploreUrl,
          charset: rule['charset'],
          duration: duration,
        );
        final parser = HtmlParser();
        final document = parser.parse(html);
        final nodes = parser.queryNodes(document, rule['list']);
        List<Book> books = [];
        for (var node in nodes) {
          final author = parser.query(node, rule['author']);
          var cover = parser.query(node, rule['cover']);
          if (!cover.startsWith('http')) {
            cover = '${source.url}$cover';
          }
          final name = parser.query(node, rule['name']);
          final introduction = parser.query(node, rule['introduction']);
          var url = parser.query(node, rule['url']);
          if (!url.startsWith('http')) {
            url = '${source.url}$url';
          }
          var availableSource = AvailableSource();
          availableSource.id = source.id;
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
        books.shuffle();
        final layout = rule['layout'];
        final title = rule['title'];
        final result = ExploreResult(
          layout: layout,
          title: title,
          books: books,
        );
        sender.send(result);
        sender.send('close');
      } catch (error) {
        sender.send(error.toString());
      }
    });
  }

  static Future<Book> getInformation(
    String name,
    String url,
    Source source,
    Duration duration,
  ) async {
    final temporaryDirectory = await getTemporaryDirectory();
    final network = CachedNetwork(
      prefix: name,
      temporaryDirectory: temporaryDirectory,
    );
    final sender = ReceivePort();
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(
      _getInformationInIsolate,
      sender.sendPort,
    );
    (await sender.first as SendPort).send(
      [network, duration, url, source, receiver.sendPort],
    );
    final response = await receiver.first;
    if (response.runtimeType == Book) {
      isolate.kill();
      return response;
    } else {
      isolate.kill();
      throw Exception(response);
    }
  }

  static void _getInformationInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      final duration = message[1] as Duration;
      final url = message[2] as String;
      final source = message[3] as Source;
      final sender = message[4] as SendPort;
      try {
        final method = source.informationMethod.toUpperCase();
        final html = await network.request(
          url,
          charset: source.charset,
          duration: duration,
          method: method,
        );
        final parser = HtmlParser();
        final document = parser.parse(html);
        final author = parser.query(document, source.informationAuthor);
        var catalogueUrl =
            parser.query(document, source.informationCatalogueUrl);
        if (catalogueUrl.isEmpty) {
          catalogueUrl = url;
        }
        if (!catalogueUrl.startsWith('http')) {
          catalogueUrl = '${source.url}$catalogueUrl';
        }
        final category = parser.query(document, source.informationCategory);
        var cover = parser.query(document, source.informationCover);
        if (!cover.startsWith('http')) {
          cover = '${source.url}$cover';
        }
        final introduction =
            parser.query(document, source.informationIntroduction);
        final latestChapter = parser.query(
          document,
          source.informationLatestChapter,
        );
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
        sender.send(book);
        sender.send('close');
      } catch (error) {
        sender.send(error.toString());
      }
    });
  }

  static Future<Stream<Chapter>> getChapters(
    String name,
    String url,
    Source source,
    Duration duration,
  ) async {
    final temporaryDirectory = await getTemporaryDirectory();
    final network = CachedNetwork(
      prefix: name,
      temporaryDirectory: temporaryDirectory,
    );
    final controller = StreamController<Chapter>();
    final sender = ReceivePort();
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(_getChaptersInIsolate, sender.sendPort);
    (await sender.first as SendPort).send(
      [network, duration, url, source, receiver.sendPort],
    );
    receiver.forEach((element) async {
      if (element is Chapter) {
        controller.add(element);
      } else {
        isolate.kill();
        controller.close();
      }
    });
    return controller.stream;
  }

  static void _getChaptersInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      final duration = message[1] as Duration;
      final url = message[2] as String;
      final source = message[3] as Source;
      final sender = message[4] as SendPort;
      try {
        final charset = source.charset;
        final method = source.catalogueMethod.toUpperCase();
        final html = await network.request(
          url,
          charset: charset,
          duration: duration,
          method: method,
        );
        final parser = HtmlParser();
        var document = parser.parse(html);
        var preset = parser.query(document, source.cataloguePreset);
        final items = parser.queryNodes(document, source.catalogueChapters);
        var catalogueUrlRule = source.catalogueUrl;
        catalogueUrlRule = catalogueUrlRule.replaceAll('{{preset}}', preset);
        for (var i = 0; i < items.length; i++) {
          final name = parser.query(items[i], source.catalogueName);
          var url = parser.query(items[i], catalogueUrlRule);
          if (!url.startsWith('http')) {
            url = '${source.url}$url';
          }
          var chapter = Chapter();
          chapter.name = name;
          chapter.url = url;
          sender.send(chapter);
        }
        if (source.cataloguePagination.isNotEmpty) {
          var validation = parser.query(
            document,
            source.cataloguePaginationValidation,
          );
          while (validation.contains('下一页')) {
            var nextUrl = parser.query(document, source.cataloguePagination);
            if (!nextUrl.startsWith('http')) {
              nextUrl = '${source.url}$nextUrl';
            }
            var nextHtml = await network.request(
              nextUrl,
              charset: source.charset,
              method: source.catalogueMethod.toUpperCase(),
              reacquire: true,
            );
            document = parser.parse(nextHtml);
            var preset = parser.query(document, source.cataloguePreset);
            var items = parser.queryNodes(
              document,
              source.catalogueChapters,
            );
            var catalogueUrlRule = source.catalogueUrl;
            catalogueUrlRule = catalogueUrlRule.replaceAll(
              '{{preset}}',
              preset,
            );
            for (var i = 0; i < items.length; i++) {
              final name = parser.query(items[i], source.catalogueName);
              var url = parser.query(items[i], catalogueUrlRule);
              if (!url.startsWith('http')) {
                url = '${source.url}$url';
              }
              var chapter = Chapter();
              chapter.name = name;
              chapter.url = url;
              sender.send(chapter);
            }
            validation = parser.query(
              document,
              source.cataloguePaginationValidation,
            );
          }
        }
        sender.send('close');
      } catch (error) {
        sender.send(error.toString());
      }
    });
  }

  static Future<String> getLatestChapter(
    String name,
    String url,
    Source source,
    Duration duration,
  ) async {
    try {
      final book = await getInformation(name, url, source, duration);
      if (book.latestChapter.isNotEmpty) {
        return book.latestChapter;
      }
      final stream = await getChapters(
        name,
        book.catalogueUrl,
        source,
        duration,
      );
      final chapter = await stream.last;
      return chapter.name;
    } catch (error) {
      return '解析失败';
    }
  }

  static Future<String> getContent({
    required String name,
    required String url,
    required Source source,
    required String title,
    bool reacquire = false,
  }) async {
    final method = source.contentMethod.toUpperCase();
    final network = CachedNetwork(prefix: name);
    final html = await network.request(
      url,
      charset: source.charset,
      method: method,
      reacquire: reacquire,
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
          reacquire: reacquire,
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
    return '$title\n\n$content';
  }

  static Future<Stream<DebugResultNew>> debug(
    String credential,
    Source source,
    Duration duration,
  ) async {
    final temporaryDirectory = await getTemporaryDirectory();
    final network = CachedNetwork(temporaryDirectory: temporaryDirectory);
    final sender = ReceivePort();
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(_debugInIsolate, sender.sendPort);
    (await sender.first as SendPort).send(
      [network, duration, credential, source, receiver.sendPort],
    );
    final controller = StreamController<DebugResultNew>();
    var count = 0;
    receiver.forEach((element) async {
      if (element.runtimeType == DebugResultNew) {
        controller.add(element);
        count++;
        if (count == 4) {
          isolate.kill();
          controller.close();
        }
      } else {
        isolate.kill();
        controller.addError(element);
        controller.close();
      }
    });
    return controller.stream;
  }

  static void _debugInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      var duration = message[1] as Duration;
      var credential = message[2] as String;
      final source = message[3] as Source;
      final sender = message[4] as SendPort;

      final parser = HtmlParser();
      var result = DebugResultNew();
      var books = <Book>[];
      String catalogueUrl = '';
      String informationUrl = '';
      var chapters = <Chapter>[];
      try {
        // // 调试搜索解析规则
        result.title = '搜索';
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
          duration: duration,
          method: source.searchMethod.toUpperCase(),
          reacquire: true,
        );
        result.raw = html;
        var document = parser.parse(html);
        var items = parser.queryNodes(document, source.searchBooks);
        for (var i = 0; i < items.length; i++) {
          final author = parser.query(items[i], source.searchAuthor);
          final category = parser.query(items[i], source.searchCategory);
          var cover = parser.query(items[i], source.searchCover);
          if (!cover.startsWith('http')) {
            cover = '${source.url}$cover';
          }
          final introduction =
              parser.query(items[i], source.searchIntroduction);
          final latestChapter =
              parser.query(items[i], source.searchLatestChapter);
          final name = parser.query(items[i], source.searchName);
          // final status = parser.query(items[i], source.searchStatus);
          // final updatedAt = parser.query(items[i], source.searchUpdatedAt);
          var url = parser.query(items[i], source.searchInformationUrl);
          if (!url.startsWith('http')) {
            url = '${source.url}$url';
          }
          final words = parser.query(items[i], source.searchWordCount);

          var availableSource = AvailableSource();
          availableSource.id = source.id;
          availableSource.url = url;
          var book = Book();
          book.author = author;
          book.category = category;
          book.cover = cover;
          book.introduction = introduction;
          book.latestChapter = latestChapter;
          book.name = name;
          // book.status = status;
          // book.updatedAt = updatedAt;
          book.sourceId = source.id;
          book.sources = [availableSource];
          book.url = url;
          book.words = words;
          books.add(book);
        }
        final jsonList = books.map((book) => book.toJson()).toList();
        result.json = jsonEncode(jsonList);
      } catch (error) {
        sender.send(error.toString());
      }
      sender.send(result);
      if (books.isNotEmpty) {
        // 调试详情规则解析
        result.title = '详情';
        try {
          informationUrl = books.first.url;
          var html = await network.request(
            informationUrl,
            charset: source.charset,
            duration: duration,
            method: source.informationMethod.toUpperCase(),
            reacquire: true,
          );
          result.raw = html;
          var document = parser.parse(html);
          var author = parser.query(document, source.informationAuthor);
          catalogueUrl = parser.query(document, source.informationCatalogueUrl);
          if (catalogueUrl.isEmpty) {
            catalogueUrl = informationUrl;
          }
          if (!catalogueUrl.startsWith('http')) {
            catalogueUrl = '${source.url}$catalogueUrl';
          }
          var cover = parser.query(document, source.informationCover);
          if (!cover.startsWith('http')) {
            cover = '${source.url}$cover';
          }
          var category = parser.query(document, source.informationCategory);
          var introduction =
              parser.query(document, source.informationIntroduction);
          final latestChapter =
              parser.query(document, source.informationLatestChapter);
          var name = parser.query(document, source.informationName);
          // final updatedAt = parser.query(document, source.informationUpdatedAt);
          final words = parser.query(document, source.informationWordCount);
          var availableSource = AvailableSource();
          availableSource.id = source.id;
          availableSource.url = books.first.url;
          var book = Book();
          book.author = author;
          book.catalogueUrl = catalogueUrl;
          book.category = category;
          book.cover = cover;
          book.introduction = introduction;
          book.latestChapter = latestChapter;
          book.name = name;
          book.sourceId = source.id;
          book.sources = [availableSource];
          // book.updatedAt = updatedAt;
          book.url = informationUrl;
          book.words = words;
          result.json = jsonEncode(book.toJson());
        } catch (error) {
          sender.send(error.toString());
        }
        sender.send(result);
        // 调试目录解析规则
        result.title = '目录';
        try {
          var html = await network.request(
            catalogueUrl,
            charset: source.charset,
            duration: duration,
            method: source.catalogueMethod.toUpperCase(),
            reacquire: true,
          );
          result.raw = html;
          var document = parser.parse(html);
          var preset = parser.query(document, source.cataloguePreset);
          var items = parser.queryNodes(document, source.catalogueChapters);
          var catalogueUrlRule = source.catalogueUrl;
          catalogueUrlRule = catalogueUrlRule.replaceAll('{{preset}}', preset);
          for (var i = 0; i < items.length; i++) {
            final name = parser.query(items[i], source.catalogueName);
            var url = parser.query(items[i], catalogueUrlRule);
            if (!url.startsWith('http')) {
              url = '${source.url}$url';
            }
            var chapter = Chapter();
            chapter.name = name;
            chapter.url = url;
            chapters.add(chapter);
          }
          if (source.cataloguePagination.isNotEmpty) {
            var validation = parser.query(
              document,
              source.cataloguePaginationValidation,
            );
            while (validation.contains('下一页')) {
              var nextUrl = parser.query(document, source.cataloguePagination);
              if (!nextUrl.startsWith('http')) {
                nextUrl = '${source.url}$nextUrl';
              }
              var nextHtml = await network.request(
                nextUrl,
                charset: source.charset,
                method: source.catalogueMethod.toUpperCase(),
                reacquire: true,
              );
              document = parser.parse(nextHtml);
              var preset = parser.query(document, source.cataloguePreset);
              var items = parser.queryNodes(
                document,
                source.catalogueChapters,
              );
              var catalogueUrlRule = source.catalogueUrl;
              catalogueUrlRule = catalogueUrlRule.replaceAll(
                '{{preset}}',
                preset,
              );
              for (var i = 0; i < items.length; i++) {
                final name = parser.query(items[i], source.catalogueName);
                var url = parser.query(items[i], catalogueUrlRule);
                if (!url.startsWith('http')) {
                  url = '${source.url}$url';
                }
                var chapter = Chapter();
                chapter.name = name;
                chapter.url = url;
                chapters.add(chapter);
              }
              validation = parser.query(
                document,
                source.cataloguePaginationValidation,
              );
            }
          }
          var jsonList = chapters.map((chapter) => chapter.toJson()).toList();
          result.json = jsonEncode(jsonList);
        } catch (error) {
          sender.send(error.toString());
        }
        sender.send(result);
        // 调试正文解析规则
        result.title = '正文';
        try {
          if (chapters.isNotEmpty) {
            var html = await network.request(
              chapters.first.url,
              charset: source.charset,
              method: source.contentMethod.toUpperCase(),
              reacquire: true,
            );
            result.raw = html;
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
                  method: source.contentMethod.toUpperCase(),
                  reacquire: true,
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
            result.json = jsonEncode({'content': content});
          }
        } catch (error) {
          sender.send(error.toString());
        }
        sender.send(result);
      }
    });
  }

  static Future<List<Source>> importNetworkSource(String url) async {
    final network = CachedNetwork();
    final html = await network.request(url, reacquire: true);
    final json = jsonDecode(html);
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

  static Future<List<Source>> importLocalSource(String value) async {
    final json = jsonDecode(value);
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
