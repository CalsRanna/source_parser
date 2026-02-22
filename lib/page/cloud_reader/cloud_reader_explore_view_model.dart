import 'package:signals/signals.dart';
import 'package:source_parser/model/cloud_explore_entity.dart';
import 'package:source_parser/model/cloud_search_book_entity.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';

class CloudReaderExploreViewModel {
  final sources = signal<List<CloudExploreSource>>([]);
  final selectedSource = signal<CloudExploreSource?>(null);
  final selectedCategory = signal<CloudExploreCategory?>(null);
  final books = signal<List<CloudExploreBook>>([]);
  final isLoading = signal(false);
  final isLoadingMore = signal(false);
  final error = signal('');

  int _currentPage = 1;
  bool _hasMore = true;

  Future<void> loadSources() async {
    isLoading.value = true;
    error.value = '';
    try {
      var result = await CloudReaderApiClient().getExploreSources();
      sources.value = result;
      if (result.isNotEmpty) {
        selectedSource.value = result.first;
        if (result.first.exploreCategories.isNotEmpty) {
          selectedCategory.value = result.first.exploreCategories.first;
          await loadBooks();
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectSource(CloudExploreSource source) async {
    if (selectedSource.value?.bookSourceUrl == source.bookSourceUrl) return;
    selectedSource.value = source;
    selectedCategory.value = null;
    books.value = [];
    _currentPage = 1;
    _hasMore = true;
    if (source.exploreCategories.isNotEmpty) {
      selectedCategory.value = source.exploreCategories.first;
      await loadBooks();
    }
  }

  Future<void> selectCategory(CloudExploreCategory category) async {
    if (selectedCategory.value?.url == category.url) return;
    selectedCategory.value = category;
    _currentPage = 1;
    _hasMore = true;
    await loadBooks();
  }

  Future<void> loadBooks() async {
    final source = selectedSource.value;
    final category = selectedCategory.value;
    if (source == null || category == null) return;

    isLoading.value = true;
    error.value = '';
    _currentPage = 1;
    try {
      var result = await CloudReaderApiClient().exploreBook(
        source.bookSourceUrl,
        category.url,
        page: _currentPage,
      );
      books.value = result;
      _hasMore = result.isNotEmpty;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !_hasMore) return;
    final source = selectedSource.value;
    final category = selectedCategory.value;
    if (source == null || category == null) return;

    isLoadingMore.value = true;
    _currentPage++;
    try {
      var result = await CloudReaderApiClient().exploreBook(
        source.bookSourceUrl,
        category.url,
        page: _currentPage,
      );
      if (result.isEmpty) {
        _hasMore = false;
      } else {
        books.value = [...books.value, ...result];
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingMore.value = false;
    }
  }

  CloudSearchBookEntity toSearchBook(CloudExploreBook book) {
    return book.toSearchBook();
  }
}
