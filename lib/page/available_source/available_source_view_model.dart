import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/util/parser_util.dart';

class AvailableSourceViewModel {
  final BookEntity book;
  AvailableSourceViewModel({required this.book});

  var availableSources = signal(<AvailableSourceEntity>[]);

  Future<void> initSignals() async {
    var exist = await BookService().exist(book.id);
    if (!exist) {
      var stream = ParserUtil.instance.getAvailableSources(book);
      await for (var availableSource in stream) {
        availableSources.value = [...availableSources.value, availableSource];
      }
    } else {
      availableSources.value =
          await AvailableSourceService().getAvailableSources(book.id);
    }
  }

  Future<void> refreshAvailableSources() async {
    var stream = ParserUtil.instance.getAvailableSources(book);
    await for (var item in stream) {
      availableSources.value = [...availableSources.value, item];
    }
    var isInShelf = await BookService().exist(book.id);
    if (!isInShelf) return;
    for (var availableSource in availableSources.value) {
      availableSource.bookId = book.id;
      var exist = await AvailableSourceService().exist(availableSource.url);
      if (!exist) {
        await AvailableSourceService().addAvailableSource(availableSource);
      } else {
        await AvailableSourceService().updateAvailableSource(availableSource);
      }
    }
  }

  Future<void> navigateAvailableSourceFormPage(BuildContext context) async {}

  Future<void> updateAvailableSource(BuildContext context, int index) async {
    var availableSource = availableSources.value[index];
    Navigator.of(context).pop(availableSource.id);
  }
}
