import 'package:source_parser/model/available_source_entity.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/model/cover_entity.dart';

class SearchResultEntity {
  BookEntity book;
  List<AvailableSourceEntity> availableSources;
  List<CoverEntity> covers;

  SearchResultEntity({
    required this.book,
    required this.availableSources,
    required this.covers,
  });
}
