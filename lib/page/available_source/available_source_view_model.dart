import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/available_source/available_source_bottom_sheet.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/parser_util.dart';

class AvailableSourceViewModel {
  final availableSources = signal(<AvailableSourceEntity>[]);
  final book = signal(BookEntity());

  bool checkIsActive(int index) {
    return availableSources.value[index].sourceId == book.value.sourceId;
  }

  Future<void> initSignals({
    required List<AvailableSourceEntity> availableSources,
    required BookEntity book,
  }) async {
    this.availableSources.value = availableSources;
    this.book.value = book;
    if (availableSources.isEmpty) {
      refreshAvailableSources();
    }
  }

  Future<void> navigateAvailableSourceFormPage(BuildContext context) async {
    var result = await AvailableSourceFormRoute().push<String?>(context);
    if (result == null) return;
    if (result.isEmpty) return;
  }

  void openBottomSheet(int index) {
    var availableSource = availableSources.value[index];
    var bottomSheet = AvailableSourceBottomSheet(
      onDestroy: () => _destroyAvailableSource(availableSource),
    );
    DialogUtil.openBottomSheet(bottomSheet);
  }

  Future<void> refreshAvailableSources() async {
    var stream = ParserUtil.instance.getAvailableSources(book.value);
    var updatedSources = List<AvailableSourceEntity>.from(
      availableSources.value,
    );
    await for (var item in stream) {
      item.bookId = book.value.id;
      var index = updatedSources.indexWhere((source) => source.url == item.url);
      if (index != -1) {
        var existingId = updatedSources[index].id;
        updatedSources[index] = item;
        updatedSources[index].id = existingId;
      } else {
        updatedSources.add(item);
      }
    }
    availableSources.value = [...updatedSources];
    var isInShelf = await BookService().checkIsInShelf(book.value.id);
    if (!isInShelf) return;
    for (var availableSource in availableSources.value) {
      if (availableSource.id == 0) {
        await AvailableSourceService().addAvailableSource(availableSource);
      } else {
        await AvailableSourceService().updateAvailableSource(availableSource);
      }
    }
  }

  Future<void> updateAvailableSource(BuildContext context, int index) async {
    var availableSource = availableSources.value[index];
    Navigator.of(context).pop(availableSource);
  }

  Future<void> _destroyAvailableSource(
    AvailableSourceEntity availableSource,
  ) async {
    var isInShelf = await BookService().checkIsInShelf(book.value.id);
    if (!isInShelf) {
      availableSources.value
          .removeWhere((source) => source.id == availableSource.id);
      return;
    }
    var service = AvailableSourceService();
    await service.destroyAvailableSource(availableSource.id);
    availableSources.value = await service.getAvailableSources(book.value.id);
  }
}
