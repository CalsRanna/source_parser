import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/available_source_service.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/book_source_service.dart';
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
import 'package:source_parser/util/logger.dart';
import 'package:source_parser/util/parser_util.dart';

class InformationViewModel {
  final InformationEntity information;
  final availableSources = signal(<AvailableSourceEntity>[]);
  final chapters = signal(<ChapterEntity>[]);
  final covers = signal(<CoverEntity>[]);
  final currentSource = signal(AvailableSourceEntity());
  final isInShelf = signal(false);

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
      try {
        availableSources.value = await AvailableSourceService()
            .getAvailableSources(information.book.id);
        chapters.value =
            await ChapterService().getChapters(information.book.id);
        covers.value = await CoverService().getCovers(information.book.id);
        currentSource.value = await AvailableSourceService()
            .getAvailableSource(information.book.sourceId);
      } catch (error) {
        logger.e(error.toString());
      }
    } else {
      availableSources.value = information.availableSources;
      chapters.value = information.chapters;
      covers.value = information.covers;
      currentSource.value = information.availableSources.first;
    }
    if (chapters.value.isEmpty) {
      var source =
          await BookSourceService().getBookSource(currentSource.value.id);
      chapters.value = await _getRemoteChapters(information.book, source);
    }
  }

  Future<void> navigateAvailableSourcePage(BuildContext context) async {
    var id =
        await AvailableSourceRoute(book: information.book).push<int>(context);
    await refreshAvailableSources();
    if (id == null) return;
    currentSource.value =
        availableSources.value.firstWhere((item) => item.id == id);
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
