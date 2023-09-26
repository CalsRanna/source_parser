import 'package:creator/creator.dart';
import 'package:source_parser/model/explore.dart';

final exploreLoadingCreator = Creator<bool>.value(
  true,
  keepAlive: true,
  name: 'exploreLoadingCreator',
);

final exploreBooksCreator = Creator<List<ExploreResult>>.value(
  [],
  keepAlive: true,
  name: 'exploreBooksCreator',
);
