import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/database/cover_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/model/cover_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
// import 'package:source_parser/router/router.gr.dart';

class InformationViewModel {
  final BookEntity book;
  final availableSources = signal(<AvailableSourceEntity>[]);
  final chapters = signal(<ChapterEntity>[]);
  final covers = signal(<CoverEntity>[]);
  final currentSource = signal(AvailableSourceEntity());
  final isInShelf = signal(false);

  InformationViewModel({required this.book});

  Future<void> changeIsInShelf(BookEntity book) async {
    isInShelf.value = !isInShelf.value;
    var bookshelfViewModel = GetIt.instance<BookshelfViewModel>();
    if (isInShelf.value) {
      bookshelfViewModel.books.value.add(book);
      await BookService().addToBookshelf(book);
    } else {
      bookshelfViewModel.books.value.removeWhere((item) => item.id == book.id);
      await BookService().removeFromBookshelf(book.id);
    }
  }

  Future<void> initSignals() async {
    isInShelf.value = await BookService().getIsInShelf(book.id);
    if (isInShelf.value) {
      try {
        availableSources.value =
            await AvailableSourceService().getAvailableSources(book.id);
        chapters.value = await ChapterService().getChapters(book.id);
        covers.value = await CoverService().getCovers(book.id);
        currentSource.value = await AvailableSourceService()
            .getAvailableSource(book.availableSourceId);
      } catch (error) {
        availableSources.value = [];
        currentSource.value = AvailableSourceEntity();
      }
    } else {}
  }

  void navigateAvailableSourcePage(BuildContext context) {
    // AvailableSourceListRoute().push(context);
  }

  void navigateCataloguePage(BuildContext context) {
    CatalogueRoute(book: book).push(context);
  }
}
