import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/model/cloud_chapter_entity.dart';
import 'package:source_parser/model/cloud_search_book_entity.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class CloudReaderApiClient {
  static final CloudReaderApiClient _instance = CloudReaderApiClient._();
  factory CloudReaderApiClient() => _instance;
  CloudReaderApiClient._();

  String _baseUrl = 'http://43.139.61.244:4396';
  String _accessToken = '';

  Future<void> loadConfig() async {
    _baseUrl = await SharedPreferenceUtil.getCloudReaderServerUrl();
    _accessToken = await SharedPreferenceUtil.getCloudReaderAccessToken();
  }

  void updateBaseUrl(String url) {
    _baseUrl = url;
  }

  void updateAccessToken(String token) {
    _accessToken = token;
  }

  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    var params = <String, String>{};
    if (_accessToken.isNotEmpty) {
      params['accessToken'] = _accessToken;
    }
    if (queryParameters != null) {
      params.addAll(queryParameters);
    }
    return Uri.parse('$_baseUrl$path').replace(queryParameters: params);
  }

  Future<Map<String, dynamic>> _parseResponse(http.Response response) async {
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['isSuccess'] == true) {
      return body;
    }
    throw Exception(body['errorMsg'] ?? '请求失败');
  }

  // Auth
  Future<String> login(String username, String password) async {
    var uri = _buildUri('/reader3/login');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password},
    );
    var body = await _parseResponse(response);
    var token = body['data']?.toString() ?? '';
    _accessToken = token;
    await SharedPreferenceUtil.setCloudReaderAccessToken(token);
    return token;
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    var uri = _buildUri('/reader3/getUserInfo');
    var response = await http.get(uri);
    var body = await _parseResponse(response);
    return body['data'] as Map<String, dynamic>;
  }

  // Bookshelf
  Future<List<CloudBookEntity>> getBookshelf() async {
    var uri = _buildUri('/reader3/getBookshelf');
    var response = await http.get(uri);
    var body = await _parseResponse(response);
    var data = body['data'] as List;
    return data.map((json) => CloudBookEntity.fromJson(json)).toList();
  }

  Future<void> saveBook(CloudBookEntity book) async {
    var uri = _buildUri('/reader3/saveBook');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(book.toJson()),
    );
    await _parseResponse(response);
  }

  Future<void> deleteBook(CloudBookEntity book) async {
    var uri = _buildUri('/reader3/deleteBook');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(book.toJson()),
    );
    await _parseResponse(response);
  }

  // Search
  Future<({List<CloudSearchBookEntity> list, int lastIndex})> searchBookMulti(
    String key, {
    int lastIndex = 0,
    int page = 1,
  }) async {
    var uri = _buildUri('/reader3/searchBookMulti', {
      'key': key,
      'lastIndex': lastIndex.toString(),
      'page': page.toString(),
    });
    var response = await http.get(uri);
    var body = await _parseResponse(response);
    var data = body['data'];
    if (data is List) {
      return (
        list: data.map((json) => CloudSearchBookEntity.fromJson(json)).toList(),
        lastIndex: 0,
      );
    }
    if (data is Map<String, dynamic>) {
      var list = data['list'] ?? [];
      return (
        list: (list as List)
            .map((json) => CloudSearchBookEntity.fromJson(json))
            .toList(),
        lastIndex: (data['lastIndex'] as int?) ?? 0,
      );
    }
    return (list: <CloudSearchBookEntity>[], lastIndex: 0);
  }

  // Book info
  Future<CloudBookEntity> getBookInfo(String bookUrl) async {
    var uri = _buildUri('/reader3/getBookInfo', {'url': bookUrl});
    var response = await http.get(uri);
    var body = await _parseResponse(response);
    return CloudBookEntity.fromJson(body['data']);
  }

  // Chapters
  Future<List<CloudChapterEntity>> getChapterList(String bookUrl) async {
    var uri = _buildUri('/reader3/getChapterList', {'url': bookUrl});
    var response = await http.get(uri);
    var body = await _parseResponse(response);
    var data = body['data'] as List;
    return data.map((json) => CloudChapterEntity.fromJson(json)).toList();
  }

  // Content
  Future<String> getBookContent(String bookUrl, int index) async {
    var uri = _buildUri('/reader3/getBookContent', {
      'url': bookUrl,
      'index': index.toString(),
    });
    var response = await http.get(uri);
    var body = await _parseResponse(response);
    return body['data']?.toString() ?? '';
  }

  // Source switching
  Future<({List<CloudSearchBookEntity> list, int lastIndex})>
      searchBookSource(String bookUrl, {int lastIndex = 0}) async {
    var params = {'url': bookUrl};
    if (lastIndex > 0) {
      params['lastIndex'] = lastIndex.toString();
    }
    var uri = _buildUri('/reader3/searchBookSource', params);
    var response = await http.get(uri);
    var body = await _parseResponse(response);
    var data = body['data'];
    if (data is List) {
      return (
        list: data.map((json) => CloudSearchBookEntity.fromJson(json)).toList(),
        lastIndex: 0,
      );
    }
    if (data is Map<String, dynamic>) {
      var list = data['list'] ?? [];
      return (
        list: (list as List)
            .map((json) => CloudSearchBookEntity.fromJson(json))
            .toList(),
        lastIndex: (data['lastIndex'] as int?) ?? 0,
      );
    }
    return (list: <CloudSearchBookEntity>[], lastIndex: 0);
  }

  Future<void> setBookSource(
    String bookUrl,
    String newUrl,
    String sourceUrl,
  ) async {
    var uri = _buildUri('/reader3/setBookSource');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'bookUrl': bookUrl,
        'newUrl': newUrl,
        'bookSourceUrl': sourceUrl,
      }),
    );
    await _parseResponse(response);
  }

  // Progress
  Future<void> saveBookProgress(String bookUrl, int chapterIndex) async {
    var uri = _buildUri('/reader3/saveBookProgress');
    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'url': bookUrl,
        'index': chapterIndex,
      }),
    );
    await _parseResponse(response);
  }

  // Cover
  String getCoverUrl(String coverUrl) {
    if (coverUrl.isEmpty) return '';
    if (coverUrl.startsWith('http://') || coverUrl.startsWith('https://')) {
      return coverUrl;
    }
    if (coverUrl.startsWith('//')) {
      return 'http:$coverUrl';
    }
    if (coverUrl.startsWith('/')) {
      return '$_baseUrl$coverUrl';
    }
    var uri = _buildUri('/reader3/cover', {'path': coverUrl});
    return uri.toString();
  }
}
