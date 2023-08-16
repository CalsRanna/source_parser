import 'package:creator/creator.dart';
import 'package:source_parser/model/chapter.dart';

final currentChaptersCreator = Creator<List<Chapter>>.value(
  [],
  keepAlive: true,
  name: 'currentChaptersCreator',
);

final currentChapterIndexCreator = Creator.value(
  0,
  keepAlive: true,
  name: 'currentChapterIndexCreator',
);