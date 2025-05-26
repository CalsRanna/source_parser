import 'dart:convert';

import 'package:http/http.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_book_entity.dart';

class CloudReaderService {
  Future<List<CloudReaderBookEntity>> getBooksInShelf() async {
    var uri = Uri.parse('http://43.139.61.244:4396/reader3/getBookshelf');
    var response = await get(uri);
    var body = jsonDecode(response.body);
    return (body['data'] as List)
        .map((json) => CloudReaderBookEntity.fromJson(json))
        .toList();
  }
}
