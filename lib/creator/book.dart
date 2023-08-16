import 'package:creator/creator.dart';
import 'package:source_parser/model/book.dart';

final currentBookCreator = Creator.value(
  Book(),
  keepAlive: true,
  name: 'currentBookCreator',
);

final currentCursorCreator = Creator.value(
  0,
  keepAlive: true,
  name: 'currentCursorCreator',
);
