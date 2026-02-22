import 'package:signals/signals.dart';
import 'package:source_parser/model/cloud_search_book_entity.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';

class CloudReaderSourceViewModel {
  final sources = signal<List<CloudSearchBookEntity>>([]);
  final isSearching = signal(false);
  final isLoadingMore = signal(false);
  final hasMore = signal(true);
  final error = signal('');

  int _lastIndex = 0;

  Future<void> searchSources(String bookUrl) async {
    isSearching.value = true;
    error.value = '';
    _lastIndex = 0;
    try {
      var result = await CloudReaderApiClient().searchBookSource(bookUrl);
      sources.value = result.list;
      _lastIndex = result.lastIndex;
      hasMore.value = result.list.isNotEmpty && result.lastIndex > 0;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadMore(String bookUrl) async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    try {
      var result = await CloudReaderApiClient().searchBookSource(
        bookUrl,
        lastIndex: _lastIndex,
      );
      sources.value = [...sources.value, ...result.list];
      _lastIndex = result.lastIndex;
      hasMore.value = result.list.isNotEmpty && result.lastIndex > 0;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<bool> switchSource(
    String bookUrl,
    CloudSearchBookEntity newSource,
  ) async {
    try {
      await CloudReaderApiClient().setBookSource(
        bookUrl,
        newSource.bookUrl,
        newSource.origin,
      );
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }
}
