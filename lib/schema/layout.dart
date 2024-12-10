import 'package:isar/isar.dart';

part 'layout.g.dart';

@collection
@Name('layouts')
class Layout {
  Id? id;

  @enumerated
  @Name('app_bar_buttons')
  List<ButtonPosition> appBarButtons;

  @enumerated
  @Name('bottom_bar_buttons')
  List<ButtonPosition> bottomBarButtons;

  Layout({
    this.appBarButtons = const [],
    this.bottomBarButtons = const [],
  });

  bool get isValid => appBarButtons.length <= 2 && bottomBarButtons.length <= 3;
}

enum ButtonPosition {
  information,
  cache,
  darkMode,
  catalogue,
  source,
  theme,
  audio,
  previousChapter,
  nextChapter,
}
