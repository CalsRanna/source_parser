import 'dart:convert';
import 'dart:isolate';

import 'package:path_provider/path_provider.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/model/debug.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class SourceFormDebugViewModel {
  final source = signal(SourceEntity());
  final books = signal(<BookEntity>[]);
  final book = signal(BookEntity());
  final chapters = signal(<ChapterEntity>[]);
  final content = signal('');

  final _searchResult = signal(DebugResultEntity());
  final _informationResult = signal(DebugResultEntity());
  final _catalogueResult = signal(DebugResultEntity());
  final _contentResult = signal(DebugResultEntity());

  final _debugCredential = '都市';

  Stream<DebugResultEntity> debug() async* {
    var hours = await SharedPreferenceUtil.getCacheDuration();
    var duration = Duration(hours: hours);
    var seconds = await SharedPreferenceUtil.getTimeout();
    var timeout = Duration(seconds: seconds);
    final directory = await getTemporaryDirectory();
    final network = CachedNetwork(
      temporaryDirectory: directory,
      timeout: timeout,
    );
    final sender = ReceivePort();
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(_debugInIsolate, sender.sendPort);
    final messages = [
      network,
      duration,
      _debugCredential,
      source,
      receiver.sendPort
    ];
    (await sender.first as SendPort).send(messages);
    await for (var item in receiver) {
      if (item is DebugResultEntity) {
        switch (item.title) {
          case '搜索':
            _searchResult.value = item;
            break;
          case '详情':
            _informationResult.value = item;
            break;
          case '目录':
            _catalogueResult.value = item;
            break;
          case '正文':
            _contentResult.value = item;
            break;
          default:
            break;
        }
      } else {
        isolate.kill();
        receiver.close();
      }
    }
  }

  static void _debugInIsolate(SendPort message) {
    final port = ReceivePort();
    message.send(port.sendPort);
    port.listen((message) async {
      final network = message[0] as CachedNetwork;
      // var duration = message[1] as Duration;
      var credential = message[2] as String;
      final source = message[3] as SourceEntity;
      final sender = message[4] as SendPort;

      final parser = HtmlParser();
      var result = DebugResultEntity();
      var books = <BookEntity>[];
      var book = BookEntity();
      var chapters = <ChapterEntity>[];
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
      if (books.isEmpty) sender.send('terminated');
      // 调试详情规则解析
      result.title = '详情';
      try {
        final method = source.informationMethod.toUpperCase();
        result.html = await helper.fetchHtml(books.first.url, method: method);
        book = await helper.getBook(result.html, url: books.first.url);
        result.json = jsonEncode(book.toJson());
        sender.send(result);
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
      if (book.catalogueUrl.isEmpty) sender.send('terminated');
      // 调试目录解析规则
      result.title = '目录';
      try {
        final method = source.catalogueMethod.toUpperCase();
        result.html = await helper.fetchHtml(book.catalogueUrl, method: method);
        chapters = await helper.getChapters(result.html);
        var jsonList = chapters.map((chapter) => chapter.toJson()).toList();
        result.json = jsonEncode(jsonList);
        sender.send(result);
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
      if (chapters.isEmpty) sender.send('terminated');
      // 调试正文解析规则
      result.title = '正文';
      try {
        final chapterUrl = chapters.first.url;
        final method = source.contentMethod.toUpperCase();
        result.html = await helper.fetchHtml(chapterUrl, method: method);
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
}
