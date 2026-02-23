import 'package:signals/signals.dart';
import 'package:source_parser/model/cloud_explore_entity.dart';
import 'package:source_parser/model/cloud_search_book_entity.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';

class CloudReaderExploreViewModel {
  final sources = signal<List<CloudExploreSource>>([]);
  final selectedSource = signal<CloudExploreSource?>(null);
  final results = signal<List<CloudExploreResult>>([]);
  final isLoading = signal(false);
  final error = signal('');

  Future<void> loadSources() async {
    isLoading.value = true;
    error.value = '';
    try {
      var result = await CloudReaderApiClient().getExploreSources();
      sources.value = result;
      if (result.isNotEmpty) {
        selectedSource.value = result.first;
        await loadAllCategories();
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
    results.value = [];
    await loadAllCategories();
  }

  Future<void> loadAllCategories() async {
    final source = selectedSource.value;
    if (source == null || source.exploreCategories.isEmpty) return;

    isLoading.value = true;
    error.value = '';
    try {
      final categories = source.exploreCategories;
      final futures = categories.map((category) {
        return CloudReaderApiClient().exploreBook(
          source.bookSourceUrl,
          category.url,
        );
      }).toList();
      final responses = await Future.wait(futures);
      final list = <CloudExploreResult>[];
      for (var i = 0; i < categories.length; i++) {
        final books = responses[i];
        if (books.isEmpty) continue;
        final String layout;
        if (list.isEmpty) {
          layout = 'banner';
        } else if (list.length.isOdd) {
          layout = 'card';
        } else {
          layout = 'grid';
        }
        list.add(CloudExploreResult(
          layout: layout,
          title: categories[i].title,
          books: books,
        ));
      }
      results.value = list;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  CloudSearchBookEntity toSearchBook(CloudExploreBook book) {
    return book.toSearchBook();
  }
}
