import 'package:creator/creator.dart';
import 'package:source_parser/model/explore.dart';

final exploreBooksCreator = Creator<List<ExploreResult>>.value(
  [],
  keepAlive: true,
  name: 'exploreBooksCreator',
);
