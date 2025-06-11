import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/model/cover_entity.dart';

class BookInformationWrapperEntity {
  BookEntity book;
  List<ChapterEntity> chapters;
  List<AvailableSourceEntity> availableSources;
  List<CoverEntity> covers;

  BookInformationWrapperEntity({
    required this.book,
    required this.chapters,
    required this.availableSources,
    required this.covers,
  });
}
