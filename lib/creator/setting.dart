import 'package:creator/creator.dart';
import 'package:flutter/material.dart';

final backgroundColorCreator = Creator.value(
  Colors.white.value,
  keepAlive: true,
  name: 'backgroundColorCreator',
);

final darkModeCreator = Creator.value(false, keepAlive: true, name: 'darkMode');

final fontSizeCreator = Creator.value(18, keepAlive: true, name: 'fontSize');

final lineSpaceCreator = Creator.value(
  1.0 + 0.618 * 2,
  keepAlive: true,
  name: 'lineSpaceCreator',
);

final eInkModeCreator = Creator.value(false, keepAlive: true, name: 'eInkMode');

final exploreSourceCreator = Creator.value(
  0,
  keepAlive: true,
  name: 'exploreSource',
);

final shelfModeCreator = Creator.value(
  'list',
  keepAlive: true,
  name: 'shelfMode',
);
final turningModeCreator = Creator.value(
  3,
  keepAlive: true,
  name: 'turningModeCreator',
);
