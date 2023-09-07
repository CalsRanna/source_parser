import 'package:creator/creator.dart';

final darkModeCreator = Creator.value(false, keepAlive: true, name: 'darkMode');

final lineSpaceCreator = Creator.value(
  1.0 + 0.618 * 2,
  keepAlive: true,
  name: 'lineSpaceCreator',
);

final exploreSourceCreator = Creator.value(
  0,
  keepAlive: true,
  name: 'exploreSource',
);
