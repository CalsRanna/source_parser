import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/chapter_entity.dart';
import 'package:source_parser/model/cover_entity.dart';

class ParserSearchResultEntity {
  final AvailableSourceEntity availableSource;
  final BookEntity book;
  final List<ChapterEntity> chapters;
  final CoverEntity cover;

  ParserSearchResultEntity({
    required this.availableSource,
    required this.book,
    required this.chapters,
    required this.cover,
  });
}
