import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:source_parser/util/cache_manager.dart';

class CachedNetwork {
  final String baseUrl;
  final Directory? cacheFolder;
  final CachedNetworkCharset charset;
  final int timeout;
  final BaseOptions _baseOptions;
  final Options? _options;

  CachedNetwork({
    required this.baseUrl,
    this.cacheFolder,
    this.charset = CachedNetworkCharset.utf8,
    this.timeout = 5000,
  })  : _baseOptions = BaseOptions(headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36'
        }),
        _options = Options(
          responseDecoder: ((responseBytes, options, responseBody) =>
              gbk_bytes.decode(responseBytes)),
        );

  Future<String?> get(String url, {bool permanent = true}) async {
    final cacheManager = CacheManager();
    final cachedContent = await cacheManager.get(
      url,
      cacheFolder: cacheFolder,
      permanent: permanent,
    );
    if (cachedContent != null) {
      return cachedContent;
    } else {
      final dio = Dio(_baseOptions);
      Response response;
      if (CachedNetworkCharset.utf8 == charset) {
        response = await dio.get(_completeUrl(url));
      } else {
        response = await dio.get(_completeUrl(url), options: _options);
      }
      await cacheManager.set(
        url,
        response.data,
        cacheFolder: cacheFolder,
      );
      return response.data;
    }
  }

  String _completeUrl(String url) {
    if (url.startsWith('http') == false) {
      url = baseUrl + url;
    }
    return url;
  }
}

enum CachedNetworkCharset { utf8, gbk }
