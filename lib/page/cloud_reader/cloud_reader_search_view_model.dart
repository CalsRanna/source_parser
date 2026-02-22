import 'package:signals/signals.dart';
import 'package:source_parser/model/cloud_book_entity.dart';
import 'package:source_parser/model/cloud_search_book_entity.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';

class CloudReaderSearchViewModel {
  final results = signal<List<CloudSearchBookEntity>>([]);
  final isSearching = signal(false);
  final error = signal('');

  String _lastKey = '';
  int _lastIndex = 0;
  int _page = 1;
  bool _hasMore = true;

  Future<void> search(String key) async {
    if (key.isEmpty) return;
    _lastKey = key;
    _lastIndex = 0;
    _page = 1;
    _hasMore = true;
    isSearching.value = true;
    error.value = '';
    results.value = [];
    try {
      var result = await CloudReaderApiClient().searchBookMulti(key);
      results.value = result.list;
      _lastIndex = result.lastIndex;
      _hasMore = result.list.isNotEmpty;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isSearching.value || !_hasMore || _lastKey.isEmpty) return;
    isSearching.value = true;
    _page++;
    try {
      var result = await CloudReaderApiClient().searchBookMulti(
        _lastKey,
        lastIndex: _lastIndex,
        page: _page,
      );
      if (result.list.isEmpty) {
        _hasMore = false;
      } else {
        results.value = [...results.value, ...result.list];
        _lastIndex = result.lastIndex;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isSearching.value = false;
    }
  }

  Future<bool> addToShelf(CloudSearchBookEntity searchBook) async {
    try {
      var book = CloudBookEntity()
        ..bookUrl = searchBook.bookUrl
        ..tocUrl = searchBook.tocUrl
        ..origin = searchBook.origin
        ..originName = searchBook.originName
        ..name = searchBook.name
        ..author = searchBook.author
        ..kind = searchBook.kind
        ..coverUrl = searchBook.coverUrl
        ..intro = searchBook.intro
        ..type = searchBook.type;
      await CloudReaderApiClient().saveBook(book);
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }
}
