import 'package:signals/signals.dart';
import 'package:source_parser/database/cloud_available_source_service.dart';
import 'package:source_parser/model/cloud_available_source_entity.dart';
import 'package:source_parser/model/cloud_search_book_entity.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';

class CloudReaderSourceViewModel {
  final sources = signal<List<CloudSearchBookEntity>>([]);
  final isSearching = signal(false);
  final isLoadingMore = signal(false);
  final hasMore = signal(true);
  final error = signal('');

  int _lastIndex = 0;
  String _currentBookUrl = '';

  Future<void> searchSources(String bookUrl) async {
    isSearching.value = true;
    error.value = '';
    _lastIndex = 0;
    _currentBookUrl = bookUrl;

    // Load from local cache first
    try {
      var cached = await CloudAvailableSourceService().getSources(bookUrl);
      if (cached.isNotEmpty) {
        sources.value = cached.map((e) => e.toSearchEntity()).toList();
      }
    } catch (_) {}

    // Then fetch from API
    try {
      var result = await CloudReaderApiClient().searchBookSource(bookUrl);
      sources.value = result.list;
      _lastIndex = result.lastIndex;
      hasMore.value = result.list.isNotEmpty && result.lastIndex > 0;
      await _persistSources(bookUrl);
    } catch (e) {
      // Keep cached data on API failure; only set error if no cache
      if (sources.value.isEmpty) {
        error.value = e.toString();
      }
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
      await _persistSources(bookUrl);
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

  Future<void> _persistSources(String bookUrl) async {
    var entities = sources.value
        .map((e) => CloudAvailableSourceEntity.fromSearchEntity(bookUrl, e))
        .toList();
    await CloudAvailableSourceService().replaceSources(bookUrl, entities);
  }
}
