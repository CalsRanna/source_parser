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
    sourceId: 0,
    sources: [0],
    url: '',
  ),
  keepAlive: true,
  name: 'currentBookCreator',
);

final currentCursorCreator = Creator.value(0, name: 'currentCursorCreator');
