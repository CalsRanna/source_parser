import 'package:isar/isar.dart';

part 'layout.g.dart';

@collection
class ReaderLayout {
  Id? id;

  @enumerated
  List<ButtonPosition> appBarButtons;

  @enumerated
  List<ButtonPosition> bottomBarButtons;

  ReaderLayout({
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
