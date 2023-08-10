import 'package:creator/creator.dart';
import 'package:source_parser/model/book.dart';

final currentBookCreator = Creator.value(
  Book(
    author: '',
    catalogueUrl: '',
    category: '',
    cover: '',
    introduction: '',
    name: '',
    url: '',
  ),
  name: 'currentBookCreator',
);
