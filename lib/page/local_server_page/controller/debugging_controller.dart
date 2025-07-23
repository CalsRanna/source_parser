import 'dart:convert';
import 'dart:isolate';

import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/page/local_server_page/controller/controller.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class LocalServerDebuggingController with LocalServerController {
  static LocalServerDebuggingController? _instance;

  static LocalServerDebuggingController get instance =>
      _instance ??= LocalServerDebuggingController._();

  LocalServerDebuggingController._();

  Future<Response> debug(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    var id = json['source_id'];
    var source = await SourceService().getBookSource(id);
    return switch (json['type']) {
      'search' => await _search(source),
      'detail' => await _detail(source, json['url']),
      'chapter' => await _chapter(source, json['url']),
      'content' => await _content(source, json['url']),
      _ => error('Invalid type'),
    };
  }

  Future<Response> _chapter(SourceEntity source, String url) async {
    final network = await _getCacheNetwork('debugging');
    final sender = ReceivePort();
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(_chapterInIsolate, sender.sendPort);
    final messages = [network, url, source, receiver.sendPort];
    (await sender.first as SendPort).send(messages);
    List<DebugResultEntity> results = [];
    await for (var item in receiver) {
      if (item is DebugResultEntity) {
        results.add(item);
      } else {
        isolate.kill();
        receiver.close();
      }
    }
    return response(results.first);
  }

  Future<Response> _content(SourceEntity source, String url) async {
    final network = await _getCacheNetwork('debugging');
    final sender = ReceivePort();
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(_contentInIsolate, sender.sendPort);
    final messages = [network, url, source, receiver.sendPort];
    (await sender.first as SendPort).send(messages);
    List<DebugResultEntity> results = [];
    await for (var item in receiver) {
      if (item is DebugResultEntity) {
        results.add(item);
      } else {
        isolate.kill();
        receiver.close();
      }
    }
    return response(results.first);
  }

  Future<Response> _detail(SourceEntity source, String url) async {
    final network = await _getCacheNetwork('debugging');
    final sender = ReceivePort();
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(_detailInIsolate, sender.sendPort);
    final messages = [network, url, source, receiver.sendPort];
    (await sender.first as SendPort).send(messages);
    List<DebugResultEntity> results = [];
    await for (var item in receiver) {
      if (item is DebugResultEntity) {
        results.add(item);
      } else {
        isolate.kill();
        receiver.close();
      }
    }
    return response(results.first);
  }

  Future<CachedNetwork> _getCacheNetwork(String? prefix) async {
    // var hours = await SharedPreferenceUtil.getCacheDuration();
    // var duration = Duration(hours: hours);
    var seconds = await SharedPreferenceUtil.getTimeout();
    var timeout = Duration(seconds: seconds);
    final directory = await getApplicationCacheDirectory();
    return CachedNetwork(
      prefix: 'debugging',
      cacheDirectory: directory,
      timeout: timeout,
    );
  }

  Future<Response> _search(SourceEntity source) async {
    final network = await _getCacheNetwork('debugging');
    final sender = ReceivePort();
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(_searchInIsolate, sender.sendPort);
    final messages = [network, '都市', source, receiver.sendPort];
    (await sender.first as SendPort).send(messages);
    List<DebugResultEntity> results = [];
    await for (var item in receiver) {
      logger.d(item);
      if (item is DebugResultEntity) {
        results.add(item);
      } else {
        isolate.kill();
        receiver.close();
      }
    }
    return response(results.first);
  }

  static void _chapterInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      // var duration = message[1] as Duration;
      var url = message[1] as String;
      final source = message[2] as SourceEntity;
      final sender = message[3] as SendPort;

      var result = DebugResultEntity();
      final helper = ParserUtil(network, source);
      // // 调试目录解析规则
      result.title = '目录';
      try {
        final method = source.catalogueMethod.toUpperCase();
        result.html = await helper.fetchHtml(url, method: method);
        var chapters = await helper.getChapters(result.html);
        var jsonList = chapters.map((chapter) => chapter.toJson()).toList();
        result.json = jsonEncode(jsonList);
        sender.send(result);
        sender.send('completed');
      } catch (error, stackTrace) {
        result.html = error.toString();
        final map = {
          'error': error.toString(),
          'stackTrace': stackTrace.toString(),
        };
        result.json = jsonEncode([map]);
        sender.send(result);
        sender.send('terminated');
        return;
      }
    });
  }

  static void _contentInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      // var duration = message[1] as Duration;
      var url = message[1] as String;
      final source = message[2] as SourceEntity;
      final sender = message[3] as SendPort;

      var result = DebugResultEntity();
      final helper = ParserUtil(network, source);
      final parser = HtmlParser();
      // 调试正文解析规则
      result.title = '正文';
      try {
        final method = source.contentMethod.toUpperCase();
        result.html = await helper.fetchHtml(url, method: method);
        var document = parser.parse(result.html);
        var content = parser.query(document, source.contentContent);
        result.json = jsonEncode({'content': content});
        sender.send(result);
        sender.send('completed');
      } catch (error, stackTrace) {
        result.html = error.toString();
        final map = {
          'error': error.toString(),
          'stackTrace': stackTrace.toString(),
        };
        result.json = jsonEncode(map);
        sender.send(result);
        sender.send('terminated');
        return;
      }
    });
  }

  static void _detailInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      // var duration = message[1] as Duration;
      var url = message[1] as String;
      final source = message[2] as SourceEntity;
      final sender = message[3] as SendPort;

      var result = DebugResultEntity();
      final helper = ParserUtil(network, source);
      // 调试详情规则解析
      result.title = '详情';
      try {
        final method = source.informationMethod.toUpperCase();
        result.html = await helper.fetchHtml(url, method: method);
        var book = await helper.getBook(result.html, url: url);
        result.json = jsonEncode(book.toJson());
        sender.send(result);
        sender.send('completed');
      } catch (error, stackTrace) {
        result.html = error.toString();
        final map = {
          'error': error.toString(),
          'stackTrace': stackTrace.toString(),
        };
        result.json = jsonEncode(map);
        sender.send(result);
        sender.send('terminated');
        return;
      }
    });
  }

  static void _searchInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      // var duration = message[1] as Duration;
      var credential = message[1] as String;
      final source = message[2] as SourceEntity;
      final sender = message[3] as SendPort;

      var result = DebugResultEntity();
      var books = <BookEntity>[];
      final helper = ParserUtil(network, source);
      // 调试搜索解析规则
      try {
        result.title = '搜索';
        credential = helper.encodeCredential(credential);
        final searchUrl = helper.buildSearchUrl(credential);
        final method = source.searchMethod.toUpperCase();
        result.html = await helper.fetchHtml(searchUrl, method: method);
        books = await helper.search(result.html);
        final jsonList = books.map((book) => book.toJson()).toList();
        result.json = jsonEncode(jsonList);
        sender.send(result);
        sender.send('completed');
      } catch (error, stackTrace) {
        result.html = error.toString();
        final map = {
          'error': stackTrace.toString(),
          'stackTrace': stackTrace.toString(),
        };
        result.json = jsonEncode([map]);
        sender.send(result);
        sender.send('terminated');
        return;
      }
    });
  }
}
