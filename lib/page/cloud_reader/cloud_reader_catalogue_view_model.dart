import 'package:signals/signals.dart';
import 'package:source_parser/database/cloud_chapter_service.dart';
import 'package:source_parser/model/cloud_chapter_entity.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';

class CloudReaderCatalogueViewModel {
  final chapters = signal<List<CloudChapterEntity>>([]);
  final currentIndex = signal(0);
  final isLoading = signal(false);

  Future<void> loadChapters(String bookUrl, int current) async {
    currentIndex.value = current;
    isLoading.value = true;
    try {
      var local = await CloudChapterService().getChapters(bookUrl);
      if (local.isNotEmpty) {
        chapters.value = local;
      } else {
        chapters.value = await CloudReaderApiClient().getChapterList(bookUrl);
      }
    } catch (_) {}
    isLoading.value = false;
  }
}
