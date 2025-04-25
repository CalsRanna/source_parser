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
    availableSources.value =
        await AvailableSourceService().getAvailableSources(book.id);
  }

  Future<void> refreshAvailableSources() async {
    var stream = ParserUtil.instance.getAvailableSources(book);
    await for (var item in stream) {
      availableSources.value = [...availableSources.value, item];
    }
    var isInShelf = await BookService().exist(book.id);
    if (!isInShelf) return;
    for (var item in availableSources.value) {
      item.bookId = book.id;
      var exist = await AvailableSourceService().exist(item.url);
      if (!exist) {
        await AvailableSourceService().addAvailableSource(item);
      } else {
        await AvailableSourceService().updateAvailableSource(item);
      }
    }
  }

  Future<void> navigateAvailableSourceFormPage(BuildContext context) async {}
}
