import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/router/router.gr.dart';
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

  Future<void> refreshAvailableSources() async {
    var isInShelf = await BookService().checkIsInShelf(book.value.id);
    var stream = ParserUtil.instance.getAvailableSources(book.value);
    var updatedSources = List<AvailableSourceEntity>.from(
      availableSources.value,
    );
    await for (var item in stream) {
      item.bookId = book.value.id;
      var existingIndex = updatedSources.indexWhere(
        (source) => source.url == item.url,
      );
      if (existingIndex != -1) {
        var existingId = updatedSources[existingIndex].id;
        updatedSources[existingIndex] = item;
        updatedSources[existingIndex].id = existingId;
      } else {
        updatedSources.add(item);
      }
    }
    availableSources.value = [...updatedSources];
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
    Navigator.of(context).pop(availableSource.sourceId);
  }
}
