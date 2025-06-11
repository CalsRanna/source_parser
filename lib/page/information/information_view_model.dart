import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/database/chapter_service.dart';
import 'package:source_parser/database/cover_service.dart';
import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/model/cover_entity.dart';
import 'package:source_parser/model/information_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/html_parser_plus.dart';
import 'package:source_parser/util/parser_util.dart';

class InformationViewModel {
  final InformationEntity information;
  final availableSources = signal(<AvailableSourceEntity>[]);
  final book = signal(BookEntity());
  final chapters = signal(<ChapterEntity>[]);
  final covers = signal(<CoverEntity>[]);
  final source = signal(SourceEntity());
  final isInShelf = signal(false);
  final isLoading = signal(false);

  InformationViewModel({required this.information});

  Future<void> changeIsInShelf(BookEntity book) async {
    isInShelf.value = !isInShelf.value;
    var bookshelfViewModel = GetIt.instance<BookshelfViewModel>();
    if (isInShelf.value) {
      bookshelfViewModel.books.value.add(book);
      await BookService().addBook(book);
      await AvailableSourceService()
          .addAvailableSources(availableSources.value);
      await CoverService().addCovers(covers.value);
      await ChapterService().addChapters(chapters.value);
    } else {
      bookshelfViewModel.books.value.removeWhere((item) => item.id == book.id);
      await BookService().destroyBook(book.id);
    }
  }

  Future<void> initSignals() async {
    isInShelf.value = await BookService().exist(information.book.id);
    if (isInShelf.value) {
      var bookId = information.book.id;
      book.value = await BookService().getBook(bookId);
      availableSources.value =
          await AvailableSourceService().getAvailableSources(bookId);
      chapters.value = await ChapterService().getChapters(bookId);
      covers.value = await CoverService().getCovers(bookId);
      source.value = await SourceService().getBookSource(bookId);
    } else {
      book.value = information.book;
      availableSources.value = information.availableSources;
      chapters.value = information.chapters;
      covers.value = information.covers;
      var sourceId = information.availableSources.first.sourceId;
      source.value = await SourceService().getBookSource(sourceId);
      if (chapters.value.isEmpty) {
        isLoading.value = true;
        var source = await SourceService().getBookSource(this.source.value.id);
        chapters.value = await _getRemoteChapters(information.book, source);
        isLoading.value = false;
      }
    }
  }

  Future<void> navigateAvailableSourcePage(BuildContext context) async {
    var id =
        await AvailableSourceRoute(book: information.book).push<int>(context);
    await refreshAvailableSources();
    if (id == null) return;
    var sourceId =
        availableSources.value.firstWhere((item) => item.id == id).sourceId;
    source.value = await SourceService().getBookSource(sourceId);
  }

  void navigateCataloguePage(BuildContext context) {
    CatalogueRoute(book: information.book).push(context);
  }

  Future<void> navigateReaderPage(BuildContext context, BookEntity book) async {
    if (!isInShelf.value) {
      await BookService().addBook(book);
      await AvailableSourceService()
          .addAvailableSources(availableSources.value);
      await CoverService().addCovers(covers.value);
      await ChapterService().addChapters(chapters.value);
      isInShelf.value = true;
    }
    if (!context.mounted) return;
    ReaderRoute(book: book).push(context);
  }

  Future<void> refreshAvailableSources() async {
    availableSources.value =
        await AvailableSourceService().getAvailableSources(information.book.id);
    if (availableSources.value.isNotEmpty) return;
    var stream = ParserUtil.instance.getAvailableSources(information.book);
    await for (var availableSource in stream) {
      availableSources.value = [...availableSources.value, availableSource];
    }
  }

  Future<List<ChapterEntity>> _getRemoteChapters(
      BookEntity book, SourceEntity source) async {
    var network = CachedNetwork(prefix: book.name);
    var html = await network.request(book.catalogueUrl);
    final parser = HtmlParser();
    var document = parser.parse(html);
    var preset = parser.query(document, source.cataloguePreset);
    var items = parser.queryNodes(document, source.catalogueChapters);
    List<ChapterEntity> chapters = [];
    var catalogueUrlRule = source.catalogueUrl;
    catalogueUrlRule = catalogueUrlRule.replaceAll('{{preset}}', preset);
    for (var i = 0; i < items.length; i++) {
      final name = parser.query(items[i], source.catalogueName);
      var url = parser.query(items[i], catalogueUrlRule);
      if (!url.startsWith('http')) url = '${source.url}$url';
      final chapter = ChapterEntity();
      chapter.name = name;
      chapter.url = url;
      chapter.bookId = book.id;
      chapters.add(chapter);
    }
    return chapters;
  }
}
